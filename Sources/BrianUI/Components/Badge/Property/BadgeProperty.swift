import Foundation

/// 배지의 크기, 색상 역할, 표현 방식과 선택적인 그라디언트입니다.
public struct BrianBadgeProperty: Hashable, Sendable {
  public var size: Size
  public var tone: Tone
  public var variant: Variant
  /// 활성 배지에서 `tone`보다 우선하는 그라디언트입니다. 기본값 `nil`은 단색을 사용합니다.
  /// solid는 선명한 채움, weak는 은은한 채움, outline은 테두리에 적용합니다.
  public var gradient: GradientToken.Style?

  /// 배지의 기본 스타일과 선택적인 그라디언트를 지정합니다.
  public init(
    size: Size = .medium,
    tone: Tone = .neutral,
    variant: Variant = .weak,
    gradient: GradientToken.Style? = nil
  ) {
    self.size = size
    self.tone = tone
    self.variant = variant
    self.gradient = gradient
  }
}

extension BrianBadgeProperty {
  public enum Size: CaseIterable, Hashable, Sendable {
    case medium
    case large
  }

  public enum Tone: CaseIterable, Hashable, Sendable {
    case neutral
    case brand
    case informative
    case positive
    case warning
    case critical
  }

  public enum Variant: CaseIterable, Hashable, Sendable {
    case weak
    case solid
    case outline
  }
}
