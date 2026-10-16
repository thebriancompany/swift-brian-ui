import SwiftUI

struct BrianCheckboxToggleStyle: ToggleStyle {
  @Environment(\.theme) private var theme
  @Environment(\.checkboxProperty) private var property
  @Environment(\.isEnabled) private var isEnabled

  func makeBody(configuration: Configuration) -> some View {
    Button {
      configuration.isOn = configuration.isMixed || !configuration.isOn
    } label: {
      HStack(spacing: theme.spacing.small) {
        BrianCheckboxIcon(
          state: configuration.isMixed ? .indeterminate : (configuration.isOn ? .selected : .unselected)
        )

        configuration.label
          .typography(property.size.typography(theme.typography))
          .fontWeight(property.weight.fontWeight)
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
    .buttonStyle(BrianCheckboxButtonStyle())
  }
}

private struct BrianCheckboxButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .environment(\.checkboxIsPressed, configuration.isPressed)
  }
}
