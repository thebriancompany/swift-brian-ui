import Foundation

/// 기본 버튼 스타일의 크기와 색상 역할입니다.
///
/// 기본값은 `.medium` 크기와 `.neutral` 색상입니다. 플로팅 버튼은 별도의 프로퍼티를 사용합니다.
public struct BrianButtonProperty: Hashable, Sendable {
  public var size: Size
  public var tone: Tone

  public init(
    size: Size = .medium,
    tone: Tone = .neutral
  ) {
    self.size = size
    self.tone = tone
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
