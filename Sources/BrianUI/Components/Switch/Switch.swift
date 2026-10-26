import SwiftUI

/// 불리언 상태를 켜거나 끄는 BrianUI 토글입니다.
///
/// `Binding<Bool>`로 상태를 전달하고 `switchSize(_:)`, `switchTone(_:)`으로 외형을 설정합니다.
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
