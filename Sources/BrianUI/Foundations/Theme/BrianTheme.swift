import Foundation

/// Color, gradient, radius, spacing, typography, and shadow tokens shared by BrianUI components.
///
/// Uses the default theme without setup. To change the theme for descendants,
/// apply `.environment(\.theme, theme)`.
///
/// ```swift
/// ContentView()
///   .environment(\.theme, BrianTheme())
/// ```
///
/// See <doc:Theming> for usage examples.
public struct BrianTheme: Hashable, Sendable {
  /// Semantic color tokens.
  public var color: ColorToken
  /// Corner radius tokens.
  public var radius: RadiusToken
  /// Layout spacing tokens.
  public var spacing: SpacingToken
  /// Typography tokens by text role.
  public var typography: TypographyToken
  /// Shadow tokens.
  public var shadow: ShadowToken
  /// Expressive gradient tokens for heroes and highlighted areas.
  public var gradient: GradientToken

  /// Creates a theme by specifying each token directly.
  ///
  /// - Parameters:
  ///   - color: The semantic color tokens to use.
  ///   - radius: Corner radii. Defaults to `.default`.
  ///   - spacing: Spacing. Defaults to `.default`.
  ///   - typography: Typography. Defaults to `.default`.
  ///   - shadow: Shadows. Defaults to `.default`.
  ///   - gradient: Expressive gradients. Defaults to `.default`.
  public init(
    color: ColorToken,
    radius: RadiusToken = .default,
    spacing: SpacingToken = .default,
    typography: TypographyToken = .default,
    shadow: ShadowToken = .default,
    gradient: GradientToken = .default
  ) {
    self.color = color
    self.radius = radius
    self.spacing = spacing
    self.typography = typography
    self.shadow = shadow
    self.gradient = gradient
  }

  /// Creates a theme by deriving semantic color tokens from a palette.
  ///
  /// - Parameters:
  ///   - palette: The color palette. Omit to use the default palette.
  ///   - brand: The brand color scale. `nil` uses the palette's default brand configuration.
  ///   - shadow: Shadow tokens. Defaults to `.default`.
  ///   - gradient: Gradient tokens independent of the solid brand palette. Defaults to `.default`.
  public init(
    palette: ColorPalette = .default,
    brand: ColorPalette.Scale? = nil,
    shadow: ShadowToken = .default,
    gradient: GradientToken = .default
  ) {
    self.init(
      color: ColorToken(palette: palette, brand: brand),
      radius: .default,
      spacing: .default,
      typography: .default,
      shadow: shadow,
      gradient: gradient
    )
  }
}
