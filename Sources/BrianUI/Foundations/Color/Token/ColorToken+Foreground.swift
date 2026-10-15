import SwiftUI

extension ColorToken {
  public struct Foreground: Hashable, Sendable {
    public var primary: Color
    public var secondary: Color
    public var tertiary: Color
    public var inverse: Color
    public var disabled: Color
    public var placeholder: Color
    public var link: Color
    public var brand: Role
    public var informative: Role
    public var positive: Role
    public var warning: Role
    public var critical: Role

    public init(
      primary: Color,
      secondary: Color,
      tertiary: Color,
      inverse: Color,
      disabled: Color,
      placeholder: Color,
      link: Color,
      brand: Role,
      informative: Role,
      positive: Role,
      warning: Role,
      critical: Role
    ) {
      self.primary = primary
      self.secondary = secondary
      self.tertiary = tertiary
      self.inverse = inverse
      self.disabled = disabled
      self.placeholder = placeholder
      self.link = link
      self.brand = brand
      self.informative = informative
      self.positive = positive
      self.warning = warning
      self.critical = critical
    }
  }
}

extension ColorToken.Foreground {
  public struct Role: Hashable, Sendable {
    public var normal: Color
    public var strong: Color
    public var solid: Color

    public init(
      normal: Color,
      strong: Color,
      solid: Color
    ) {
      self.normal = normal
      self.strong = strong
      self.solid = solid
    }
  }
}
