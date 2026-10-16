import Foundation

public struct BrianTextAreaProperty: Hashable, Sendable {
  public var size: Size
  public var weight: Weight
  public var sizing: Sizing

  public init(
    size: Size = .large,
    weight: Weight = .medium,
    sizing: Sizing = .automatic()
  ) {
    self.size = size
    self.weight = weight
    self.sizing = sizing
  }
}

extension BrianTextAreaProperty {
  public enum Size: CaseIterable, Hashable, Sendable {
    case medium
    case large
  }

  public enum Weight: CaseIterable, Hashable, Sendable {
    case medium
    case bold
  }

  public enum Sizing: Hashable, Sendable {
    case automatic(maximumLines: Int? = nil)
    case fixed(lines: Int)

    var lineLimit: ClosedRange<Int> {
      switch self {
      case let .automatic(maximumLines):
        3...max(3, maximumLines ?? Int.max)

      case let .fixed(lines):
        max(2, lines)...max(2, lines)
      }
    }

    var minimumHeight: CGFloat {
      switch self {
      case .automatic: 95
      case .fixed: 70
      }
    }
  }
}
