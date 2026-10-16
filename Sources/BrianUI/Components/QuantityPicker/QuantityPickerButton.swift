import SwiftUI

public struct BrianQuantityPickerButton<Label: View>: View {
  @Environment(\.theme) private var theme
  @Environment(\.quantityPickerProperty) private var property

  private let action: () -> Void
  private let label: () -> Label

  init(
    action: @escaping () -> Void,
    label: @escaping () -> Label
  ) {
    self.action = action
    self.label = label
  }


  public var body: some View {
    Button(action: action, label: label)
      .buttonStyle(BrianQuantityPickerButtonStyle())
      .quantityPickerProperty(property)
  }
}

private struct BrianQuantityPickerButtonStyle: ButtonStyle {
  @Environment(\.theme) private var theme
  @Environment(\.isEnabled) private var isEnabled
  @Environment(\.isLoading) private var isLoading
  @Environment(\.quantityPickerProperty) private var property

  func makeBody(configuration: Configuration) -> some View {
    let isPressed = configuration.isPressed && isEnabled && !isLoading
    return configuration.label
      .frame(width: size, height: size)
      .foregroundStyle(foregroundColor)
      .padding(.vertical, verticalPadding)
      .padding(.horizontal, horizontalPadding)
      .contentShape(shape)
      .background(backgroundColor(isPressed: isPressed), in: shape)
  }

  private var size: CGFloat {
    switch property.size {
    case .small: 12
    case .medium: 16
    case .large: 20
    }
  }

  private var shape: RoundedRectangle {
    .rect(cornerRadius: radius)
  }

  private var foregroundColor: Color {
    return isEnabled ? theme.color.foreground.primary : theme.color.foreground.disabled
  }

  private func backgroundColor(isPressed: Bool) -> Color {
    let state: ColorToken.State = theme.color.background.transparent
    guard isEnabled else {
      return state.disabled
    }
    return isPressed ? state.pressed : state.normal
  }

  private var horizontalPadding: CGFloat {
    switch property.size {
    case .small: theme.spacing.medium
    case .medium: theme.spacing.large
    case .large: theme.spacing.xLarge
    }
  }

  private var verticalPadding: CGFloat {
    switch property.size {
    case .small: theme.spacing.small
    case .medium: theme.spacing.medium
    case .large: theme.spacing.large
    }
  }

  private var radius: CGFloat {
    switch property.size {
    case .small: theme.radius.small
    case .medium: theme.radius.medium
    case .large: theme.radius.large
    }
  }
}
