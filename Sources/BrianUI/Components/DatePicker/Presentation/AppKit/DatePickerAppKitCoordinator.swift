#if os(macOS)
  import SwiftUI
  import AppKit
  import Combine

  extension BrianDatePickerWindowAnchor {
    @MainActor
    final class Coordinator {
      weak var anchor: AnchorView?
      var presentation: BrianDatePickerWindowAnchor?
      private var host: NSHostingView<BrianDatePickerPopupContent<Content>>?
      private weak var observedContainer: NSView?
      private var geometryObservers: [AnyCancellable] = []
      private var scheduled = false
      private var invalidated = false

      func scheduleUpdate() {
        guard !scheduled, !invalidated else { return }
        scheduled = true
        DispatchQueue.main.async { [weak self] in
          guard let self else { return }
          self.scheduled = false
          guard !self.invalidated else { return }
          self.refresh()
        }
      }
      func invalidate() {
        invalidated = true
        removePopup()
      }
      func dismiss() {
        presentation?.isPresented = false
        removePopup()
      }
      private func refresh() {
        guard let presentation, presentation.isPresented, presentation.environment.isEnabled else {
          removePopup()
          return
        }
        guard let anchor, let window = anchor.window, let container = window.contentView,
          let parent = container.superview
        else {
          removePopup()
          return
        }
        observeGeometry(container: container, window: window)
        if host == nil { window.makeFirstResponder(nil) }
        let native = anchor.convert(anchor.bounds, to: container)
        let rect = CGRect(
          x: native.minX,
          y: container.isFlipped ? native.minY : container.bounds.height - native.maxY,
          width: native.width, height: native.height)
        let bounds = CGRect(origin: .zero, size: container.bounds.size)
        let root = presentation.overlay(anchor: rect, bounds: bounds)
        if let host {
          host.frame = container.frame
          host.rootView = root
          return
        }
        let view = BrianDatePickerPopupHostingView(rootView: root)
        view.dismissPopup = { [weak self] in self?.dismiss() }
        view.sizingOptions = []
        view.frame = container.frame
        view.autoresizingMask = [.width, .height]
        host = view
        // Keep the overlay outside the SwiftUI-managed content view hierarchy.
        parent.addSubview(view, positioned: .above, relativeTo: container)
        view.layoutSubtreeIfNeeded()
        window.makeFirstResponder(view)
      }
      private func observeGeometry(container: NSView, window: NSWindow) {
        guard observedContainer !== container else { return }
        geometryObservers.removeAll()
        observedContainer = container
        container.postsFrameChangedNotifications = true
        container.postsBoundsChangedNotifications = true
        let sources: [(Notification.Name, AnyObject)] = [
          (NSView.frameDidChangeNotification, container),
          (NSView.boundsDidChangeNotification, container),
          (NSWindow.didResizeNotification, window),
        ]
        geometryObservers = sources.map { name, object in
          NotificationCenter.default.publisher(for: name, object: object)
            .sink { [weak self] _ in
              MainActor.assumeIsolated { self?.scheduleUpdate() }
            }
        }
      }

      private func removePopup() {
        geometryObservers.removeAll()
        observedContainer = nil
        host?.removeFromSuperview()
        host = nil
      }
    }
  }
  private final class BrianDatePickerPopupHostingView<Content: View>: NSHostingView<Content> {
    var dismissPopup: (() -> Void)?
    override var acceptsFirstResponder: Bool { true }
    override func cancelOperation(_ sender: Any?) { dismissPopup?() }
  }
#endif
