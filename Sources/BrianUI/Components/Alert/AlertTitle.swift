import SwiftUI

public struct BrianAlertTitle: View {
  @Environment(\.theme) private var theme
  private let title: String

  public init(_ title: String) {
    self.title = title
  }

  public var body: some View {
    Text(title)
      .typography(theme.typography.title.medium)
      .foregroundStyle(theme.color.foreground.primary)
      .frame(maxWidth: .infinity, alignment: .leading)
      .multilineTextAlignment(.leading)
  }
}
