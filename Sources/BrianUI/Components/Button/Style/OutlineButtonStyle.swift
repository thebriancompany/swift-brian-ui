import SwiftUI

public struct BrianOutlineButtonStyle: ButtonStyle {
  @Environment(\.theme) private var theme
  @Environment(\.isEnabled) private var isEnabled
  @Environment(\.isLoading) private var isLoading
  @Environment(\.buttonProperty) private var property

  private var isButtonActive: Bool {
    isLoading || isEnabled
  }

  public init() {}

  public func makeBody(configuration: Configuration) -> some View {
    let isPressed = configuration.isPressed && isEnabled && !isLoading
    return configuration.label
      .typography(typography)
      .opacity(isLoading ? 0 : 1)
      .overlay {
        if isLoading {
          BrianLoadingSpinner(size: spinnerSize)
        }
      }
      .foregroundStyle(foregroundColor)
      .padding(.vertical, verticalPadding)
      .padding(.horizontal, horizontalPadding)
      .background(backgroundColor(isPressed: isPressed), in: shape)
      .contentShape(shape)
      .overlay {
        shape.strokeBorder(borderColor, lineWidth: 1)
      }
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

  private var spinnerSize: CGFloat {
    switch property.size {
    case .xsmall: 14
    case .small: 16
    case .medium: 20
    case .large: 24
    }
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
    guard isButtonActive else {
      return theme.color.foreground.disabled
    }

    switch property.tone {
    case .brand: return theme.color.foreground.brand.normal
    case .neutral: return theme.color.foreground.primary
    case .critical: return theme.color.foreground.critical.normal
    }
  }

  private var borderColor: Color {
    if isButtonActive {
      return theme.color.border.base
    } else {
      return theme.color.border.disabled
    }
  }

  private func backgroundColor(isPressed: Bool) -> Color {
    let state = theme.color.background.transparent
    guard isButtonActive else {
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
