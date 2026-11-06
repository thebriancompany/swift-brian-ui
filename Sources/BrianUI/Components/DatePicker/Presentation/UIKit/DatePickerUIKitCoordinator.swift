#if os(iOS)
  import SwiftUI
  import UIKit

  extension BrianDatePickerWindowAnchor {
    @MainActor
    final class Coordinator {
      weak var anchor: AnchorView?
      var presentation: BrianDatePickerWindowAnchor?
      private var host: UIHostingController<BrianDatePickerPopupContent<Content>>?
      private var scheduled = false
      private var invalidated = false
      private var previousFocus: Any?
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
        guard let anchor, let window = anchor.window else {
          removePopup()
          return
        }
        let container = window
        if host == nil {
          window.endEditing(true)
          window.layoutIfNeeded()
        }
        let rect = anchor.convert(anchor.bounds, to: container)
        let bounds = window.bounds.inset(by: window.safeAreaInsets)
        let root = presentation.overlay(anchor: rect, bounds: bounds)
        if let host {
          host.rootView = root
          return
        }
        previousFocus = UIAccessibility.focusedElement(using: .notificationVoiceOver)
        let controller = PopupController(rootView: root)
        controller.dismissPopup = { [weak self] in self?.dismiss() }
        controller.view.backgroundColor = .clear
        controller.view.accessibilityViewIsModal = true
        controller.view.frame = container.bounds
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        host = controller
        container.addSubview(controller.view)
        controller.becomeFirstResponder()
        UIAccessibility.post(notification: .screenChanged, argument: controller.view)
      }
      private func removePopup() {
        host?.view.removeFromSuperview()
        if host != nil {
          UIAccessibility.post(notification: .screenChanged, argument: previousFocus)
        }
        previousFocus = nil
        host = nil
      }
    }
  }
  private final class PopupController<Content: View>: UIHostingController<Content> {
    var dismissPopup: (() -> Void)?
    override var canBecomeFirstResponder: Bool { true }
    override var keyCommands: [UIKeyCommand]? {
      [
        UIKeyCommand(
          input: UIKeyCommand.inputEscape, modifierFlags: [], action: #selector(escapePressed))
      ]
    }
    override func accessibilityPerformEscape() -> Bool {
      dismissPopup?()
      return true
    }
    @objc private func escapePressed() { dismissPopup?() }
  }
#endif
