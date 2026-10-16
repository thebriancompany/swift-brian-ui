import Foundation

public enum BrianCheckboxState: CaseIterable, Hashable, Sendable {
  case unselected
  case selected
  /// 여러 하위 항목 중 일부만 선택되었습니다.
  case indeterminate
}
