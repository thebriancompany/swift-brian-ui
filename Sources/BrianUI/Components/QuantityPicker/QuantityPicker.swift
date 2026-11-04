import BrianSymbols
import SwiftUI

/// A control that increments or decrements an integer quantity by 1.
///
/// Does not enforce a minimum or maximum. The caller must supply disabled conditions for each direction.
public struct BrianQuantityPicker: View {
  @Environment(\.theme) private var theme
  @Environment(\.isEnabled) private var isEnabled
  @Environment(\.quantityPickerProperty) private var property
  @Binding private var quantity: Int
  private let isDecrementDisabled: Bool
  private let isIncrementDisabled: Bool

  /// Creates a control with a quantity binding and conditions for enabling its step buttons.
  ///
  /// - Parameters:
  ///   - quantity: The quantity to display and update.
  ///   - isDecrementDisabled: Whether to disable the decrement button. Defaults to `false`.
  ///   - isIncrementDisabled: Whether to disable the increment button. Defaults to `false`.
  public init(
    quantity: Binding<Int>,
    isDecrementDisabled: Bool = false,
    isIncrementDisabled: Bool = false
  ) {
    self._quantity = quantity
    self.isDecrementDisabled = isDecrementDisabled
    self.isIncrementDisabled = isIncrementDisabled
  }

  public var body: some View {
    HStack(spacing: .zero) {
      BrianQuantityPickerButton {
        quantity -= 1
      } label: {
        Image(symbol: .minus)
      }
      .disabled(isDecrementDisabled)

      BrianQuantityPickerDivider()

      BrianQuantityPickerLabel(
        quantity: quantity
      )
      .padding(.horizontal, contentPadding)

      BrianQuantityPickerDivider()

      BrianQuantityPickerButton {
        quantity += 1
      } label: {
        Image(symbol: .plus)
      }
      .disabled(isIncrementDisabled)
    }
    .padding(.vertical, verticalPadding)
    .background(theme.color.background.base, in: shape)
    .overlay {
      shape
        .strokeBorder(
          theme.color.border.base,
          lineWidth: 1
        )
    }
  }
  private var shape: RoundedRectangle {
    .rect(cornerRadius: radius)
  }

  private var radius: CGFloat {
    switch property.size {
    case .small: theme.radius.small
    case .medium: theme.radius.medium
    case .large: theme.radius.large
    }
  }

  private var verticalPadding: CGFloat {
    switch property.size {
    case .small: theme.spacing.xSmall
    case .medium: theme.spacing.small
    case .large: theme.spacing.small
    }
  }

  private var contentPadding: CGFloat {
    switch property.size {
    case .small: theme.spacing.medium
    case .medium: theme.spacing.large
    case .large: theme.spacing.xLarge
    }
  }
}

private struct BrianQuantityPickerDivider: View {
  @Environment(\.theme) private var theme
  @Environment(\.quantityPickerProperty) private var property

  var body: some View {
    Rectangle()
      .fill(theme.color.border.base)
      .frame(width: 1, height: size)
  }

  private var size: CGFloat {
    switch property.size {
    case .small: 20
    case .medium: 24
    case .large: 28
    }
  }
}
