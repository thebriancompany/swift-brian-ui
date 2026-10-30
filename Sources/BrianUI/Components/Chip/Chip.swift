import SwiftUI

/// 선택값, 제안 액션 또는 삭제 가능한 입력값을 표시하는 캡슐 모양 컨트롤입니다.
///
/// 선택 상태는 호출자가 소유합니다. `Binding<Bool>` 초기화는 탭할 때 값을 반전하고,
/// `action:` 초기화는 전달받은 액션만 실행합니다. `.disabled(true)`는 모든 상호작용을 막습니다.
/// 커스텀 `label`에는 버튼 등 다른 상호작용 컨트롤을 넣지 마세요.
public struct BrianChip<Label: View>: View {
  @Environment(\.theme) private var theme
  @Environment(\.chipProperty) private var property
  @Binding private var isSelected: Bool

  private let label: Label
  private let interaction: Interaction

  private enum Interaction {
    case action(() -> Void)
    case removable(onRemove: () -> Void)
  }

  /// 탭할 때 선택 바인딩을 반전하는 칩을 만듭니다.
  public init(
    isSelected: Binding<Bool>,
    @ViewBuilder label: () -> Label
  ) {
    self._isSelected = isSelected
    self.label = label()
    self.interaction = .action { isSelected.wrappedValue.toggle() }
  }

  /// 선택 상태를 표시하고 탭하면 액션을 실행하는 칩을 만듭니다.
  ///
  /// `isSelected`는 기본값이 `false`이며 액션 실행 시 자동으로 변경되지 않습니다.
  /// 단일 선택 목록에서는 액션 안에서 선택한 항목의 ID를 갱신하세요.
  public init(
    isSelected: Bool = false,
    action: @escaping () -> Void,
    @ViewBuilder label: () -> Label
  ) {
    self._isSelected = .constant(isSelected)
    self.label = label()
    self.interaction = .action(action)
  }

  /// 뒤쪽 삭제 버튼만 상호작용하는 입력 칩을 만듭니다.
  ///
  /// - Parameters:
  ///   - label: 입력값을 표시하는 콘텐츠입니다.
  ///   - onRemove: 삭제 요청입니다. 실제 데이터와 칩을 제거하는 일은 호출자가 담당합니다.
  public init(
    @ViewBuilder removable label: () -> Label,
    onRemove: @escaping () -> Void
  ) {
    self._isSelected = .constant(false)
    self.label = label()
    self.interaction = .removable(onRemove: onRemove)
  }

  public var body: some View {
    switch interaction {
    case let .action(action):
      Button(action: action) {
        label
      }
      .buttonStyle(BrianChipButtonStyle(isSelected: isSelected))

    case let .removable(onRemove):
      HStack(spacing: .zero) {
        label

        Button(action: onRemove) {
          Image(systemName: "xmark")
            .font(.system(size: property.size.suffixIconSize, weight: .medium))
            .frame(width: property.size.suffixIconSize)
            .padding(.horizontal, theme.spacing.medium / 2)
            .frame(minHeight: property.size.minimumHeight - theme.spacing.xSmall * 2)
        }
        .buttonStyle(BrianChipRemoveButtonStyle())
      }
      .modifier(BrianChipAppearance(isSelected: false, isPressed: false))
    }
  }
}

extension BrianChip where Label == BrianChipLabel {
  /// 텍스트와 선택적인 장식을 사용해 선택 바인딩을 반전하는 칩을 만듭니다.
  public init(
    _ title: String,
    isSelected: Binding<Bool>,
    prefix: BrianChipLabel.Prefix? = nil,
    suffixSystemImage: String? = nil
  ) {
    self.init(isSelected: isSelected) {
      BrianChipLabel(title, prefix: prefix, suffixSystemImage: suffixSystemImage)
    }
  }

  /// 텍스트와 선택적인 장식을 사용해 액션을 실행하는 칩을 만듭니다.
  ///
  /// `isSelected`는 표시 전용이며 액션에서 상태 변경을 직접 처리합니다.
  public init(
    _ title: String,
    isSelected: Bool = false,
    prefix: BrianChipLabel.Prefix? = nil,
    suffixSystemImage: String? = nil,
    action: @escaping () -> Void
  ) {
    self.init(isSelected: isSelected, action: action) {
      BrianChipLabel(title, prefix: prefix, suffixSystemImage: suffixSystemImage)
    }
  }

  /// 텍스트와 뒤쪽 삭제 버튼으로 입력 칩을 만듭니다.
  ///
  /// 텍스트 영역은 액션을 실행하지 않으며 `onRemove`에서 실제 데이터를 제거해야 합니다.
  /// `removable:` 레이블로 일반 액션 초기화와 구분합니다.
  public init(
    removable title: String,
    prefix: BrianChipLabel.Prefix? = nil,
    onRemove: @escaping () -> Void
  ) {
    self.init(removable: {
      BrianChipLabel(title, prefix: prefix)
    }, onRemove: onRemove)
  }
}
