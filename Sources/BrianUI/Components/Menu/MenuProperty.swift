import Foundation

public struct BrianMenuProperty: Hashable, Sendable {
  public var size: Size
  public var width: Width
  public var placement: Placement
  public var alignment: Alignment

  public init(
    size: Size = .medium,
    width: Width = .fixed,
    placement: Placement = .bottom,
    alignment: Alignment = .leading
  ) {
    self.size = size
    self.width = width
    self.placement = placement
    self.alignment = alignment
  }
}

extension BrianMenuProperty {
  public enum Size: CaseIterable, Hashable, Sendable {
    case small
    case medium
  }

  public enum Width: CaseIterable, Hashable, Sendable {
    case fixed
    case trigger
  }

  public enum Placement: CaseIterable, Hashable, Sendable {
    case top
    case bottom
  }

  public enum Alignment: CaseIterable, Hashable, Sendable {
    case leading
    case center
    case trailing
  }
}
