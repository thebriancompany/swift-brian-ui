import SwiftUI

extension EnvironmentValues {
  @Entry var alertPresentation: BrianModalPresentation? = nil
}

struct BrianAlertHostedContent<Content: View>: View {
  let content: Content
  let environment: EnvironmentValues
  let presentation: BrianModalPresentation

  var body: some View {
    content
      .background(environment.theme.color.background.base)
      .clipShape(.rect(cornerRadius: environment.theme.radius.xLarge))
      .environment(\.self, presentationEnvironment)
      .accessibilityAction(.escape) {
        presentation.requestDismissal()
      }
  }

  private var presentationEnvironment: EnvironmentValues {
    var environment = environment
    environment.alertPresentation = presentation
    return environment
  }
}

enum BrianAlertGeometry {
  static let margin: CGFloat = 24
  static let maximumWidth: CGFloat = 360
  static let travel: CGFloat = 24

  static func cardFrame(in bounds: CGRect, fittingSize: (CGSize) -> CGSize) -> CGRect {
    let available = bounds.insetBy(dx: margin, dy: margin)
    let width = max(0, min(maximumWidth, available.width))
    let maximumHeight = max(0, available.height)
    let size = fittingSize(.init(width: width, height: maximumHeight))
    let height = max(0, min(size.height, maximumHeight))
    return .init(
      x: bounds.midX - width / 2,
      y: bounds.midY - height / 2,
      width: width,
      height: height
    )
  }
}
