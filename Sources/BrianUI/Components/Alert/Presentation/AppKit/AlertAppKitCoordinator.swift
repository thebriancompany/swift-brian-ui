#if os(macOS)
  import AppKit
  import SwiftUI

  @MainActor
  final class BrianAlertAppKitCoordinator {
    weak var anchor: BrianModalAppKitAnchor?

    private var binding: Binding<Bool> = .constant(false)
    private var onDismiss: (() -> Void)?
    private var content = AnyView(EmptyView())
    private var environment = EnvironmentValues()
    private var dialog: BrianAlertAppKitController?
    private var presenter: NSViewController?
    private var animator: BrianAlertAppKitAnimator?
    private var updateScheduled = false

    lazy var presentation = BrianModalPresentation(
      present: { [weak self] in
        self?.present() ?? false
      },
      dismiss: { [weak self] in
        self?.dismiss()
      }
    )

    func update(
      binding: Binding<Bool>,
      onDismiss: (() -> Void)?,
      content: AnyView?,
      environment: EnvironmentValues
    ) {
      self.binding = binding
      self.onDismiss = onDismiss
      if let content {
        self.content = content
      }
      self.environment = environment
      dialog?.update(content: hostedContent, environment: environment)
      animator?.update(environment: environment)
      scheduleUpdate()
    }

    func scheduleUpdate() {
      guard !updateScheduled else {
        return
      }
      updateScheduled = true
      DispatchQueue.main.async { [weak self] in
        guard let self else {
          return
        }
        self.updateScheduled = false
        let isReady = self.anchor?.attachedWindow != nil
        self.presentation.update(
          isPresented: self.binding,
          onDismiss: self.onDismiss,
          isReady: isReady
        )
        if !isReady {
          self.presentation.requestDismissal()
        }
      }
    }

    private var hostedContent: AnyView {
      AnyView(
        BrianAlertHostedContent(
          content: content,
          environment: environment,
          presentation: presentation
        ))
    }

    private func present() -> Bool {
      guard let anchor, let window = anchor.attachedWindow else {
        return false
      }
      let dialog = BrianAlertAppKitController(
        content: hostedContent, environment: environment)
      dialog.owner = self
      let animator = BrianAlertAppKitAnimator(
        parentWindow: window,
        environment: environment,
        presentationFinished: { [weak self, weak dialog] in
          guard let self, let dialog, self.dialog === dialog else {
            return
          }
          self.presentation.presentationDidFinish()
        },
        dismissalFinished: { [weak self, weak dialog] in
          guard let self, let dialog, self.dialog === dialog else {
            return
          }
          self.dismissalDidFinish()
        },
        dismissRequested: { [weak self] in
          self?.presentation.requestDismissal()
        },
        parentClosed: { [weak self] in
          self?.presentation.invalidate()
        }
      )
      self.dialog = dialog
      self.presenter = anchor
      self.animator = animator
      anchor.present(dialog, animator: animator)
      return true
    }

    private func dismiss() {
      guard let dialog else {
        return
      }
      presenter?.dismiss(dialog)
    }

    private func dismissalDidFinish() {
      dialog?.owner = nil
      dialog = nil
      presenter = nil
      animator = nil
      presentation.dismissalDidFinish()
    }
  }

  @MainActor
  private final class BrianAlertAppKitController: NSViewController {
    var owner: BrianAlertAppKitCoordinator?
    let host: NSHostingController<AnyView>
    let dimmer = NSView()

    private var environment: EnvironmentValues

    init(content: AnyView, environment: EnvironmentValues) {
      host = NSHostingController(rootView: content)
      self.environment = environment
      super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func loadView() {
      let stage = BrianAlertAppKitStage()
      stage.layoutContent = { [weak self] in
        self?.layoutContent()
      }
      dimmer.wantsLayer = true
      stage.addSubview(dimmer)
      addChild(host)
      stage.addSubview(host.view)
      self.view = stage
      updateDimmer()
    }

    var cardFrame: CGRect {
      BrianAlertGeometry.cardFrame(in: view.bounds) {
        host.sizeThatFits(in: $0)
      }
    }

    func update(content: AnyView, environment: EnvironmentValues) {
      self.environment = environment
      host.rootView = content
      if isViewLoaded {
        updateDimmer()
        view.needsLayout = true
      }
    }

    private func layoutContent() {
      dimmer.frame = view.bounds
      host.view.frame = cardFrame
    }

    private func updateDimmer() {
      let appearance = NSAppearance(named: environment.colorScheme == .dark ? .darkAqua : .aqua)
      view.appearance = appearance
      appearance?.performAsCurrentDrawingAppearance {
        dimmer.layer?.backgroundColor = NSColor(environment.theme.color.background.overlay).cgColor
      }
    }
  }

  @MainActor
  private final class BrianAlertAppKitStage: NSView {
    var layoutContent: (() -> Void)?
    override var isFlipped: Bool { true }

    override func layout() {
      super.layout()
      layoutContent?()
    }
  }

  @MainActor
  private final class BrianAlertAppKitPanel: NSPanel {
    var dismissRequested: (() -> Void)?
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { false }

    override func cancelOperation(_ sender: Any?) {
      dismissRequested?()
    }

    override func performKeyEquivalent(with event: NSEvent) -> Bool {
      if event.keyCode == 53 {
        dismissRequested?()
        return true
      }
      return super.performKeyEquivalent(with: event)
    }
  }

  @MainActor
  private final class BrianAlertAppKitAnimator: NSObject,
    NSViewControllerPresentationAnimator
  {
    private weak var parentWindow: NSWindow?
    private weak var previousResponder: NSResponder?
    private var environment: EnvironmentValues
    private var panel: BrianAlertAppKitPanel?
    private var eventMonitor: Any?
    private var observers: [NSObjectProtocol] = []
    private let presentationFinished: () -> Void
    private let dismissalFinished: () -> Void
    private let dismissRequested: () -> Void
    private let parentClosed: () -> Void

    init(
      parentWindow: NSWindow,
      environment: EnvironmentValues,
      presentationFinished: @escaping () -> Void,
      dismissalFinished: @escaping () -> Void,
      dismissRequested: @escaping () -> Void,
      parentClosed: @escaping () -> Void
    ) {
      self.parentWindow = parentWindow
      self.environment = environment
      self.presentationFinished = presentationFinished
      self.dismissalFinished = dismissalFinished
      self.dismissRequested = dismissRequested
      self.parentClosed = parentClosed
    }

    func update(environment: EnvironmentValues) {
      self.environment = environment
      panel?.appearance = NSAppearance(named: environment.colorScheme == .dark ? .darkAqua : .aqua)
    }

    func animatePresentation(of controller: NSViewController, from presenter: NSViewController) {
      guard let parentWindow, let dialog = controller as? BrianAlertAppKitController
      else {
        return
      }
      previousResponder = parentWindow.firstResponder
      let frame = parentContentFrame
      let panel = BrianAlertAppKitPanel(
        contentRect: frame,
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
      panel.level = parentWindow.level
      panel.dismissRequested = dismissRequested
      dialog.view.frame = CGRect(origin: .zero, size: frame.size)
      dialog.view.autoresizingMask = [.width, .height]
      panel.contentViewController = dialog
      panel.setFrame(frame, display: false)
      panel.setAccessibilityModal(true)
      self.panel = panel
      update(environment: environment)
      installInputMonitor()
      observeParentWindow()
      parentWindow.addChildWindow(panel, ordered: .above)
      dialog.view.layoutSubtreeIfNeeded()
      dialog.dimmer.alphaValue = 0
      dialog.host.view.alphaValue = 0
      let finalFrame = dialog.cardFrame
      dialog.host.view.frame = finalFrame.offsetBy(
        dx: 0,
        dy: environment.accessibilityReduceMotion ? 0 : BrianAlertGeometry.travel
      )
      panel.makeKeyAndOrderFront(nil)
      panel.makeFirstResponder(dialog.host.view)
      animateDimmer(dialog.dimmer, showing: true)
      NSAnimationContext.runAnimationGroup { context in
        context.duration = environment.accessibilityReduceMotion ? 0.15 : 0.3
        context.timingFunction = CAMediaTimingFunction(name: .easeOut)
        dialog.host.view.animator().frame = finalFrame
        dialog.host.view.animator().alphaValue = 1
      } completionHandler: { [self] in
        MainActor.assumeIsolated {
          NSAccessibility.post(element: dialog.host.view, notification: .focusedUIElementChanged)
          presentationFinished()
        }
      }
    }

    func animateDismissal(of controller: NSViewController, from presenter: NSViewController) {
      guard let dialog = controller as? BrianAlertAppKitController else {
        return
      }
      animateDimmer(dialog.dimmer, showing: false)
      NSAnimationContext.runAnimationGroup { context in
        context.duration = environment.accessibilityReduceMotion ? 0.15 : 0.2
        context.timingFunction = CAMediaTimingFunction(name: .easeIn)
        dialog.host.view.animator().frame = dialog.cardFrame.offsetBy(
          dx: 0,
          dy: environment.accessibilityReduceMotion ? 0 : BrianAlertGeometry.travel
        )
        dialog.host.view.animator().alphaValue = 0
      } completionHandler: { [self] in
        MainActor.assumeIsolated {
          tearDown()
          dismissalFinished()
        }
      }
    }

    private func animateDimmer(_ dimmer: NSView, showing: Bool) {
      NSAnimationContext.runAnimationGroup { context in
        context.duration = environment.accessibilityReduceMotion ? 0.15 : 0.2
        dimmer.animator().alphaValue = showing ? 1 : 0
      }
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
            forName: name,
            object: parentWindow,
            queue: .main
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
          MainActor.assumeIsolated { self?.parentClosed() }
        })
    }

    private func tearDown() {
      if let eventMonitor {
        NSEvent.removeMonitor(eventMonitor)
      }
      eventMonitor = nil
      observers.forEach(NotificationCenter.default.removeObserver)
      observers.removeAll()
      if let panel {
        parentWindow?.removeChildWindow(panel)
        panel.orderOut(nil)
        panel.contentViewController = nil
        panel.close()
      }
      panel = nil
      if let parentWindow, parentWindow.isVisible {
        parentWindow.makeKey()
        parentWindow.makeFirstResponder(previousResponder)
        if let previousResponder {
          NSAccessibility.post(element: previousResponder, notification: .focusedUIElementChanged)
        }
      }
      previousResponder = nil
    }
  }
#endif
