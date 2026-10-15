import Foundation

public struct BrianSwitchProperty: Hashable, Sendable {
  public var size: Size
  public var tone: Tone

  public init(size: Size = .medium, tone: Tone = .neutral) {
    self.size = size
    self.tone = tone
  }
}
