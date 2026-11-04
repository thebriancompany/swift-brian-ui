import SwiftUI

public struct BrianMenuGroup<Content: View>: View {
  @Environment(\.theme) private var theme
  private let title: String?
  private let content: Content

  /// Creates a menu group.
  /// - Parameters:
  ///   - title: A noninteractive group title. Omitted when `nil`.
  ///   - content: The group's items. Empty content displays only the title.
  public init(
    _ title: String? = nil,
    @ViewBuilder content: () -> Content
  ) {
    self.title = title
    self.content = content()
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: .zero) {
      if let title {
        Text(title)
          .typography(theme.typography.label.small)
          .foregroundStyle(theme.color.foreground.secondary)
          .padding(.horizontal, theme.spacing.large)
          .padding(.vertical, theme.spacing.small)
      }

      content
    }
  }
}

public struct BrianMenuDivider: View {
  @Environment(\.theme) private var theme

  public init() {}

  public var body: some View {
    Rectangle()
      .fill(theme.color.border.base)
      .frame(height: 1)
      .padding(.horizontal, theme.spacing.large)
      .padding(.vertical, theme.spacing.small)
  }
}
