import SwiftUI

extension EnvironmentValues {
  @Entry var floatingButtonProperty = BrianFloatingButtonProperty()
}

extension View {
  public func floatingButtonProperty(_ property: BrianFloatingButtonProperty) -> some View {
    environment(\.floatingButtonProperty, property)
  }

  public func floatingButtonSize(_ size: BrianFloatingButtonProperty.Size) -> some View {
    transformEnvironment(\.floatingButtonProperty) { $0.size = size }
  }

  public func floatingButtonTone(_ tone: BrianFloatingButtonProperty.Tone) -> some View {
    transformEnvironment(\.floatingButtonProperty) { $0.tone = tone }
  }

  public func floatingButtonLayout(_ layout: BrianFloatingButtonProperty.Layout) -> some View {
    transformEnvironment(\.floatingButtonProperty) { $0.layout = layout }
  }
}
