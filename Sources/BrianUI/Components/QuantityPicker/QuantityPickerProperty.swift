import Foundation

public struct BrianQuantityPickerProperty: Hashable, Sendable {
  public var size: Size

  public init(size: Size = .medium) {
    self.size = size
  }
}

extension BrianQuantityPickerProperty {
  public enum Size: CaseIterable, Hashable, Sendable {
    case small
    case medium
    case large
  }
}
