import SwiftUI

/// A BrianUI toggle that turns a Boolean state on or off.
///
/// Pass state through `Binding<Bool>` and configure appearance with `switchSize(_:)` and `switchTone(_:)`.
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
