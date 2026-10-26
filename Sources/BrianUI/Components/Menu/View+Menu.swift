import SwiftUI

extension View {
  /// 메뉴를 배치할 기준 뷰에 식별자를 등록합니다.
  ///
  /// 탭 동작은 추가하지 않습니다. 호출자가 `menuScope(selection:content:)`에 연결한 선택값을 변경해야 합니다.
  ///
  /// - Parameter id: 같은 메뉴 범위 안에서 기준 뷰를 구분할 식별자입니다.
  /// - Returns: 메뉴 기준 위치가 등록된 뷰입니다.
  public func menuAnchor<ID: Hashable>(id: ID) -> some View {
    modifier(BrianMenuAnchor(id: id))
  }

  /// 선택된 식별자와 일치하는 하위 앵커 위치에 메뉴를 표시합니다.
  ///
  /// 앵커와 선택값의 ID 타입이 같아야 하며 앵커는 이 범위의 하위 뷰에 있어야 합니다.
  /// 선택값이 `nil`이거나 일치하는 활성 앵커가 없으면 표시하지 않습니다.
  ///
  /// - Parameters:
  ///   - selection: 표시할 앵커 식별자입니다. 메뉴를 닫으면 `nil`이 됩니다.
  ///   - content: 선택된 식별자로 메뉴 콘텐츠를 구성하는 클로저입니다.
  /// - Returns: 메뉴 오버레이를 포함한 뷰입니다.
  public func menuScope<ID: Hashable, MenuContent: View>(
    selection: Binding<ID?>,
    @ViewBuilder content: @escaping (ID) -> MenuContent
  ) -> some View {
    overlayPreferenceValue(BrianMenuPreference<ID>.self) { anchors in
      GeometryReader { proxy in
        if let id = selection.wrappedValue,
           let anchor = anchors.last(where: { $0.id == id }),
           anchor.isEnabled
        {
          BrianMenuOverlay(
            anchor: proxy[anchor.bounds],
            bounds: CGRect(origin: .zero, size: proxy.size),
            dismiss: { selection.wrappedValue = nil },
            content: content(id)
          )
          .id(id)
          .onDisappear {
            if selection.wrappedValue == id {
              selection.wrappedValue = nil
            }
          }
        }
      }
    }
    .transformPreference(BrianMenuPreference<ID>.self) { $0 = [] }
  }
}

private struct BrianMenuAnchor<ID: Hashable>: ViewModifier {
  @Environment(\.isEnabled) private var isEnabled
  let id: ID

  func body(content: Content) -> some View {
    content.anchorPreference(key: BrianMenuPreference<ID>.self, value: .bounds) { bounds in
      [BrianMenuAnchorValue(id: id, bounds: bounds, isEnabled: isEnabled)]
    }
  }
}

private struct BrianMenuAnchorValue<ID: Hashable> {
  let id: ID
  let bounds: Anchor<CGRect>
  let isEnabled: Bool
}

private struct BrianMenuPreference<ID: Hashable>: PreferenceKey {
  static var defaultValue: [BrianMenuAnchorValue<ID>] { [] }

  static func reduce(
    value: inout [BrianMenuAnchorValue<ID>], nextValue: () -> [BrianMenuAnchorValue<ID>]
  ) {
    value.append(contentsOf: nextValue())
  }
}
