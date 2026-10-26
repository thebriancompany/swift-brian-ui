import SwiftUI

/// 바텀 시트가 멈출 높이를 비율 또는 포인트로 지정합니다.
///
/// 양수가 아니거나 유한하지 않은 높이는 무시하고, 허용 최대 높이를 넘는 값은 최대 높이로 제한합니다.
public enum BrianBottomSheetSnapPoint: Hashable, Sendable {
  /// 하단 안전 영역을 포함한 프레젠테이션 높이에 대한 비율입니다.
  case fraction(CGFloat)
  /// 포인트 단위의 높이입니다.
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
