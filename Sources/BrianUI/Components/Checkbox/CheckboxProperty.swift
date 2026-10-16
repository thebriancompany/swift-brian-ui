import SwiftUI

public struct BrianCheckboxProperty: Hashable, Sendable {
  public var shape: Shape
  public var size: Size
  public var tone: Tone
  public var weight: Weight

  public init(
    shape: Shape = .outlined,
    size: Size = .medium,
    tone: Tone = .neutral,
    weight: Weight = .regular
  ) {
    self.shape = shape
    self.size = size
    self.tone = tone
    self.weight = weight
  }
}

extension BrianCheckboxProperty {
  public enum Shape: CaseIterable, Hashable, Sendable {
    case outlined
    case ghost
  }

  public enum Size: CaseIterable, Hashable, Sendable {
    case medium
    case large
  }

  public enum Tone: CaseIterable, Hashable, Sendable {
    case neutral
    case brand
  }

  public enum Weight: CaseIterable, Hashable, Sendable {
    case regular
    case bold
  }
}

extension BrianCheckboxProperty.Size {
  func minimumHeight(_ token: SpacingToken) -> CGFloat {
    switch self {
    case .medium: token.xxLarge
    case .large: token.xxLarge + token.xSmall
    }
  }

  func typography(_ token: TypographyToken) -> Typography {
    switch self {
    case .medium: token.body.medium
    case .large: token.body.large
    }
  }
}

extension BrianCheckboxProperty.Weight {
  var fontWeight: Font.Weight {
    switch self {
    case .regular: .regular
    case .bold: .bold
    }
  }
}

