#if os(macOS)
  import AppKit
  import SwiftUI

  struct BrianAlertPresenter<Content: View>: NSViewControllerRepresentable {
    @Binding var isPresented: Bool
    let onDismiss: (() -> Void)?
    let content: () -> Content

    func makeCoordinator() -> BrianAlertAppKitCoordinator<Content> {
      BrianAlertAppKitCoordinator()
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
        onDismiss: onDismiss,
        content: isPresented ? content() : nil,
        environment: context.environment
      )
    }

    static func dismantleNSViewController(
      _ controller: BrianModalAppKitAnchor,
      coordinator: BrianAlertAppKitCoordinator<Content>
    ) {
      controller.attachmentChanged = nil
      DispatchQueue.main.async {
        coordinator.presentation.invalidate()
      }
    }
  }
#endif
