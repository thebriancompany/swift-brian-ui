import SwiftUI

public struct BrianOutlineButtonStyle: ButtonStyle {
  @Environment(\.theme) private var theme
  @Environment(\.isEnabled) private var isEnabled
  @Environment(\.buttonProperty) private var property

  public init() {}

  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .typography(typography)
      .foregroundStyle(foregroundColor)
      .padding(.vertical, verticalPadding)
      .padding(.horizontal, horizontalPadding)
      .background(backgroundColor(isPressed: configuration.isPressed), in: shape)
      .contentShape(shape)
      .overlay {
        shape.strokeBorder(borderColor, lineWidth: 1)
      }
      .scaleEffect(configuration.isPressed ? 0.97 : 1)
      .animation(
        .interactiveSpring(
          response: 0.22,
          dampingFraction: 0.75,
          blendDuration: 0.1
        ),
        value: configuration.isPressed
      )
  }

  private var shape: RoundedRectangle {
    .rect(cornerRadius: radius)
  }

  private var typography: Typography {
    switch property.size {
    case .xsmall: theme.typography.body.small
    case .small: theme.typography.body.medium
    case .medium: theme.typography.body.large
    case .large: theme.typography.title.small
    }
  }

  private var foregroundColor: Color {
    guard isEnabled else {
      return theme.color.foreground.disabled
    }

    switch property.tone {
    case .brand: return theme.color.foreground.brand.normal
    case .neutral: return theme.color.foreground.primary
    case .critical: return theme.color.foreground.critical.normal
    }
  }

  private var borderColor: Color {
    if isEnabled {
      return theme.color.border.base
    } else {
      return theme.color.border.disabled
    }
  }

  private func backgroundColor(isPressed: Bool) -> Color {
    let state = theme.color.background.transparent
    guard isEnabled else {
      return state.disabled
    }
    return isPressed ? state.pressed : state.normal
  }

  private var horizontalPadding: CGFloat {
    switch property.size {
    case .xsmall: theme.spacing.small
    case .small: theme.spacing.medium
    case .medium: theme.spacing.large
    case .large: theme.spacing.xLarge
    }
  }

  private var verticalPadding: CGFloat {
    switch property.size {
    case .xsmall: theme.spacing.xSmall
    case .small: theme.spacing.small
    case .medium: theme.spacing.medium
    case .large: theme.spacing.large
    }
  }

  private var radius: CGFloat {
    switch property.size {
    case .xsmall: theme.radius.medium
    case .small: theme.radius.large
    case .medium: theme.radius.xLarge
    case .large: theme.radius.xLarge
    }
  }
}
