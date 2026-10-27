import SwiftUI

extension EnvironmentValues {
  @Entry var badgeProperty = BrianBadgeProperty()
}

extension View {
  /// 하위 배지의 크기, 색상 역할, 표현 방식과 그라디언트를 함께 교체합니다.
  public func badgeProperty(_ property: BrianBadgeProperty) -> some View {
    environment(\.badgeProperty, property)
  }

  public func badgeSize(_ size: BrianBadgeProperty.Size) -> some View {
    transformEnvironment(\.badgeProperty) { $0.size = size }
  }

  public func badgeTone(_ tone: BrianBadgeProperty.Tone) -> some View {
    transformEnvironment(\.badgeProperty) { $0.tone = tone }
  }

  public func badgeVariant(_ variant: BrianBadgeProperty.Variant) -> some View {
    transformEnvironment(\.badgeProperty) { $0.variant = variant }
  }

  /// 하위 배지에 표현용 그라디언트를 선택적으로 적용합니다.
  ///
  /// solid는 선명한 채움, weak는 은은한 채움, outline은 테두리로 표시합니다.
  /// 텍스트와 아이콘은 단색이며, 비활성 상태는 기존 비활성 색상을 사용합니다.
  /// 활성 상태에서는 `badgeTone(_:)`보다 우선합니다.
  ///
  /// - Parameter style: 사용할 팔레트입니다. `nil`은 상위에서 상속한 그라디언트를 해제합니다.
  /// - Returns: 나머지 배지 설정을 유지하면서 그라디언트만 변경한 뷰입니다.
  public func badgeGradient(_ style: GradientToken.Style?) -> some View {
    transformEnvironment(\.badgeProperty) { $0.gradient = style }
  }
}
