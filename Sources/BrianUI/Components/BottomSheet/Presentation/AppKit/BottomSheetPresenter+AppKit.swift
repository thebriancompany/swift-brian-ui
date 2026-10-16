#if os(macOS)
import AppKit
import SwiftUI

struct BrianBottomSheetPresenter<Content: View>: NSViewControllerRepresentable {
  @Binding var isPresented: Bool
  let content: (BrianBottomSheetPresentation) -> Content

  func makeCoordinator() -> BrianBottomSheetAppKitCoordinator<Content> {
    BrianBottomSheetAppKitCoordinator()
  }

  func makeNSViewController(context: Context) -> BrianModalAppKitAnchor {
    let anchor = BrianModalAppKitAnchor()
    context.coordinator.anchor = anchor
    anchor.attachmentChanged = { [weak coordinator = context.coordinator] in
      coordinator?.scheduleUpdate()
    }
    return anchor
  }

  func updateNSViewController(_ controller: BrianModalAppKitAnchor, context: Context) {
    context.coordinator.update(
      binding: $isPresented,
      content: isPresented ? content(context.coordinator.presentation) : nil,
      environment: context.environment
    )
  }

  static func dismantleNSViewController(
    _ controller: BrianModalAppKitAnchor,
    coordinator: BrianBottomSheetAppKitCoordinator<Content>
  ) {
    controller.attachmentChanged = nil
    DispatchQueue.main.async {
      coordinator.presentation.lifecycle.invalidate()
    }
  }
}

@MainActor
final class BrianBottomSheetAppKitCoordinator<Content: View> {
  weak var anchor: BrianModalAppKitAnchor?

  private var binding: Binding<Bool> = .constant(false)
  private var content: Content?
  private var environment = EnvironmentValues()
  private weak var parentWindow: NSWindow?
  private weak var previousResponder: NSResponder?
  private var panel: BrianBottomSheetPanel<Content>?
  private var host: NSHostingController<BrianBottomSheetHostedContent<Content>>?
  private var observers: [NSObjectProtocol] = []
  private var eventMonitor: Any?
  private var updateScheduled = false

  lazy var presentation = BrianBottomSheetPresentation(
    present: { [weak self] in self?.present() ?? false },
    remove: { [weak self] completion in
      guard let self else {
        completion()
        return
      }
      self.remove(completion: completion)
    }
  )

  func update(
    binding: Binding<Bool>,
    content: Content?,
    environment: EnvironmentValues
  ) {
    self.binding = binding
    if let content {
      self.content = content
    }
    self.environment = environment
    if let hostedContent {
      host?.rootView = hostedContent
    }
    panel?.appearance = NSAppearance(named: environment.colorScheme == .dark ? .darkAqua : .aqua)
    scheduleUpdate()
  }

  func scheduleUpdate() {
    guard !updateScheduled else { return }
    updateScheduled = true
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      self.updateScheduled = false
      let ready = self.anchor?.attachedWindow != nil
      self.presentation.lifecycle.update(
        isPresented: self.binding,
        onDismiss: nil,
        isReady: ready
      )
      if !ready {
        self.presentation.lifecycle.requestDismissal()
      }
    }
  }

  private var hostedContent: BrianBottomSheetHostedContent<Content>? {
    content.map {
      BrianBottomSheetHostedContent(
        content: $0,
        environment: environment
      )
    }
  }

  private func present() -> Bool {
    guard let hostedContent, let window = anchor?.attachedWindow else {
      return false
    }
    parentWindow = window
    previousResponder = window.firstResponder
    let panel = BrianBottomSheetPanel<Content>(
      contentRect: parentContentFrame,
      styleMask: [.borderless],
      backing: .buffered,
      defer: false
    )
    panel.isReleasedWhenClosed = false
    panel.isOpaque = false
    panel.backgroundColor = .clear
    panel.hasShadow = false
    panel.hidesOnDeactivate = false
    panel.isFloatingPanel = false
    panel.worksWhenModal = true
    panel.animationBehavior = .none
    panel.collectionBehavior = [.fullScreenAuxiliary]
    panel.level = window.level
    panel.appearance = NSAppearance(
      named: environment.colorScheme == .dark ? .darkAqua : .aqua
    )
    let host = NSHostingController(rootView: hostedContent)
    host.sizingOptions = []
    host.view.frame = CGRect(origin: .zero, size: parentContentFrame.size)
    panel.contentViewController = host
    panel.setFrame(parentContentFrame, display: false)
    host.view.layoutSubtreeIfNeeded()
    panel.owner = self
    self.panel = panel
    self.host = host
    installInputMonitor()
    observeParentWindow()
    window.addChildWindow(panel, ordered: .above)
    panel.makeKeyAndOrderFront(nil)
    panel.makeFirstResponder(host.view)
    return true
  }

  private var parentContentFrame: CGRect {
    guard let parentWindow, let content = parentWindow.contentView else {
      return .zero
    }
    return parentWindow.convertToScreen(content.convert(content.bounds, to: nil))
  }

  private func installInputMonitor() {
    eventMonitor = NSEvent.addLocalMonitorForEvents(matching: [
      .leftMouseDown, .leftMouseUp, .leftMouseDragged,
      .rightMouseDown, .rightMouseUp, .rightMouseDragged,
      .otherMouseDown, .otherMouseUp, .otherMouseDragged,
      .scrollWheel, .keyDown, .keyUp, .flagsChanged,
    ]) { [weak self] event in
      let blocked = MainActor.assumeIsolated {
        guard let self, let parentWindow = self.parentWindow else {
          return false
        }
        return event.window === parentWindow
      }
      return blocked ? nil : event
    }
  }

  private func observeParentWindow() {
    for name in [NSWindow.didResizeNotification, NSWindow.didMoveNotification] {
      observers.append(
        NotificationCenter.default.addObserver(
          forName: name, object: parentWindow, queue: .main
        ) { [weak self] _ in
          MainActor.assumeIsolated {
            guard let self else {
              return
            }
            self.panel?.setFrame(self.parentContentFrame, display: true)
          }
        })
    }
    observers.append(
      NotificationCenter.default.addObserver(
        forName: NSWindow.willCloseNotification,
        object: parentWindow,
        queue: .main
      ) { [weak self] _ in
        MainActor.assumeIsolated {
          self?.presentation.lifecycle.invalidate()
        }
      }
    )
  }

  private func remove(completion: @escaping () -> Void) {
    if let eventMonitor {
      NSEvent.removeMonitor(eventMonitor)
    }
    eventMonitor = nil
    observers.forEach(NotificationCenter.default.removeObserver)
    observers.removeAll()
    if let panel {
      panel.owner = nil
      parentWindow?.removeChildWindow(panel)
      panel.orderOut(nil)
      panel.contentViewController = nil
      panel.close()
    }
    panel = nil
    host = nil
    if let parentWindow, parentWindow.isVisible {
      parentWindow.makeKey()
      parentWindow.makeFirstResponder(previousResponder)
    }
    previousResponder = nil
    parentWindow = nil
    completion()
  }
}

private final class BrianBottomSheetPanel<Content: View>: NSPanel {
  var owner: BrianBottomSheetAppKitCoordinator<Content>?

  override var canBecomeKey: Bool { true }
  override var canBecomeMain: Bool { false }
}
#endif
