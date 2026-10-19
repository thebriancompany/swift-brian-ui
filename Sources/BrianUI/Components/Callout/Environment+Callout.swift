import SwiftUI

extension EnvironmentValues {
  @Entry var calloutProperty = BrianCalloutProperty()
}

extension View {
  public func calloutProperty(_ property: BrianCalloutProperty) -> some View {
    environment(\.calloutProperty, property)
  }

  public func calloutTone(_ tone: BrianCalloutProperty.Tone) -> some View {
    transformEnvironment(\.calloutProperty) { $0.tone = tone }
  }
}
