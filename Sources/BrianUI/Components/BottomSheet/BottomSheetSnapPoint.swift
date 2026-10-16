import SwiftUI

public enum BrianBottomSheetSnapPoint: Hashable, Sendable {
  case fraction(CGFloat)
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
