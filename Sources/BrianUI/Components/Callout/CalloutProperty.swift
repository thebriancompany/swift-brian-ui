import Foundation

public struct BrianCalloutProperty: Hashable, Sendable {
  public var tone: Tone

  public init(tone: Tone = .neutral) {
    self.tone = tone
  }

  public enum Tone: CaseIterable, Hashable, Sendable {
    case neutral
    case informative
    case warning
    case critical
    case positive
  }
}
