import SwiftUI

public struct BrianCheckboxLabel: View {
  @Environment(\.theme) private var theme
  @Environment(\.checkboxProperty) private var property
  @Environment(\.isEnabled) private var isEnabled

  private let title: String

  public init(_ title: String) {
    self.title = title
  }

  public var body: some View {
    Text(title)
      .typography(property.size.typography(theme.typography))
      .fontWeight(property.weight.fontWeight)
      .foregroundStyle(isEnabled ? theme.color.foreground.primary : theme.color.foreground.disabled)
      .multilineTextAlignment(.leading)
      .fixedSize(horizontal: false, vertical: true)
  }
}
