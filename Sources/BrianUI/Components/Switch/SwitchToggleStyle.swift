import SwiftUI

struct BrianSwitchToggleStyle: ToggleStyle {
  @Environment(\.theme) private var theme
  @Environment(\.switchProperty) private var property
  @Environment(\.isEnabled) private var isEnabled

  func makeBody(configuration: Configuration) -> some View {
    Button {
      configuration.isOn.toggle()
    } label: {
      HStack(spacing: property.size.spacing(theme.spacing)) {
        BrianSwitchmark(configuration.isOn)

        configuration.label
          .typography(property.size.typography(theme.typography))
          .fontWeight(.medium)
          .foregroundStyle(
            isEnabled ? theme.color.foreground.primary : theme.color.foreground.disabled
          )
          .multilineTextAlignment(.leading)
          .fixedSize(horizontal: false, vertical: true)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .frame(minHeight: property.size.minimumHeight(theme.spacing))
      .contentShape(.rect)
    }
    .buttonStyle(BrianSwitchButtonStyle())
  }
}

private struct BrianSwitchButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .environment(\.switchIsPressed, configuration.isPressed)
  }
}
