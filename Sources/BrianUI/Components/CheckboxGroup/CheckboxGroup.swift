import SwiftUI

/// Arranges checkboxes vertically. Emphasizes an optional header and indents its children.
/// Group properties also apply to child items. Nest groups to organize child items.
/// Headers without an explicit font emphasis use `.bold`; ancestor or item settings take precedence.
///
/// ```swift
/// BrianCheckboxGroup {
///   BrianCheckbox("Agree to terms of service", isOn: $terms)
///
///   BrianCheckbox("Agree to privacy policy", isOn: $privacy)
/// } header: {
///   BrianCheckbox("Agree to all", sources: [$terms, $privacy])
/// }
/// .checkboxTone(.brand)
/// ```
public struct BrianCheckboxGroup<Content, Header>: View where Content: View, Header: View {
  @Environment(\.theme) private var theme

  private let content: Content
  private let header: Header?

  public init(
    @ViewBuilder content: () -> Content,
    @ViewBuilder header: () -> Header
  ) {
    self.content = content()
    self.header = header()
  }

  public init(
    @ViewBuilder content: () -> Content
  ) where Header == EmptyView {
    self.content = content()
    self.header = nil
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: theme.spacing.xSmall) {
      if let header {
        header
          .checkboxWeight(.bold)

        HStack(alignment: .top, spacing: theme.spacing.small) {
          BrianCheckboxIcon()
            .checkboxWeight(.bold)
            .hidden()
            .frame(height: .zero)

          items
        }
      } else {
        items
      }
    }
  }

  private var items: some View {
    VStack(alignment: .leading, spacing: theme.spacing.xSmall) {
      content
    }
  }
}
