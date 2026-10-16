import SwiftUI

extension EnvironmentValues {
  @Entry var textAreaProperty = BrianTextAreaProperty()
  @Entry var textAreaIsReadOnly = false
}

extension View {
  public func textAreaProperty(_ property: BrianTextAreaProperty) -> some View {
    environment(\.textAreaProperty, property)
  }

  public func textAreaSize(_ size: BrianTextAreaProperty.Size) -> some View {
    transformEnvironment(\.textAreaProperty) { $0.size = size }
  }

  public func textAreaWeight(_ weight: BrianTextAreaProperty.Weight) -> some View {
    transformEnvironment(\.textAreaProperty) { $0.weight = weight }
  }

  public func textAreaSizing(_ sizing: BrianTextAreaProperty.Sizing) -> some View {
    transformEnvironment(\.textAreaProperty) { $0.sizing = sizing }
  }

  public func textAreaReadOnly(_ isReadOnly: Bool) -> some View {
    environment(\.textAreaIsReadOnly, isReadOnly)
  }
}
