import SwiftUI

/// 단일 선택 또는 여러 선택값의 전체 선택 상태를 표시하는 체크박스입니다.
///
/// `sources:` 초기화는 여러 `Binding<Bool>`을 연결합니다. 빈 컬렉션은 선택되지 않은 비활성 상태로 표시합니다.
/// ``BrianCheckboxGroup``은 배치만 담당하므로 전체 선택은 `sources:`로 연결하세요.
public struct BrianCheckbox<Label>: View where Label: View {
  private let toggle: Toggle<Label>
  private let isEmpty: Bool

  public init(
    isOn: Binding<Bool>,
    @ViewBuilder label: () -> Label
  ) {
    self.toggle = Toggle(isOn: isOn, label: label)
    self.isEmpty = false
  }

  public init(
    sources: some RandomAccessCollection<Binding<Bool>>,
    @ViewBuilder label: () -> Label
  ) {
    if sources.isEmpty {
      self.toggle = Toggle(isOn: .constant(false), label: label)
    } else {
      self.toggle = Toggle(sources: sources, isOn: \.self, label: label)
    }
    self.isEmpty = sources.isEmpty
  }

  public var body: some View {
    toggle
      .toggleStyle(BrianCheckboxToggleStyle())
      .disabled(isEmpty)
  }
}

extension BrianCheckbox where Label == BrianCheckboxLabel {
  public init(
    _ title: String,
    isOn: Binding<Bool>
  ) {
    self.init(isOn: isOn) {
      BrianCheckboxLabel(title)
    }
  }

  public init(
    _ title: String,
    sources: some RandomAccessCollection<Binding<Bool>>
  ) {
    self.init(sources: sources) {
      BrianCheckboxLabel(title)
    }
  }
}
