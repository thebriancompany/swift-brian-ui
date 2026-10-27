import SwiftUI

public struct BrianBadge: View {
  @Environment(\.theme) private var theme
  @Environment(\.isEnabled) private var isEnabled
  @Environment(\.badgeProperty) private var property

  private let title: String
  private let systemImage: String?

  public init(
    title: String,
    systemImage: String? = nil
  ) {
    self.title = title
    self.systemImage = systemImage
  }

  public var body: some View {
    HStack(spacing: spacing) {
      if let systemImage {
        Image(systemName: systemImage)
          .fixedSize()
      }

      Text(title)
        .lineLimit(1)
        .truncationMode(.tail)
    }
    .typography(typography)
    .fontWeight(property.variant == .weak ? .medium : .bold)
    .foregroundStyle(foregroundColor)
    .padding(.horizontal, horizontalPadding)
    .padding(.vertical, theme.spacing.xSmall)
    .background {
      if let gradient = property.gradient, isEnabled, property.variant != .outline {
        ControlGradientFill(
          style: gradient,
          strength: property.variant == .solid ? .vivid : .subtle,
          shape: shape
        )
      } else {
        shape.fill(backgroundColor)
      }
    }
    .overlay {
      if property.variant == .outline {
        if let gradient = property.gradient, isEnabled {
          ControlGradientBorder(style: gradient, shape: shape)
        } else {
          shape.strokeBorder(borderColor, lineWidth: 1)
        }
      }
    }
  }

  private var typography: Typography {
    switch property.size {
    case .medium: theme.typography.label.small
    case .large: theme.typography.label.medium
    }
  }

  private var horizontalPadding: CGFloat {
    switch property.size {
    case .medium: theme.spacing.small
    case .large: theme.spacing.medium
    }
  }

  private var shape: RoundedRectangle {
    let radius = switch property.size {
    case .medium: theme.radius.small
    case .large: theme.radius.medium
    }
    return .rect(cornerRadius: radius)
  }

  private var spacing: CGFloat {
    switch property.size {
    case .medium: theme.spacing.xSmall
    case .large: theme.spacing.xSmall
    }
  }

  private var backgroundRole: ColorToken.Background.Role {
    switch property.tone {
    case .neutral: theme.color.background.neutral
    case .brand: theme.color.background.brand
    case .informative: theme.color.background.informative
    case .positive: theme.color.background.positive
    case .warning: theme.color.background.warning
    case .critical: theme.color.background.critical
    }
  }

  private var backgroundColor: Color {
    let state: ColorToken.State =
    switch property.variant {
    case .weak: backgroundRole.weak
    case .solid: backgroundRole.solid
    case .outline: theme.color.background.transparent
    }
    return isEnabled ? state.normal : state.disabled
  }

  private var foregroundColor: Color {
    guard isEnabled else {
      return theme.color.foreground.disabled
    }
    let foreground = theme.color.foreground
    if let gradient = property.gradient {
      return property.variant == .solid ? theme.gradient[gradient].foreground : foreground.primary
    }
    let role: ColorToken.Foreground.Role
    switch property.tone {
    case .neutral:
      return property.variant == .solid ? foreground.inverse : foreground.secondary

    case .brand:
      role = foreground.brand

    case .informative:
      role = foreground.informative

    case .positive:
      role = foreground.positive

    case .warning:
      role = foreground.warning

    case .critical:
      role = foreground.critical
    }
    return property.variant == .solid ? role.solid : role.strong
  }

  private var borderColor: Color {
    guard isEnabled else {
      return theme.color.border.disabled
    }
    let border = theme.color.border
    switch property.tone {
    case .neutral: return border.base
    case .brand: return border.brand.weak
    case .informative: return border.informative.weak
    case .positive: return border.positive.weak
    case .warning: return border.warning.weak
    case .critical: return border.critical.weak
    }
  }
}
