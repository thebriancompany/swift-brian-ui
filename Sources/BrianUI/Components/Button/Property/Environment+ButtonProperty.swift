import SwiftUI

extension EnvironmentValues {
  @Entry var buttonProperty = BrianButtonProperty()
}

extension View {
  public func buttonProperty(_ property: BrianButtonProperty) -> some View {
    environment(\.buttonProperty, property)
  }

  public func buttonSize(_ size: BrianButtonProperty.Size) -> some View {
    transformEnvironment(\.buttonProperty) { $0.size = size }
  }

  public func buttonTone(_ tone: BrianButtonProperty.Tone) -> some View {
    transformEnvironment(\.buttonProperty) { $0.tone = tone }
  }
}
