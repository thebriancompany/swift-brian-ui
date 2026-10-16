import SwiftUI

extension EnvironmentValues {
  @Entry var textFieldProperty = BrianTextFieldProperty()
  @Entry var textFieldIsReadOnly = false
  @Entry var textFieldShowsClearButton = false
}

extension View {
  public func textFieldProperty(_ property: BrianTextFieldProperty) -> some View {
    environment(\.textFieldProperty, property)
  }

  public func textFieldSize(_ size: BrianTextFieldProperty.Size) -> some View {
    transformEnvironment(\.textFieldProperty) { $0.size = size }
  }

  public func textFieldStyle(_ style: BrianTextFieldProperty.Style) -> some View {
    transformEnvironment(\.textFieldProperty) { $0.style = style }
  }

  public func textFieldWeight(_ weight: BrianTextFieldProperty.Weight) -> some View {
    transformEnvironment(\.textFieldProperty) { $0.weight = weight }
  }

  public func textFieldReadOnly(_ isReadOnly: Bool) -> some View {
    environment(\.textFieldIsReadOnly, isReadOnly)
  }

  public func textFieldClearButton(_ showsClearButton: Bool) -> some View {
    environment(\.textFieldShowsClearButton, showsClearButton)
  }
}
