import SwiftUI

public struct BrianQuantityPickerLabel: View {
  @Environment(\.theme) private var theme
  @Environment(\.isEnabled) private var isEnabled
  @Environment(\.isLoading) private var isLoading
  @Environment(\.quantityPickerProperty) private var property

  private let quantity: Int

  public init(quantity: Int) {
    self.quantity = quantity
  }

  public var body: some View {
    Text(quantity, format: .number)
      .typography(typography)
      .fontWeight(.semibold)
      .lineLimit(1)
      .frame(minWidth: contentSize)
      .frame(height: contentSize)
      .fixedSize(horizontal: true, vertical: false)
      .foregroundStyle(foregroundColor)
      .opacity(isLoading ? 0 : 1)
      .overlay {
        if isLoading {
          BrianLoadingSpinner(size: contentSize)
            .foregroundStyle(theme.color.foreground.primary)
        }
      }
  }

  private var contentSize: CGFloat {
    switch property.size {
    case .small: 20
    case .medium: 24
    case .large: 28
    }
  }

  private var typography: Typography {
    switch property.size {
    case .small: theme.typography.body.large
    case .medium: theme.typography.title.small
    case .large: theme.typography.title.medium
    }
  }

  private var foregroundColor: Color {
    guard isEnabled else {
      return theme.color.foreground.disabled
    }
    return theme.color.foreground.primary
  }
}
