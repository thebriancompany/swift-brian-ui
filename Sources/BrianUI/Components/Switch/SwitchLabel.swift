import SwiftUI

public struct BrianSwitchLabel: View {
  @Environment(\.theme) private var theme
  @Environment(\.switchProperty) private var property
  @Environment(\.isEnabled) private var isEnabled

  private let title: String

  public init(_ title: String) {
    self.title = title
  }

  public var body: some View {
    Text(title)
      .typography(property.size.typography(theme.typography))
      .fontWeight(.medium)
      .foregroundStyle(isEnabled ? theme.color.foreground.primary : theme.color.foreground.disabled)
      .multilineTextAlignment(.leading)
      .fixedSize(horizontal: false, vertical: true)
  }
}
