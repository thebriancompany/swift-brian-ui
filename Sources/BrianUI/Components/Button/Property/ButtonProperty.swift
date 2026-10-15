import Foundation

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
