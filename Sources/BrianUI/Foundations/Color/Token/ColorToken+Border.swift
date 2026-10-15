import SwiftUI

extension ColorToken {
  public struct Border: Hashable, Sendable {
    public var base: Color
    public var subtle: Color
    public var strong: Color
    public var focus: Color
    public var disabled: Color
    public var brand: Role
    public var informative: Role
    public var positive: Role
    public var warning: Role
    public var critical: Role

    public init(
      base: Color,
      subtle: Color,
      strong: Color,
      focus: Color,
      disabled: Color,
      brand: Role,
      informative: Role,
      positive: Role,
      warning: Role,
      critical: Role
    ) {
      self.base = base
      self.subtle = subtle
      self.strong = strong
      self.focus = focus
      self.disabled = disabled
      self.brand = brand
      self.informative = informative
      self.positive = positive
      self.warning = warning
      self.critical = critical
    }
  }
}

extension ColorToken.Border {
  public struct Role: Hashable, Sendable {
    public var weak: Color
    public var solid: Color

    public init(
      weak: Color,
      solid: Color
    ) {
      self.weak = weak
      self.solid = solid
    }
  }
}
