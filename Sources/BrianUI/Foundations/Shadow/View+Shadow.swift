import SwiftUI

extension View {
  public func shadow(_ shadow: Shadow) -> some View {
    modifier(ShadowModifier(shadow: shadow))
  }
}

private struct ShadowModifier: ViewModifier {
  let shadow: Shadow

  func body(content: Content) -> some View {
    content
      .shadow(
        color: shadow.primary.color,
        radius: shadow.primary.radius,
        x: shadow.primary.x,
        y: shadow.primary.y
      )
      .shadow(
        color: shadow.secondary.color,
        radius: shadow.secondary.radius,
        x: shadow.secondary.x,
        y: shadow.secondary.y
      )
  }
}
