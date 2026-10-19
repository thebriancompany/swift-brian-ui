import SwiftUI

struct CalloutButtonStyle: ButtonStyle {
  @Environment(\.isEnabled) private var isEnabled

  let background: ColorToken.State
  let radius: CGFloat

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .background(
        isEnabled ? (configuration.isPressed ? background.pressed : background.normal) : background.disabled,
        in: .rect(cornerRadius: radius)
      )
  }
}

struct CalloutInteractionButtonStyle: ButtonStyle {
  @Environment(\.theme) private var theme
  @Environment(\.isEnabled) private var isEnabled
  @Environment(\.calloutProperty) private var property

  func makeBody(configuration: Configuration) -> some View {
    let isPressed = configuration.isPressed && isEnabled
    return configuration.label
      .typography(theme.typography.body.medium)
      .foregroundStyle(foregroundColor)
      .padding(.vertical, theme.spacing.small)
      .padding(.horizontal, theme.spacing.medium)
      .contentShape(shape)
      .background(
        isPressed ? theme.color.background.transparent.pressed : theme.color.background.transparent.normal,
        in: shape
      )
      .scaleEffect(isPressed ? 0.97 : 1)
      .animation(
        .interactiveSpring(
          response: 0.22,
          dampingFraction: 0.75,
          blendDuration: 0.1
        ),
        value: isPressed
      )
  }

  private var shape: RoundedRectangle {
    .rect(cornerRadius: theme.radius.medium)
  }


  private var foregroundColor: Color {
    let foreground = theme.color.foreground
    guard isEnabled else { return foreground.disabled }
    switch property.tone {
    case .neutral: return foreground.secondary
    case .informative: return foreground.informative.strong
    case .warning: return foreground.warning.strong
    case .critical: return foreground.critical.strong
    case .positive: return foreground.positive.strong
    }
  }
}
