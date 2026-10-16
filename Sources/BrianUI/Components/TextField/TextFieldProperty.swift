import Foundation

public struct BrianTextFieldProperty: Hashable, Sendable {
  public var size: Size
  public var style: Style
  public var weight: Weight

  public init(
    size: Size = .large,
    style: Style = .outline,
    weight: Weight = .medium
  ) {
    self.size = size
    self.style = style
    self.weight = weight
  }
}

extension BrianTextFieldProperty {
  public enum Size: CaseIterable, Hashable, Sendable {
    case medium
    case large
  }

  public enum Style: CaseIterable, Hashable, Sendable {
    case outline
    case underline
  }

  public enum Weight: CaseIterable, Hashable, Sendable {
    case medium
    case bold
  }
}
