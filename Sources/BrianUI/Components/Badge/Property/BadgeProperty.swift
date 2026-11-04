import Foundation

/// A badge's size, tone, variant, and optional gradient.
public struct BrianBadgeProperty: Hashable, Sendable {
  public var size: Size
  public var tone: Tone
  public var variant: Variant
  /// A gradient that overrides `tone` on enabled badges. The default `nil` uses solid colors.
  /// Applies to the vivid fill for solid, subtle fill for weak, and border for outline.
  public var gradient: GradientToken.Style?

  /// Specifies the badge's base style and optional gradient.
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
