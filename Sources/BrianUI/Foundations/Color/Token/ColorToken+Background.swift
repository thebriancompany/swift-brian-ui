import SwiftUI

extension ColorToken {
  public struct Background: Hashable, Sendable {
    public var base: Color
    public var subtle: Color
    public var elevated: Color
    public var overlay: Color
    public var inverse: Color
    public var disabled: Color
    public var transparent: ColorToken.State
    public var neutral: Role
    public var brand: Role
    public var informative: Role
    public var positive: Role
    public var warning: Role
    public var critical: Role

    public init(
      base: Color,
      subtle: Color,
      elevated: Color,
      overlay: Color,
      inverse: Color,
      disabled: Color,
      transparent: ColorToken.State,
      neutral: Role,
      brand: Role,
      informative: Role,
      positive: Role,
      warning: Role,
      critical: Role
    ) {
      self.base = base
      self.subtle = subtle
      self.elevated = elevated
      self.overlay = overlay
      self.inverse = inverse
      self.disabled = disabled
      self.transparent = transparent
      self.neutral = neutral
      self.brand = brand
      self.informative = informative
      self.positive = positive
      self.warning = warning
      self.critical = critical
    }
  }
}

extension ColorToken.Background {
  public struct Role: Hashable, Sendable {
    public var solid: ColorToken.State
    public var weak: ColorToken.State

    public init(
      solid: ColorToken.State,
      weak: ColorToken.State
    ) {
      self.solid = solid
      self.weak = weak
    }
  }
}
