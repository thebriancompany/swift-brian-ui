import SwiftUI

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
