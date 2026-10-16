import SwiftUI

extension EnvironmentValues {
  @Entry var menuProperty = BrianMenuProperty()
  @Entry var dismissMenu = BrianMenuDismissAction()
}

struct BrianMenuDismissAction {
  var action: () -> Void = {}

  func callAsFunction() {
    action()
  }
}

extension View {
  public func menuProperty(_ property: BrianMenuProperty) -> some View {
    environment(\.menuProperty, property)
  }

  public func menuSize(_ size: BrianMenuProperty.Size) -> some View {
    transformEnvironment(\.menuProperty) { $0.size = size }
  }

  public func menuWidth(_ width: BrianMenuProperty.Width) -> some View {
    transformEnvironment(\.menuProperty) { $0.width = width }
  }

  public func menuPlacement(_ placement: BrianMenuProperty.Placement) -> some View {
    transformEnvironment(\.menuProperty) { $0.placement = placement }
  }

  public func menuAlignment(_ alignment: BrianMenuProperty.Alignment) -> some View {
    transformEnvironment(\.menuProperty) { $0.alignment = alignment }
  }
}
