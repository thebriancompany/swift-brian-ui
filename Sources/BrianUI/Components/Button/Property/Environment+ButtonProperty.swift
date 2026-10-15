import SwiftUI

extension EnvironmentValues {
  @Entry var buttonSize: BrianButtonProperty.Size? = nil
  @Entry var buttonTone: BrianButtonProperty.Tone? = nil

  var buttonProperty: BrianButtonProperty {
    get {
      .init(
        size: buttonSize ?? .medium,
        tone: buttonTone ?? .neutral
      )
    }
    set {
      buttonTone = newValue.tone
      buttonSize = newValue.size
    }
  }
}

extension View {
  public func buttonProperty(_ property: BrianButtonProperty) -> some View {
    environment(\.buttonProperty, property)
  }

  public func buttonSize(_ size: BrianButtonProperty.Size) -> some View {
    environment(\.buttonSize, size)
  }

  public func buttonTone(_ tone: BrianButtonProperty.Tone) -> some View {
    environment(\.buttonTone, tone)
  }
}
