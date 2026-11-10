import SwiftUI

/// Press feedback for caller-styled labels, without padding, fonts, colors, or backgrounds.
///
/// The caller owns the hit region, disabled appearance, and loading indicator.
/// `.isLoading(true)` still blocks interaction, but this style does not replace the label.
/// Scale changes rendered size only; layout dimensions remain unchanged.
public struct BrianPressButtonStyle: ButtonStyle {
  /// The visual response while pressed. Neither effect changes layout dimensions.
  public enum Effect: Hashable, Sendable {
    /// Scales to 97%. Uses opacity instead when Reduce Motion is enabled.
    case scale
    /// Reduces opacity to 70% without scaling.
    case opacity
  }

  @Environment(\.isEnabled) private var isEnabled
  @Environment(\.isLoading) private var isLoading
  private let effect: Effect

  /// Creates feedback for a custom label. Defaults to `.scale`.
  public init(_ effect: Effect = .scale) {
    self.effect = effect
  }

  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .modifier(ButtonPressFeedback(
        isPressed: configuration.isPressed && isEnabled && !isLoading,
        effect: effect
      ))
  }
}

/// Shared feedback for themed buttons and caller-styled labels.
struct ButtonPressFeedback: ViewModifier {
  @Environment(\.accessibilityReduceMotion) private var reduceMotion
  let isPressed: Bool
  let effect: BrianPressButtonStyle.Effect

  func body(content: Content) -> some View {
    let usesScale = effect == .scale && !reduceMotion
    content
      .scaleEffect(isPressed && usesScale ? 0.97 : 1)
      .opacity(isPressed && !usesScale ? 0.7 : 1)
      .animation(
        reduceMotion ? nil : .interactiveSpring(
          response: 0.22,
          dampingFraction: 0.75,
          blendDuration: 0.1
        ),
        value: isPressed
      )
  }
}
