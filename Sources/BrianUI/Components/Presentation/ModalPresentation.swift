import SwiftUI

@MainActor
final class BrianModalPresentation {
  enum Phase: Hashable, Sendable {
    case idle
    case presenting
    case presented
    case dismissing
  }

  private(set) var phase = Phase.idle
  private var isPresented: Binding<Bool> = .constant(false)
  private var onDismiss: (() -> Void)?
  private var isReady = false
  private var isInvalidated = false
  private var dismissalRequested = false
  private let present: () -> Bool
  private let dismiss: () -> Void

  init(present: @escaping () -> Bool, dismiss: @escaping () -> Void) {
    self.present = present
    self.dismiss = dismiss
  }

  func update(isPresented: Binding<Bool>, onDismiss: (() -> Void)?, isReady: Bool) {
    self.isPresented = isPresented
    self.onDismiss = onDismiss
    self.isReady = isReady
    reconcile()
  }

  func presentationDidFinish() {
    guard phase == .presenting else {
      return
    }
    phase = .presented
    reconcile()
  }

  func dismissalDidFinish() {
    guard phase == .dismissing else {
      return
    }
    phase = .idle
    dismissalRequested = false
    onDismiss?()
    reconcile()
  }

  func performAction(_ action: () -> Void) {
    if requestDismissal() {
      action()
    }
  }

  @discardableResult
  func requestDismissal() -> Bool {
    guard !dismissalRequested, phase == .presenting || phase == .presented else {
      return false
    }
    dismissalRequested = true
    isPresented.wrappedValue = false
    reconcile()
    return true
  }

  func invalidate() {
    guard !isInvalidated else {
      return
    }
    isInvalidated = true
    if phase != .idle {
      dismissalRequested = true
      isPresented.wrappedValue = false
    }
    reconcile()
  }

  private func reconcile() {
    switch phase {
    case .idle:
      guard !isInvalidated, isReady, isPresented.wrappedValue else {
        return
      }
      phase = .presenting
      if !present() {
        phase = .idle
      }

    case .presented:
      guard isInvalidated || dismissalRequested || !isPresented.wrappedValue else {
        return
      }
      phase = .dismissing
      dismiss()

    case .presenting, .dismissing:
      break
    }
  }
}
