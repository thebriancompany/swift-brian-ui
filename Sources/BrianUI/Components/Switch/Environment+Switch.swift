import SwiftUI

extension EnvironmentValues {
  @Entry var switchProperty = BrianSwitchProperty()
  @Entry var switchIsPressed = false
}

extension View {
  public func switchProperty(_ property: BrianSwitchProperty) -> some View {
    environment(\.switchProperty, property)
  }

  public func switchSize(_ size: BrianSwitchProperty.Size) -> some View {
    transformEnvironment(\.switchProperty) { $0.size = size }
  }

  public func switchTone(_ tone: BrianSwitchProperty.Tone) -> some View {
    transformEnvironment(\.switchProperty) { $0.tone = tone }
  }
}
