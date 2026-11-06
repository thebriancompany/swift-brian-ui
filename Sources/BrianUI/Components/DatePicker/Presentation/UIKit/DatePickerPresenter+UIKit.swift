#if os(iOS)
  import SwiftUI
  import UIKit

  extension BrianDatePickerWindowAnchor: UIViewRepresentable {
    func makeCoordinator() -> Coordinator { Coordinator() }
    func makeUIView(context: Context) -> AnchorView {
      let view = AnchorView()
      context.coordinator.anchor = view
      view.changed = { [weak coordinator = context.coordinator] in coordinator?.scheduleUpdate() }
      return view
    }
    func updateUIView(_ view: AnchorView, context: Context) {
      context.coordinator.presentation = self
      context.coordinator.scheduleUpdate()
    }
    static func dismantleUIView(_ view: AnchorView, coordinator: Coordinator) {
      view.changed = nil
      coordinator.invalidate()
    }
    final class AnchorView: UIView {
      var changed: (() -> Void)?
      override func didMoveToWindow() {
        super.didMoveToWindow()
        changed?()
      }
      override func layoutSubviews() {
        super.layoutSubviews()
        changed?()
      }
      override func point(inside point: CGPoint, with event: UIEvent?) -> Bool { false }
    }
  }
#endif
