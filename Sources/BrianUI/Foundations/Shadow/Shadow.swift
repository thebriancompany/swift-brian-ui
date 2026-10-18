import SwiftUI

public struct Shadow: Hashable, Sendable {
  public var primary: Layer
  public var secondary: Layer

  public init(primary: Layer = .none, secondary: Layer = .none) {
    self.primary = primary
    self.secondary = secondary
  }

  public static let none = Self()
}

extension Shadow {
  public struct Layer: Hashable, Sendable {
    public static let none = Self(color: .clear, radius: 0)

    public var color: Color
    public var radius: CGFloat
    public var x: CGFloat
    public var y: CGFloat

    public init(color: Color, radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) {
      self.color = color
      self.radius = radius
      self.x = x
      self.y = y
    }
  }
}
