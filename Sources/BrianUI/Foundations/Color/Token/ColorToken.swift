import Foundation

public struct ColorToken: Hashable, Sendable {
  public var foreground: Foreground
  public var background: Background
  public var border: Border

  public init(
    foreground: Foreground,
    background: Background,
    border: Border
  ) {
    self.foreground = foreground
    self.background = background
    self.border = border
  }
}
