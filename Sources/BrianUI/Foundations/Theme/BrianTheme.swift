import Foundation

public struct BrianTheme: Hashable, Sendable {
  public var color: ColorToken
  public var radius: RadiusToken
  public var spacing: SpacingToken
  public var typography: TypographyToken
  public var shadow: ShadowToken

  public init(
    color: ColorToken,
    radius: RadiusToken = .default,
    spacing: SpacingToken = .default,
    typography: TypographyToken = .default,
    shadow: ShadowToken = .default
  ) {
    self.color = color
    self.radius = radius
    self.spacing = spacing
    self.typography = typography
    self.shadow = shadow
  }

  public init(
    palette: ColorPalette = .default,
    brand: ColorPalette.Scale? = nil,
    shadow: ShadowToken = .default
  ) {
    self.init(
      color: ColorToken(palette: palette, brand: brand),
      radius: .default,
      spacing: .default,
      typography: .default,
      shadow: shadow
    )
  }
}
