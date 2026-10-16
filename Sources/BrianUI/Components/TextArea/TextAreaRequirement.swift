import Foundation

public enum BrianTextAreaRequirement: Hashable, Sendable {
  case none
  case required
  case optional(String)
}
