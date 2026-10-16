import Foundation

struct BrianBottomSheetScrollHandoff {
  private var previousTranslation: CGFloat = 0
  private var previousDistanceToTop: CGFloat
  private var sheetOrigin: CGFloat?

  init(distanceToTop: CGFloat = 0) {
    previousDistanceToTop = max(0, distanceToTop)
  }

  mutating func update(translation: CGFloat, distanceToTop: CGFloat) -> CGFloat? {
    defer {
      previousTranslation = translation
      previousDistanceToTop = max(0, distanceToTop)
    }

    if sheetOrigin == nil {
      let delta = translation - previousTranslation
      guard distanceToTop <= 0.5, delta > 0 else {
        return nil
      }
      sheetOrigin = translation - max(0, delta - previousDistanceToTop)
    }

    return max(0, translation - (sheetOrigin ?? translation))
  }
}
