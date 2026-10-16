#if os(iOS)
  import SwiftUI
  import UIKit

  @MainActor
  final class BrianModalUIKitAnchor: UIViewController {
    var attachmentChanged: (() -> Void)?

    override func loadView() {
      let view = BrianModalUIKitAnchorView()
      view.attachmentChanged = { [weak self] in
        self?.attachmentChanged?()
      }
      view.isUserInteractionEnabled = false
      self.view = view
    }
  }

  @MainActor
  private final class BrianModalUIKitAnchorView: UIView {
    var attachmentChanged: (() -> Void)?

    override func didMoveToWindow() {
      super.didMoveToWindow()
      attachmentChanged?()
    }
  }
#endif
