import SwiftUI

extension View {
  public func menuAnchor<ID: Hashable>(id: ID) -> some View {
    modifier(BrianMenuAnchor(id: id))
  }

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
