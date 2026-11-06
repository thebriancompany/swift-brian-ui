import SwiftUI

struct BrianDatePickerPopupContent<Content: View>: View {
  let anchor: CGRect
  let bounds: CGRect
  let width: CGFloat
  let environment: EnvironmentValues
  let content: Content
  let dismiss: () -> Void

  var body: some View {
    BrianMenuOverlay(
      anchor: anchor, bounds: bounds, dismiss: dismiss,
      content: content.accessibilityAction(.escape, dismiss),
      preferredWidth: width, animatesPresentation: true
    )
    .environment(\.self, environment)
    .ignoresSafeArea()
    #if os(macOS)
      .onExitCommand(perform: dismiss)
    #endif
  }
}
