import SwiftUI

extension EnvironmentValues {
  @Entry var buttonProperty = BrianButtonProperty()
}

extension View {
  /// Replaces descendant standard button size, tone, and gradient settings together.
  public func buttonProperty(_ property: BrianButtonProperty) -> some View {
    environment(\.buttonProperty, property)
  }

  /// Changes only descendant standard button size, preserving other settings.
  public func buttonSize(_ size: BrianButtonProperty.Size) -> some View {
    transformEnvironment(\.buttonProperty) { $0.size = size }
  }

  /// Changes only descendant standard button tone, preserving other settings.
  /// A configured gradient takes precedence when enabled.
  public func buttonTone(_ tone: BrianButtonProperty.Tone) -> some View {
    transformEnvironment(\.buttonProperty) { $0.tone = tone }
  }

  /// Optionally applies an expressive gradient to descendant standard buttons.
  ///
  /// Solid uses a vivid fill, weak a subtle fill, and outline a border.
  /// Ghost shows a subtle fill only while pressed. Text and loading indicators remain solid colors.
  /// Disabled controls use existing disabled colors; loading retains enabled colors as in the existing styles.
  ///
  /// - Parameter style: The palette to use. `nil` clears an inherited gradient.
  /// - Returns: A view with gradient settings changed, preserving size and tone.
  public func buttonGradient(_ style: GradientToken.Style?) -> some View {
    transformEnvironment(\.buttonProperty) { $0.gradient = style }
  }
}
