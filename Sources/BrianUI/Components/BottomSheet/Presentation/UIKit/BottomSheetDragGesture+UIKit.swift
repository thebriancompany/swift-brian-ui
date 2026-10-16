#if os(iOS)
import SwiftUI
import UIKit

struct BrianBottomSheetDragGesture: UIGestureRecognizerRepresentable {
  let isEnabled: Bool
  let onChanged: (CGFloat) -> Void
  let onEnded: (CGFloat?) -> Void

  func makeCoordinator(converter: CoordinateSpaceConverter) -> Coordinator {
    Coordinator()
  }

  func makeUIGestureRecognizer(context: Context) -> UIPanGestureRecognizer {
    let recognizer = UIPanGestureRecognizer()
    recognizer.maximumNumberOfTouches = 1
    recognizer.delegate = context.coordinator
    recognizer.isEnabled = isEnabled
    return recognizer
  }

  func updateUIGestureRecognizer(_ recognizer: UIPanGestureRecognizer, context: Context) {
    recognizer.isEnabled = isEnabled
  }

  func handleUIGestureRecognizerAction(_ recognizer: UIPanGestureRecognizer, context: Context) {
    let coordinator = context.coordinator
    switch recognizer.state {
    case .began, .changed:
      if let translation = coordinator.translation(for: recognizer) {
        onChanged(translation)
      }

    case .ended:
      let translation = coordinator.translation(for: recognizer)
      let velocity = recognizer.velocity(in: recognizer.view?.window).y
      let projected = translation.map { value in
        coordinator.isScrolling && value == 0 ? 0 : value + velocity * 0.2
      }
      coordinator.reset()
      onEnded(projected)

    case .cancelled, .failed:
      coordinator.reset()
      onEnded(nil)

    default:
      break
    }
  }

  @MainActor
  final class Coordinator: NSObject, UIGestureRecognizerDelegate {
    private weak var scrollView: UIScrollView?
    private var scrollObservation: NSKeyValueObservation?
    private var handoff = BrianBottomSheetScrollHandoff()
    private var isPinning = false

    var isScrolling: Bool { scrollView != nil }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
      reset()
      var view = touch.view
      while let current = view {
        if
          let scroll = current as? UIScrollView, scroll.isScrollEnabled,
          scroll.alwaysBounceVertical
            || scroll.contentSize.height + scroll.adjustedContentInset.top  + scroll.adjustedContentInset.bottom > scroll.bounds.height
        {
          scrollView = scroll
          handoff = BrianBottomSheetScrollHandoff(distanceToTop: distanceToTop)
          break
        }
        if current === gestureRecognizer.view {
          break
        }
        view = current.superview
      }
      return true
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
      guard let pan = gestureRecognizer as? UIPanGestureRecognizer else {
        return false
      }
      let velocity = pan.velocity(in: pan.view?.window)
      return abs(velocity.y) > abs(velocity.x)
    }

    func gestureRecognizer(
      _ gestureRecognizer: UIGestureRecognizer,
      shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
      otherGestureRecognizer === scrollView?.panGestureRecognizer
    }

    func translation(for recognizer: UIPanGestureRecognizer) -> CGFloat? {
      let translation = recognizer.translation(in: recognizer.view?.window).y
      guard let scrollView else {
        return translation
      }
      guard let translation = handoff.update(translation: translation, distanceToTop: distanceToTop) else {
        return nil
      }

      if scrollObservation == nil {
        scrollObservation = scrollView.observe(\.contentOffset, options: [.new]) { [weak self] _, _ in
          MainActor.assumeIsolated { self?.pinScrollToTop() }
        }
      }
      pinScrollToTop()
      return translation
    }

    func reset() {
      if scrollObservation != nil, let scrollView {
        scrollView.panGestureRecognizer.isEnabled = false
        scrollView.panGestureRecognizer.isEnabled = true
        pinScrollToTop()
      }
      scrollObservation = nil
      scrollView = nil
      handoff = BrianBottomSheetScrollHandoff()
    }

    private var distanceToTop: CGFloat {
      guard let scrollView else { return 0 }
      return max(0, scrollView.contentOffset.y + scrollView.adjustedContentInset.top)
    }

    private func pinScrollToTop() {
      guard !isPinning, let scrollView else {
        return
      }
      let top = -scrollView.adjustedContentInset.top
      guard scrollView.contentOffset.y != top else {
        return
      }
      isPinning = true
      scrollView.contentOffset.y = top
      isPinning = false
    }
  }
}
#endif
