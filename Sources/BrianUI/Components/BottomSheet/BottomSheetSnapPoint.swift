import SwiftUI

/// Specifies a bottom sheet's stopping height as a fraction or in points.
///
/// Ignores nonpositive or nonfinite heights and clamps values above the permitted maximum height.
public enum BrianBottomSheetSnapPoint: Hashable, Sendable {
  /// A fraction of the presentation height, including the bottom safe area.
  case fraction(CGFloat)
  /// A height in points.
  case height(CGFloat)

  func resolved(in height: CGFloat, maximum: CGFloat) -> CGFloat? {
    let value: CGFloat
    switch self {
    case let .fraction(fraction):
      value = height * fraction

    case let .height(points):
      value = points
    }
    guard value.isFinite, value > 0 else {
      return nil
    }
    return min(value, maximum)
  }
}
