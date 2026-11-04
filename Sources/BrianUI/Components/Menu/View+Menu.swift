import SwiftUI

extension View {
  /// Registers an identifier on the reference view used to position a menu.
  ///
  /// Does not add a tap action. The caller must change the selection connected to `menuScope(selection:content:)`.
  ///
  /// - Parameter id: An identifier distinguishing the reference view within the same menu scope.
  /// - Returns: A view with a registered menu anchor position.
  public func menuAnchor<ID: Hashable>(id: ID) -> some View {
    modifier(BrianMenuAnchor(id: id))
  }

  /// Presents a menu at the descendant anchor matching the selected identifier.
  ///
  /// The anchor and selection must use the same ID type, and the anchor must be a descendant of this scope.
  /// Displays nothing if the selection is `nil` or there is no matching active anchor.
  ///
  /// - Parameters:
  ///   - selection: The anchor identifier to present at. Becomes `nil` when the menu closes.
  ///   - content: A closure that builds menu content from the selected identifier.
  /// - Returns: A view containing the menu overlay.
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
