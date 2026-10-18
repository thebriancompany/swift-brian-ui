import Foundation

public struct BrianFloatingButtonProperty: Hashable, Sendable {
  public var size: Size
  public var tone: Tone
  public var layout: Layout

  public init(
    size: Size = .small,
    tone: Tone = .solid,
    layout: Layout = .withText
  ) {
    self.size = size
    self.tone = tone
    self.layout = layout
  }
}

extension BrianFloatingButtonProperty {
  public enum Size: CaseIterable, Hashable, Sendable {
    /// Text buttons have a minimum height of 36pt; icon-only buttons are 44pt.
    case small
    /// Text buttons have a minimum height of 48pt; icon-only buttons are 56pt.
    case large
  }

  public enum Tone: CaseIterable, Hashable, Sendable {
    case brand
    case solid
    case layer
  }

  public enum Layout: CaseIterable, Hashable, Sendable {
    case withText
    case iconOnly
  }
}
