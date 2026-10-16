import SwiftUI

@MainActor
@Observable
final class BrianBottomSheetPresentation {
  private(set) var isVisible = false
  @ObservationIgnored private let present: () -> Bool
  @ObservationIgnored private let remove: (@escaping () -> Void) -> Void

  @ObservationIgnored lazy var lifecycle = BrianModalPresentation(
    present: { [weak self] in
      self?.present() ?? false
    },
    dismiss: { [weak self] in
      self?.dismiss()
    }
  )

  init(
    present: @escaping @MainActor () -> Bool,
    remove: @escaping @MainActor (@escaping () -> Void) -> Void
  ) {
    self.present = present
    self.remove = remove
  }

  func didAppear() {
    guard lifecycle.phase == .presenting, !isVisible else {
      return
    }
    DispatchQueue.main.async { [weak self] in
      guard let self, self.lifecycle.phase == .presenting, !self.isVisible else {
        return
      }
      withAnimation(.easeOut(duration: 0.25), completionCriteria: .logicallyComplete) {
        self.isVisible = true
      } completion: {
        self.lifecycle.presentationDidFinish()
      }
    }
  }

  private func dismiss() {
    withAnimation(.easeOut(duration: 0.25), completionCriteria: .logicallyComplete) {
      isVisible = false
    } completion: {
      self.remove { self.lifecycle.dismissalDidFinish() }
    }
  }
}
