import SwiftUI

/// 바텀 시트의 제목, 본문 및 하단 액션을 배치하는 컨테이너입니다.
///
/// 이 뷰 자체는 시트를 표시하지 않습니다. `bottomSheet(isPresented:snapPoints:isDismissible:content:)`의 콘텐츠로 사용하세요.
public struct BrianBottomSheetContainer<Content: View, Footer: View>: View {
  @Environment(\.theme) private var theme
  @Environment(\.bottomSheetHeaderAlignment) private var alignment
  @Environment(\.bottomSheetShowsCloseButton) private var showsCloseButton
  @Environment(\.bottomSheetIsPresented) private var isPresented
  private let title: String?
  private let description: String?
  private let content: Content
  private let footer: Footer

  public init(
    title: String? = nil,
    description: String? = nil,
    @ViewBuilder content: () -> Content,
    @ViewBuilder footer: () -> Footer
  ) {
    self.title = title
    self.description = description
    self.content = content()
    self.footer = footer()
  }

  public init(
    title: String? = nil,
    description: String? = nil,
    @ViewBuilder content: () -> Content
  ) where Footer == EmptyView {
    self.init(
      title: title,
      description: description,
      content: content,
      footer: { EmptyView() }
    )
  }

  public var body: some View {
    VStack(spacing: .zero) {
      if title != nil || showsCloseButton {
        header
          .fixedSize(horizontal: false, vertical: true)
          .layoutPriority(1)
      }

      ViewThatFits(in: .vertical) {
        paddedContent
          .fixedSize(horizontal: false, vertical: true)

        ScrollView {
          paddedContent
        }
        .contentFog(.bottom, fraction: 0.08)
      }

      if Footer.self != EmptyView.self {
        footer
          .buttonTone(.neutral)
          .buttonSize(.large)
          .padding(.horizontal, theme.spacing.xLarge)
          .padding(.top, theme.spacing.medium)
          .padding(.bottom, theme.spacing.large)
          .fixedSize(horizontal: false, vertical: true)
          .layoutPriority(1)
      }
    }
  }

  private var paddedContent: some View {
    content
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, theme.spacing.xLarge)
      .padding(.vertical, theme.spacing.large)
  }

  private var header: some View {
    VStack(
      alignment: alignment == .center ? .center : .leading,
      spacing: theme.spacing.small
    ) {
      if let title {
        Text(title)
          .typography(theme.typography.title.medium)
          .foregroundStyle(theme.color.foreground.primary)
          .padding(.trailing, showsCloseButton ? 40 : 0)
          .padding(.leading, showsCloseButton && alignment == .center ? 40 : 0)

        if let description {
          Text(description)
            .typography(theme.typography.body.large)
            .foregroundStyle(theme.color.foreground.secondary)
        }
      }
    }
    .multilineTextAlignment(alignment == .center ? .center : .leading)
    .frame(maxWidth: .infinity, alignment: alignment == .center ? .center : .leading)
    .frame(minHeight: showsCloseButton ? 40 : 0)
    .padding(.top, theme.spacing.small)
    .padding(.horizontal, theme.spacing.xLarge)
    .padding(.bottom, theme.spacing.small)
    .overlay(alignment: .topTrailing) {
      if showsCloseButton {
        closeButton
          .foregroundStyle(theme.color.foreground.primary)
          .padding(.trailing, theme.spacing.large)
      }
    }
  }

  private var closeButton: some View {
    Button {
      isPresented?.wrappedValue = false
    } label: {
      Image(systemName: "xmark")
        .renderingMode(.template)
        .foregroundStyle(theme.color.foreground.primary)
        .frame(width: 20, height: 20)
        .padding(10)
        .background(theme.color.background.neutral.weak.normal, in: .circle)
    }
    .buttonStyle(.plain)
  }
}
