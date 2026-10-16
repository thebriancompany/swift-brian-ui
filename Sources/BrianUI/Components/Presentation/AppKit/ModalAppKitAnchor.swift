#if os(macOS)
  import AppKit
  import SwiftUI

  @MainActor
  final class BrianModalAppKitAnchor: NSViewController {
    var attachmentChanged: (() -> Void)?
    var attachedWindow: NSWindow? {
      isViewLoaded ? view.window : nil
    }

    override func loadView() {
      let view = BrianModalAppKitAnchorView()
      view.attachmentChanged = { [weak self] in
        self?.attachmentChanged?()
      }
      self.view = view
    }
  }

  @MainActor
  private final class BrianModalAppKitAnchorView: NSView {
    var attachmentChanged: (() -> Void)?

    override func viewDidMoveToWindow() {
      super.viewDidMoveToWindow()
      attachmentChanged?()
    }

    override func hitTest(_ point: NSPoint) -> NSView? {
      nil
    }
  }
#endif
