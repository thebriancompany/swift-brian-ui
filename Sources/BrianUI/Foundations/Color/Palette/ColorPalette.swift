import SwiftUI

public struct ColorPalette: Hashable, Sendable {
  public var black: Color
  public var blackAlpha: Scale
  public var blue: Scale
  public var gray: GrayScale
  public var green: Scale
  public var orange: Scale
  public var purple: Scale
  public var red: Scale
  public var white: Color
  public var whiteAlpha: WhiteAlphaScale
  public var yellow: Scale

  public init(
    black: Color,
    blackAlpha: Scale,
    blue: Scale,
    gray: GrayScale,
    green: Scale,
    orange: Scale,
    purple: Scale,
    red: Scale,
    white: Color,
    whiteAlpha: WhiteAlphaScale,
    yellow: Scale
  ) {
    self.black = black
    self.blackAlpha = blackAlpha
    self.blue = blue
    self.gray = gray
    self.green = green
    self.orange = orange
    self.purple = purple
    self.red = red
    self.white = white
    self.whiteAlpha = whiteAlpha
    self.yellow = yellow
  }
}
