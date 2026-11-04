import SwiftUI

/// A gradient fill shared by buttons and badges.
struct ControlGradientFill: View {
  @Environment(\.theme) private var theme

  let style: GradientToken.Style
  let strength: BrianGradient.Strength
  let shape: RoundedRectangle
  var isPressed = false

  // Blend lightly to indicate pressing without excessively reducing foreground/background contrast.
  private static let pressedOverlayOpacity = 0.04

  var body: some View {
    BrianGradient(style, strength: strength)
      .overlay {
        foreground.opacity(isPressed ? Self.pressedOverlayOpacity : 0)
      }
      .clipShape(shape)
      .allowsHitTesting(false)
      .accessibilityHidden(true)
  }

  private var foreground: Color {
    strength == .vivid ? theme.gradient[style].foreground : theme.color.foreground.primary
  }
}

/// A decorative border that blends in the foreground color to keep small controls distinguishable.
struct ControlGradientBorder: View {
  @Environment(\.theme) private var theme
  @Environment(\.colorSchemeContrast) private var contrast

  let style: GradientToken.Style
  let shape: RoundedRectangle

  // Reinforce thin-border contrast while retaining the mesh hue.
  private static let borderContrastOpacity = 0.48

  var body: some View {
    Group {
      if contrast == .increased {
        shape.strokeBorder(theme.color.border.strong, lineWidth: 1)
      } else {
        BrianGradient(style, strength: .vivid)
          .overlay {
            theme.color.foreground.primary.opacity(Self.borderContrastOpacity)
          }
          .mask {
            shape.strokeBorder(lineWidth: 1)
          }
      }
    }
    .allowsHitTesting(false)
    .accessibilityHidden(true)
  }
}
