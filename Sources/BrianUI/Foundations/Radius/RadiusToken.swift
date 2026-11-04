import Foundation

public struct RadiusToken: Hashable, Sendable {
  /// Defaults to 4.
  public var xSmall: CGFloat
  /// Defaults to 8.
  public var small: CGFloat
  /// Defaults to 12.
  public var medium: CGFloat
  /// Defaults to 16.
  public var large: CGFloat
  /// Defaults to 24.
  public var xLarge: CGFloat

  public init(
    xSmall: CGFloat,
    small: CGFloat,
    medium: CGFloat,
    large: CGFloat,
    xLarge: CGFloat
  ) {
    self.xSmall = xSmall
    self.small = small
    self.medium = medium
    self.large = large
    self.xLarge = xLarge
  }
}
