import SwiftUI

public struct BrianMenuGroup<Content: View>: View {
  @Environment(\.theme) private var theme
  private let title: String?
  private let content: Content

  /// 메뉴 그룹을 만듭니다.
  /// - Parameters:
  ///   - title: 동작 없이 표시할 그룹 제목입니다. `nil`이면 생략합니다.
  ///   - content: 그룹에 속한 항목입니다. 빈 콘텐츠는 제목만 표시합니다.
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
          .foregroundStyle(theme.color.foreground.tertiary)
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
