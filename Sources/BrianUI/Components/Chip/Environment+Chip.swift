import SwiftUI

extension EnvironmentValues {
  @Entry var chipProperty = BrianChipProperty()
}

extension View {
  /// Replaces the size, style, and layout of descendant chips together.
  public func chipProperty(_ property: BrianChipProperty) -> some View {
    environment(\.chipProperty, property)
  }

  /// Changes descendant chip size while preserving other settings.
  public func chipSize(_ size: BrianChipProperty.Size) -> some View {
    transformEnvironment(\.chipProperty) { $0.size = size }
  }

  /// Changes descendant chip selection appearance while preserving other settings.
  public func chipVariant(_ variant: BrianChipProperty.Variant) -> some View {
    transformEnvironment(\.chipProperty) { $0.variant = variant }
  }

  /// Changes descendant chip minimum width to match the content layout.
  ///
  /// `.iconOnly` does not hide text automatically. Apply `.labelStyle(.iconOnly)` to a `Label`.
  public func chipLayout(_ layout: BrianChipProperty.Layout) -> some View {
    transformEnvironment(\.chipProperty) { $0.layout = layout }
  }
}
