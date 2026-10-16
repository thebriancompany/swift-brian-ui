import SwiftUI

public struct BrianAlertContent: View {
  @Environment(\.theme) private var theme
  private let description: String

  public init(_ description: String) {
    self.description = description
  }

  public var body: some View {
    Text(description)
      .typography(theme.typography.body.large)
      .foregroundStyle(theme.color.foreground.primary)
      .frame(maxWidth: .infinity, alignment: .leading)
      .multilineTextAlignment(.leading)
  }
}
