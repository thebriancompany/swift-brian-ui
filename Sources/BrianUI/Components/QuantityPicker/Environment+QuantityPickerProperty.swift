import SwiftUI

extension EnvironmentValues {
  @Entry var quantityPickerProperty = BrianQuantityPickerProperty()
}

extension View {
  public func quantityPickerProperty(_ property: BrianQuantityPickerProperty) -> some View {
    environment(\.quantityPickerProperty, property)
  }

  public func quantityPickerSize(_ size: BrianQuantityPickerProperty.Size) -> some View {
    transformEnvironment(\.quantityPickerProperty) { $0.size = size }
  }
}
