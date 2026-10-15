import SwiftUI

extension View {
  public func typography(_ typography: Typography) -> some View {
    modifier(TypographyModifier(typography: typography))
  }
}

private struct TypographyModifier: ViewModifier {
  let typography: Typography

  func body(content: Content) -> some View {
    content
      .font(typography.font)
  }
}
