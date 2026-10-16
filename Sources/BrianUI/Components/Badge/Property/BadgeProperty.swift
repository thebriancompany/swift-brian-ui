import Foundation

public struct BrianBadgeProperty: Hashable, Sendable {
  public var size: Size
  public var tone: Tone
  public var variant: Variant

  public init(
    size: Size = .medium,
    tone: Tone = .neutral,
    variant: Variant = .weak
  ) {
    self.size = size
    self.tone = tone
    self.variant = variant
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
