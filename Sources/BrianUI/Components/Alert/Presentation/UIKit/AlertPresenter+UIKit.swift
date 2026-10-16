#if os(iOS)
  import SwiftUI
  import UIKit

  struct BrianAlertPresenter<Content: View>: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let onDismiss: (() -> Void)?
    let content: () -> Content

    func makeCoordinator() -> BrianAlertUIKitCoordinator<Content> {
      BrianAlertUIKitCoordinator()
    }

    func makeUIViewController(
      context: Context
    ) -> BrianModalUIKitAnchor {
      let anchor = BrianModalUIKitAnchor()
      context.coordinator.anchor = anchor
      anchor.attachmentChanged = { [weak coordinator = context.coordinator] in
        coordinator?.scheduleUpdate()
      }
      return anchor
    }

    func updateUIViewController(
      _ controller: BrianModalUIKitAnchor,
      context: Context
    ) {
      context.coordinator.update(
        binding: $isPresented,
        onDismiss: onDismiss,
        content: isPresented ? content() : nil,
        environment: context.environment
      )
    }

    static func dismantleUIViewController(
      _ controller: BrianModalUIKitAnchor,
      coordinator: BrianAlertUIKitCoordinator<Content>
    ) {
      controller.attachmentChanged = nil
      DispatchQueue.main.async {
        coordinator.presentation.invalidate()
      }
    }
  }
#endif
