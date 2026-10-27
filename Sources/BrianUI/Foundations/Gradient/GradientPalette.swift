import SwiftUI

/// 하나의 표현용 그라디언트에 사용하는 네 가지 색상과 콘텐츠 색상입니다.
///
/// 상태를 전달하는 의미별 색상과 별개로 사용합니다. 커스텀 팔레트는 모든 배경
/// 색상 위에서 `foreground`가 읽히도록 구성하고 라이트·다크 모드를 함께 확인하세요.
/// 색상의 불투명도는 보정하지 않습니다. 반투명 색상은 실제 배치할 표면 위에서 대비를 확인하세요.
public struct GradientPalette: Hashable, Sendable {
  /// 왼쪽 위에서 시작하는 색상입니다.
  public var start: Color
  /// 위쪽과 왼쪽 아래를 연결하는 색상이며, 대비 증가 시 단색 배경으로도 사용합니다.
  public var middle: Color
  /// 오른쪽 아래로 이어지는 색상입니다.
  public var end: Color
  /// 중앙에 부드럽게 번지는 색상입니다.
  public var highlight: Color
  /// 선명한 그라디언트 배경 위에 사용하는 콘텐츠 색상입니다.
  public var foreground: Color

  /// 배경색과 그 위에 표시할 콘텐츠 색상을 함께 지정합니다.
  public init(
    start: Color,
    middle: Color,
    end: Color,
    highlight: Color,
    foreground: Color
  ) {
    self.start = start
    self.middle = middle
    self.end = end
    self.highlight = highlight
    self.foreground = foreground
  }

  /// 아이콘이나 장식 테두리에 사용할 수 있는 대각선 선형 그라디언트입니다.
  ///
  /// 본문이나 상태 표시의 유일한 색상으로 사용하지 마세요. 배경과의 대비는 호출자가 확인합니다.
  public var linearGradient: LinearGradient {
    LinearGradient(
      colors: [start, middle, end],
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    )
  }
}
