import Foundation

public enum BrianCheckboxState: CaseIterable, Hashable, Sendable {
  case unselected
  case selected
  /// Only some of the child items are selected.
  case indeterminate
}
