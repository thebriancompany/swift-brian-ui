import SwiftUI

extension EnvironmentValues {
  @Entry var checkboxProperty = BrianCheckboxProperty()
  @Entry var checkboxIsPressed = false
}

extension View {
  public func checkboxProperty(_ property: BrianCheckboxProperty) -> some View {
    environment(\.checkboxProperty, property)
  }

  public func checkboxShape(_ shape: BrianCheckboxProperty.Shape) -> some View {
    transformEnvironment(\.checkboxProperty) { $0.shape = shape }
  }

  public func checkboxSize(_ size: BrianCheckboxProperty.Size) -> some View {
    transformEnvironment(\.checkboxProperty) { $0.size = size }
  }

  public func checkboxTone(_ tone: BrianCheckboxProperty.Tone) -> some View {
    transformEnvironment(\.checkboxProperty) { $0.tone = tone }
  }

  public func checkboxWeight(_ weight: BrianCheckboxProperty.Weight) -> some View {
    transformEnvironment(\.checkboxProperty) { $0.weight = weight }
  }
}
