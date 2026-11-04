import SwiftUI

extension EnvironmentValues {
  @Entry var badgeProperty = BrianBadgeProperty()
}

extension View {
  /// Replaces descendant badge size, tone, variant, and gradient together.
  public func badgeProperty(_ property: BrianBadgeProperty) -> some View {
    environment(\.badgeProperty, property)
  }

  public func badgeSize(_ size: BrianBadgeProperty.Size) -> some View {
    transformEnvironment(\.badgeProperty) { $0.size = size }
  }

  public func badgeTone(_ tone: BrianBadgeProperty.Tone) -> some View {
    transformEnvironment(\.badgeProperty) { $0.tone = tone }
  }

  public func badgeVariant(_ variant: BrianBadgeProperty.Variant) -> some View {
    transformEnvironment(\.badgeProperty) { $0.variant = variant }
  }

  /// Optionally applies an expressive gradient to descendant badges.
  ///
  /// Solid uses a vivid fill, weak a subtle fill, and outline a border.
  /// Text and icons remain solid colors; disabled controls use existing disabled colors.
  /// Takes precedence over `badgeTone(_:)` when enabled.
  ///
  /// - Parameter style: The palette to use. `nil` clears an inherited gradient.
  /// - Returns: A view with only the gradient changed, preserving other badge settings.
  public func badgeGradient(_ style: GradientToken.Style?) -> some View {
    transformEnvironment(\.badgeProperty) { $0.gradient = style }
  }
}
