import SwiftUI

struct BrianChipButtonStyle: ButtonStyle {
  let isSelected: Bool

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .modifier(BrianChipAppearance(isSelected: isSelected, isPressed: configuration.isPressed))
  }
}

struct BrianChipAppearance: ViewModifier {
  @Environment(\.theme) private var theme
  @Environment(\.isEnabled) private var isEnabled
  @Environment(\.chipProperty) private var property

  let isSelected: Bool
  let isPressed: Bool

  func body(content: Content) -> some View {
    let isPressed = isPressed && isEnabled
    content
      .typography(theme.typography.label.medium)
      .fontWeight(.medium)
      .lineLimit(1)
      .foregroundStyle(foregroundColor)
      .padding(.horizontal, property.size.horizontalPadding(theme.spacing))
      .padding(.vertical, theme.spacing.xSmall)
      .frame(
        minWidth: property.layout == .iconOnly
          ? property.size.minimumHeight : property.size.minimumTextWidth,
        minHeight: property.size.minimumHeight
      )
      .background(isPressed ? background.pressed : background.normal, in: .capsule)
      .overlay {
        Capsule()
          .strokeBorder(borderColor, lineWidth: 1)
          .allowsHitTesting(false)
      }
      .contentShape(.capsule)
      .opacity(isEnabled ? 1 : 0.5)
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

  private var usesStrongSelection: Bool {
    isSelected && property.variant != .outlineWeak
  }

  private var foregroundColor: Color {
    usesStrongSelection ? theme.color.foreground.inverse : theme.color.foreground.primary
  }

  private var background: ColorToken.State {
    if usesStrongSelection {
      return theme.color.background.neutral.solid
    }
    if isSelected || property.variant == .solid {
      return theme.color.background.neutral.weak
    }
    return theme.color.background.transparent
  }

  private var borderColor: Color {
    guard property.variant != .solid, !usesStrongSelection else { return .clear }
    return isSelected ? theme.color.border.strong : theme.color.border.base
  }
}

struct BrianChipRemoveButtonStyle: ButtonStyle {
  @Environment(\.theme) private var theme
  @Environment(\.isEnabled) private var isEnabled

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .contentShape(.rect)
      .background {
        if configuration.isPressed && isEnabled {
          Capsule().fill(theme.color.background.transparent.pressed)
        }
      }
  }
}
