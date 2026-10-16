import SwiftUI

public struct BrianAlert<Header: View, Content: View, Footer: View>: View {
  @Environment(\.theme) private var theme

  private let header: Header?
  private let content: Content
  private let footer: Footer

  public init(
    header: (() -> Header)?,
    content: () -> Content,
    @BrianAlertFooter footer: () -> Footer
  ) {
    self.header = header?()
    self.content = content()
    self.footer = footer()
  }

  public init(
    _ title: String,
    description: String,
    @BrianAlertFooter footer: () -> Footer
  ) where Header == BrianAlertTitle, Content == BrianAlertContent {
    self.header = BrianAlertTitle(title)
    self.content = BrianAlertContent(description)
    self.footer = footer()
  }

  public init(
    description: String,
    @BrianAlertFooter footer: () -> Footer
  ) where Header == BrianAlertTitle, Content == BrianAlertContent {
    self.header = nil
    self.content = BrianAlertContent(description)
    self.footer = footer()
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: theme.spacing.medium) {
      ViewThatFits(in: .vertical) {
        headerAndContent
          .fixedSize(horizontal: false, vertical: true)

        ScrollView {
          headerAndContent
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
      }

      footer
        .fixedSize(horizontal: false, vertical: true)
        .padding(.top, theme.spacing.medium)
        .padding(.horizontal, theme.spacing.xLarge)
        .padding(.bottom, theme.spacing.xLarge)
        .layoutPriority(1)
    }
    .background {
      RoundedRectangle(cornerRadius: theme.radius.xLarge)
        .fill(theme.color.background.base)
    }
  }

  private var headerAndContent: some View {
    VStack(alignment: .leading, spacing: theme.spacing.medium) {
      header
      content
    }
    .padding(.top, theme.spacing.xLarge)
    .padding(.horizontal, theme.spacing.xLarge)
  }
}
