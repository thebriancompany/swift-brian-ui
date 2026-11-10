import SwiftUI

/// A themed button combining appearance and shape with environment size, tone, and gradient.
///
/// Use `.buttonStyle(.brian(.weak, shape: .circle))` for a circular button.
/// Loading preserves the button footprint and replaces the label with a spinner.
/// The style does not resize or clip custom images; configure them in the label.
public struct BrianButtonStyle: ButtonStyle {
  /// Background and border treatment, independent of tone and shape.
  public enum Appearance: CaseIterable, Hashable, Sendable {
    /// A vivid filled background.
    case solid
    /// A subtle filled background.
    case weak
    /// A border with a transparent background until pressed.
    case outline
    /// A transparent background until pressed, with standard button layout.
    case ghost
  }

  /// The button outline and layout policy. Does not hide label text automatically.
  public enum Shape: CaseIterable, Hashable, Sendable {
    /// Content-sized layout with size-dependent corner radii.
    case rounded
    /// Content-sized layout with fully rounded ends.
    case capsule
    /// Equal width and height: 28, 36, 44, or 52 points by size.
    /// Uses a default symbol font of 14, 16, 20, or 24 points, respectively.
    /// Custom content must fit the diameter; it is not automatically clipped.
    case circle
  }

  private let appearance: Appearance
  private let buttonShape: Shape
  @Environment(\.theme) private var theme
  @Environment(\.isEnabled) private var isEnabled
  @Environment(\.isLoading) private var isLoading
  @Environment(\.buttonProperty) private var property
  private var isButtonActive: Bool {
    isLoading || isEnabled
  }

  /// Creates a standard button style. Size and tone come from the environment.
  ///
  /// - Parameters:
  ///   - appearance: The fill and border treatment.
  ///   - shape: The outline and layout policy. Defaults to `.rounded`.
  public init(_ appearance: Appearance, shape: Shape = .rounded) {
    self.appearance = appearance
    self.buttonShape = shape
  }

  public func makeBody(configuration: Configuration) -> some View {
    let isPressed = configuration.isPressed && isEnabled && !isLoading
    return configuration.label
      .font(buttonShape == .circle ? .system(size: spinnerSize) : typography.font)
      .opacity(isLoading ? 0 : 1)
      .foregroundStyle(foregroundColor)
      .padding(.vertical, buttonShape == .circle ? 0 : verticalPadding)
      .padding(.horizontal, buttonShape == .circle ? 0 : horizontalPadding)
      .frame(
        width: buttonShape == .circle ? diameter : nil,
        height: buttonShape == .circle ? diameter : nil
      )
      .overlay {
        if isLoading {
          BrianLoadingSpinner(size: spinnerSize)
            .foregroundStyle(foregroundColor)
            .accessibilityHidden(true)
            .allowsHitTesting(false)
        }
      }
      .contentShape(shape)
      .background {
        if let gradient = property.gradient, isButtonActive, appearance != .outline {
          ControlGradientFill(
            style: gradient,
            strength: appearance == .solid ? .vivid : .subtle,
            shape: shape,
            isPressed: isPressed
          )
          .opacity(appearance == .ghost && !isPressed ? 0 : 1)
        } else {
          shape.fill(backgroundColor(isPressed: isPressed))
        }
      }
      .overlay {
        if appearance == .outline {
          if let gradient = property.gradient, isButtonActive {
            ControlGradientBorder(style: gradient, shape: shape)
          } else {
            shape.strokeBorder(
              isButtonActive ? theme.color.border.base : theme.color.border.disabled,
              lineWidth: 1
            )
          }
        }
      }
      .modifier(ButtonPressFeedback(isPressed: isPressed, effect: .scale))
  }

  private var diameter: CGFloat {
    switch property.size {
    case .xsmall: 28
    case .small: 36
    case .medium: 44
    case .large: 52
    }
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
    switch buttonShape {
    case .rounded: .rect(cornerRadius: radius)
    case .capsule: .rect(cornerRadius: .greatestFiniteMagnitude, style: .circular)
    case .circle: .rect(cornerRadius: diameter / 2, style: .circular)
    }
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
    if let gradient = property.gradient {
      return appearance == .solid
        ? theme.gradient[gradient].foreground
        : theme.color.foreground.primary
    }
    switch property.tone {
    case .brand:
      switch appearance {
      case .solid: return theme.color.foreground.brand.solid
      case .weak: return theme.color.foreground.brand.strong
      case .outline, .ghost: return theme.color.foreground.brand.normal
      }
    case .neutral:
      return appearance == .solid ? theme.color.foreground.inverse : theme.color.foreground.primary
    case .critical:
      switch appearance {
      case .solid: return theme.color.foreground.critical.solid
      case .weak: return theme.color.foreground.critical.strong
      case .outline, .ghost: return theme.color.foreground.critical.normal
      }
    }
  }

  private func backgroundColor(isPressed: Bool) -> Color {
    let state: ColorToken.State
    switch appearance {
    case .outline, .ghost:
      state = theme.color.background.transparent
    case .solid:
      state = switch property.tone {
      case .brand: theme.color.background.brand.solid
      case .neutral: theme.color.background.neutral.solid
      case .critical: theme.color.background.critical.solid
      }
    case .weak:
      state = switch property.tone {
      case .brand: theme.color.background.brand.weak
      case .neutral: theme.color.background.neutral.weak
      case .critical: theme.color.background.critical.weak
      }
    }
    guard isButtonActive else { return state.disabled }
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
