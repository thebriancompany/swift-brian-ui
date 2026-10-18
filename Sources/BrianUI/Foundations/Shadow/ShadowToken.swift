import Foundation

public struct ShadowToken: Hashable, Sendable {
  public var elevated: Shadow
  public var floating: Shadow

  public init(elevated: Shadow, floating: Shadow) {
    self.elevated = elevated
    self.floating = floating
  }
}
