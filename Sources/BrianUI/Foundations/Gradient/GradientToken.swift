import Foundation

/// Multicolor gradient tokens for heroes, content covers, and highlighted cards.
///
/// Use existing ``ColorToken`` values for states such as success, warning, and error.
public struct GradientToken: Hashable, Sendable {
  /// A palette blending cyan, blue, lilac, and pink.
  public var aurora: GradientPalette
  /// A palette blending peach, coral, lavender, and warm light.
  public var sunset: GradientPalette
  /// A palette blending mint, sky blue, and soft green.
  public var lagoon: GradientPalette

  /// Specifies three expressive palettes.
  public init(aurora: GradientPalette, sunset: GradientPalette, lagoon: GradientPalette) {
    self.aurora = aurora
    self.sunset = sunset
    self.lagoon = lagoon
  }

  /// Reads or replaces a gradient palette by name.
  public subscript(style: Style) -> GradientPalette {
    get {
      switch style {
      case .aurora: aurora
      case .sunset: sunset
      case .lagoon: lagoon
      }
    }
    set {
      switch style {
      case .aurora: aurora = newValue
      case .sunset: sunset = newValue
      case .lagoon: lagoon = newValue
      }
    }
  }
}

extension GradientToken {
  /// The name of an expressive gradient to select from the theme.
  public enum Style: CaseIterable, Hashable, Sendable {
    /// A cyan, blue, lilac, and pink combination.
    case aurora
    /// A peach, coral, and lavender combination.
    case sunset
    /// A mint, blue, and green combination.
    case lagoon
  }
}
