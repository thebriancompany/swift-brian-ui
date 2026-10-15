import Foundation

public struct RadiusToken: Hashable, Sendable {
  /// 기본값 4
  public var xSmall: CGFloat
  /// 기본값 8
  public var small: CGFloat
  /// 기본값 12
  public var medium: CGFloat
  /// 기본값 16
  public var large: CGFloat
  /// 기본값 20
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
