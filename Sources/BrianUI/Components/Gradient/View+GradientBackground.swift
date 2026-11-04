import SwiftUI

extension View {
  /// Applies a gradient background and a matching default content color together.
  ///
  /// `.subtle` uses the theme's default foreground color; `.vivid` uses the palette's `foreground`.
  /// Descendant views retain their explicitly configured foreground colors and button styles.
  /// Does not add padding or corners. Apply after padding and finish with `clipShape`.
  ///
  /// - Parameters:
  ///   - style: The theme palette to use. Defaults to `.aurora`.
  ///   - strength: The background strength. Defaults to `.subtle`.
  /// - Returns: A view with the background and default content color configured.
  public func gradientBackground(
    _ style: GradientToken.Style = .aurora,
    strength: BrianGradient.Strength = .subtle
  ) -> some View {
    modifier(GradientBackgroundModifier(style: style, strength: strength))
  }
}

private struct GradientBackgroundModifier: ViewModifier {
  @Environment(\.theme) private var theme

  let style: GradientToken.Style
  let strength: BrianGradient.Strength

  func body(content: Content) -> some View {
    content
      .foregroundStyle(
        strength == .subtle ? theme.color.foreground.primary : theme.gradient[style].foreground
      )
      .background {
        BrianGradient(style, strength: strength)
      }
  }
}
