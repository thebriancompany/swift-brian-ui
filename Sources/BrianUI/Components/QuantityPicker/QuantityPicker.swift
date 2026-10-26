import SwiftUI

/// 정수 수량을 한 번에 1씩 늘리거나 줄이는 컨트롤입니다.
///
/// 최솟값과 최댓값을 자동으로 제한하지 않습니다. 호출자가 각 방향의 비활성화 조건을 전달해야 합니다.
public struct BrianQuantityPicker: View {
  @Environment(\.theme) private var theme
  @Environment(\.isEnabled) private var isEnabled
  @Environment(\.quantityPickerProperty) private var property
  @Binding private var quantity: Int
  private let isDecrementDisabled: Bool
  private let isIncrementDisabled: Bool

  /// 수량 바인딩과 증감 버튼의 활성화 조건으로 컨트롤을 만듭니다.
  ///
  /// - Parameters:
  ///   - quantity: 표시하고 변경할 수량입니다.
  ///   - isDecrementDisabled: 감소 버튼을 비활성화할지 여부입니다. 기본값은 `false`입니다.
  ///   - isIncrementDisabled: 증가 버튼을 비활성화할지 여부입니다. 기본값은 `false`입니다.
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
        Image(systemName: "minus")
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
        Image(systemName: "plus")
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
