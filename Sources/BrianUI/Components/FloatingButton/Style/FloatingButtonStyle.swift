import SwiftUI

public struct BrianFloatingButtonStyle: ButtonStyle {
  @Environment(\.theme) private var theme
  @Environment(\.isEnabled) private var isEnabled
  @Environment(\.isLoading) private var isLoading
  @Environment(\.floatingButtonProperty) private var property

  public init() {}

  public func makeBody(configuration: Configuration) -> some View {
    let isPressed = configuration.isPressed && isEnabled && !isLoading

    configuration.label
      .labelStyle(
        FloatingButtonLabelStyle(
          layout: property.layout,
          iconSize: iconSize,
          spacing: theme.spacing.xSmall
        )
      )
      .typography(typography)
      .padding(.vertical, isIconOnly ? 0 : verticalPadding)
      .padding(.horizontal, isIconOnly ? 0 : horizontalPadding)
      .frame(width: isIconOnly ? diameter : nil, height: isIconOnly ? diameter : nil)
      .frame(minHeight: isIconOnly ? diameter : minimumHeight)
      .opacity(isLoading ? 0 : 1)
      .overlay {
        if isLoading {
          BrianLoadingSpinner(size: spinnerSize, lineWidth: 2)
            .accessibilityHidden(true)
        }
      }
      .foregroundStyle(foregroundColor)
      .background {
        Capsule()
          .fill(backgroundColor(isPressed: isPressed))
          .overlay {
            if usesLayer && (isPressed || isLoading) {
              Capsule().fill(theme.color.background.transparent.pressed)
            }
          }
          .shadow(theme.shadow.floating)
      }
      .contentShape(Capsule())
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

  private var isIconOnly: Bool {
    property.layout == .iconOnly
  }

  private var typography: Typography {
    switch property.size {
    case .small: theme.typography.label.medium
    case .large: theme.typography.label.large
    }
  }

  private var diameter: CGFloat {
    switch property.size {
    case .small: 44
    case .large: 56
    }
  }

  private var minimumHeight: CGFloat {
    switch property.size {
    case .small: 36
    case .large: 48
    }
  }

  private var horizontalPadding: CGFloat {
    switch property.size {
    case .small: 14
    case .large: 18
    }
  }

  private var verticalPadding: CGFloat {
    switch property.size {
    case .small: theme.spacing.small
    case .large: theme.spacing.medium
    }
  }

  private var iconSize: CGFloat {
    guard isIconOnly else { return 16 }
    return switch property.size {
    case .small: 22
    case .large: 24
    }
  }

  private var spinnerSize: CGFloat {
    switch property.size {
    case .small: 16
    case .large: 20
    }
  }

  private var usesLayer: Bool {
    property.tone == .layer || (isIconOnly && property.tone == .solid)
  }

  private var foregroundColor: Color {
    guard isLoading || isEnabled else {
      return theme.color.foreground.disabled
    }
    if property.tone == .brand {
      return theme.color.foreground.brand.solid
    }
    return usesLayer ? theme.color.foreground.primary : theme.color.foreground.inverse
  }

  private func backgroundColor(isPressed: Bool) -> Color {
    guard isLoading || isEnabled else {
      return theme.color.background.disabled
    }
    if usesLayer {
      return theme.color.background.elevated
    }
    let state = property.tone == .brand
      ? theme.color.background.brand.solid
      : theme.color.background.neutral.solid
    return isPressed || isLoading ? state.pressed : state.normal
  }
}

private struct FloatingButtonLabelStyle: LabelStyle {
  let layout: BrianFloatingButtonProperty.Layout
  let iconSize: CGFloat
  let spacing: CGFloat

  func makeBody(configuration: Configuration) -> some View {
    switch layout {
    case .withText:
      HStack(spacing: spacing) {
        configuration.icon
          .font(.system(size: iconSize))
          .frame(width: iconSize, height: iconSize)

        configuration.title
          .fixedSize(horizontal: false, vertical: true)
      }

    case .iconOnly:
      Label(configuration)
        .labelStyle(.iconOnly)
        .font(.system(size: iconSize))
        .frame(width: iconSize, height: iconSize)
    }
  }
}
