import Foundation

public struct BrianTheme: Hashable, Sendable {
  public var color: ColorToken
  public var radius: RadiusToken
  public var spacing: SpacingToken
  public var typography: TypographyToken

  public init(
    color: ColorToken,
    radius: RadiusToken = .default,
    spacing: SpacingToken = .default,
    typography: TypographyToken = .default
  ) {
    self.color = color
    self.radius = radius
    self.spacing = spacing
    self.typography = typography
  }

  public init(
    palette: ColorPalette = .default,
    brand: ColorPalette.Scale? = nil
  ) {
    self.init(
      color: ColorToken(palette: palette, brand: brand),
      radius: .default,
      spacing: .default,
      typography: .default
    )
  }
}
