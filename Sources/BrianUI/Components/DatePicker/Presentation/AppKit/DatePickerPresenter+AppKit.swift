#if os(macOS)
  import SwiftUI
  import AppKit

  extension BrianDatePickerWindowAnchor: NSViewRepresentable {
    func makeCoordinator() -> Coordinator { Coordinator() }
    func makeNSView(context: Context) -> AnchorView {
      let view = AnchorView()
      context.coordinator.anchor = view
      view.changed = { [weak coordinator = context.coordinator] in coordinator?.scheduleUpdate() }
      return view
    }
    func updateNSView(_ view: AnchorView, context: Context) {
      context.coordinator.presentation = self
      context.coordinator.scheduleUpdate()
    }
    static func dismantleNSView(_ view: AnchorView, coordinator: Coordinator) {
      view.changed = nil
      coordinator.invalidate()
    }
    final class AnchorView: NSView {
      var changed: (() -> Void)?
      override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        changed?()
      }
      override func layout() {
        super.layout()
        changed?()
      }
      override func hitTest(_ point: NSPoint) -> NSView? { nil }
    }
  }
#endif
