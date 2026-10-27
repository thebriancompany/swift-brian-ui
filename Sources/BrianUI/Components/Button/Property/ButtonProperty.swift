import Foundation

/// 기본 버튼 스타일의 크기, 색상 역할과 선택적인 그라디언트입니다.
///
/// 기본값은 `.medium` 크기와 `.neutral` 색상입니다. 플로팅 버튼은 별도의 프로퍼티를 사용합니다.
public struct BrianButtonProperty: Hashable, Sendable {
  public var size: Size
  public var tone: Tone
  /// 활성 버튼에서 `tone`보다 우선하는 그라디언트입니다. `nil`이면 단색 스타일을 사용합니다.
  ///
  /// solid는 선명한 채움, weak는 은은한 채움, outline은 테두리,
  /// ghost는 눌렀을 때만 은은한 채움을 표시합니다. 플로팅 버튼에는 적용되지 않습니다.
  public var gradient: GradientToken.Style?

  /// 크기, 기본 색상과 선택적인 그라디언트를 지정합니다.
  public init(
    size: Size = .medium,
    tone: Tone = .neutral,
    gradient: GradientToken.Style? = nil
  ) {
    self.size = size
    self.tone = tone
    self.gradient = gradient
  }
}

extension BrianButtonProperty {
  public enum Size: CaseIterable, Hashable, Sendable {
    case xsmall
    case small
    case medium
    case large
  }

  public enum Tone: CaseIterable, Hashable, Sendable {
    case brand
    case neutral
    case critical
  }
}
