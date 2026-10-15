import SwiftUI

public struct BrianSwitch<Label>: View where Label: View {
  private let toggle: Toggle<Label>

  public init(
    isOn: Binding<Bool>,
    @ViewBuilder label: () -> Label
  ) {
    self.toggle = Toggle(isOn: isOn, label: label)
  }

  public var body: some View {
    toggle
      .toggleStyle(BrianSwitchToggleStyle())
  }
}

extension BrianSwitch where Label == BrianSwitchLabel {
  public init(
    _ title: String,
    isOn: Binding<Bool>
  ) {
    self.init(isOn: isOn) {
      BrianSwitchLabel(title)
    }
  }
}
