import SwiftUI

extension ColorPalette {
  public struct WhiteAlphaScale: Hashable, Sendable {
    public var `50`: Color
    public var `100`: Color
    public var `200`: Color
    public var `300`: Color
    public var `400`: Color
    public var `500`: Color
    public var `600`: Color
    public var `700`: Color
    public var `800`: Color
    public var `900`: Color
    public var `1000`: Color

    public init(
      `50`: Color,
      `100`: Color,
      `200`: Color,
      `300`: Color,
      `400`: Color,
      `500`: Color,
      `600`: Color,
      `700`: Color,
      `800`: Color,
      `900`: Color,
      `1000`: Color
    ) {
      self.`50` = `50`
      self.`100` = `100`
      self.`200` = `200`
      self.`300` = `300`
      self.`400` = `400`
      self.`500` = `500`
      self.`600` = `600`
      self.`700` = `700`
      self.`800` = `800`
      self.`900` = `900`
      self.`1000` = `1000`
    }

    public subscript(step: Step) -> Color {
      get {
        switch step {
        case .`50`: self.`50`
        case .`100`: self.`100`
        case .`200`: self.`200`
        case .`300`: self.`300`
        case .`400`: self.`400`
        case .`500`: self.`500`
        case .`600`: self.`600`
        case .`700`: self.`700`
        case .`800`: self.`800`
        case .`900`: self.`900`
        case .`1000`: self.`1000`
        }
      }
      set {
        switch step {
        case .`50`: self.`50` = newValue
        case .`100`: self.`100` = newValue
        case .`200`: self.`200` = newValue
        case .`300`: self.`300` = newValue
        case .`400`: self.`400` = newValue
        case .`500`: self.`500` = newValue
        case .`600`: self.`600` = newValue
        case .`700`: self.`700` = newValue
        case .`800`: self.`800` = newValue
        case .`900`: self.`900` = newValue
        case .`1000`: self.`1000` = newValue
        }
      }
    }
  }
}

extension ColorPalette.WhiteAlphaScale {
  public enum Step: Int, CaseIterable, Hashable, Sendable {
    case `50` = 50
    case `100` = 100
    case `200` = 200
    case `300` = 300
    case `400` = 400
    case `500` = 500
    case `600` = 600
    case `700` = 700
    case `800` = 800
    case `900` = 900
    case `1000` = 1000
  }
}
