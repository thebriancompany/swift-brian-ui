import Foundation

public enum BrianTextFieldRequirement: Hashable, Sendable {
  case none
  case required
  case optional(String)
}
