import SwiftUI

extension View {
  /// Provides the available presentation area for compact BrianDatePicker controls.
  /// Apply to an ancestor screen container outside scroll views, as with `menuScope`.
  /// Only compact pickers need this scope. Nested scopes handle their own descendant pickers.
  /// The popup inherits the originating picker's environment and closes when that picker is disabled.
  /// Tapping outside closes the popup without reverting selection changes.
  /// See <doc:Forms> for a complete example.
  ///
  /// - Returns: A view hosting compact DatePicker popups within its bounds.
  public func datePickerScope() -> some View {
    overlayPreferenceValue(BrianDatePickerPopupPreference.self) { popups in
      GeometryReader { proxy in
        if let popup = popups.last {
          BrianDatePickerPopupOverlay(
            popup: popup,
            anchor: proxy[popup.anchor],
            bounds: CGRect(origin: .zero, size: proxy.size)
          )
          .id(popup.id)
          .transition(.identity)
        }
      }
    }
    .transformPreference(BrianDatePickerPopupPreference.self) { $0 = [] }
  }

  func brianDatePickerPopup<Content: View>(
    isPresented: Binding<Bool>, width: CGFloat,
    @ViewBuilder content: () -> Content
  ) -> some View {
    modifier(BrianDatePickerPopupModifier(
      isPresented: isPresented, width: width, popupContent: content()
    ))
  }
}

private struct BrianDatePickerPopupModifier<PopupContent: View>: ViewModifier {
  @Environment(\.self) private var environment
  @State private var id = UUID()
  @Binding var isPresented: Bool
  let width: CGFloat
  let popupContent: PopupContent

  func body(content: Content) -> some View {
    content.anchorPreference(key: BrianDatePickerPopupPreference.self, value: .bounds) {
      isPresented && environment.isEnabled ? [BrianDatePickerPopup(
        id: id, anchor: $0, width: width,
        environment: environment, content: AnyView(popupContent), dismiss: { isPresented = false }
      )] : []
    }
    .onChange(of: environment.isEnabled) { _, isEnabled in
      if !isEnabled { isPresented = false }
    }
  }
}

private struct BrianDatePickerPopup {
  let id: UUID
  let anchor: Anchor<CGRect>
  let width: CGFloat
  let environment: EnvironmentValues
  let content: AnyView
  let dismiss: () -> Void
}

private struct BrianDatePickerPopupPreference: PreferenceKey {
  static var defaultValue: [BrianDatePickerPopup] { [] }
  static func reduce(value: inout [BrianDatePickerPopup], nextValue: () -> [BrianDatePickerPopup]) {
    value.append(contentsOf: nextValue())
  }
}

private struct BrianDatePickerPopupOverlay: View {
  let popup: BrianDatePickerPopup
  let bounds: CGRect
  @State private var openingAnchor: CGRect

  init(popup: BrianDatePickerPopup, anchor: CGRect, bounds: CGRect) {
    self.popup = popup
    self.bounds = bounds
    _openingAnchor = State(initialValue: anchor)
  }

  var body: some View {
    BrianMenuOverlay(
      anchor: openingAnchor, bounds: bounds, dismiss: popup.dismiss,
      content: popup.content, preferredWidth: popup.width, animatesPresentation: true
    )
    .environment(\.self, popup.environment)
    .onDisappear(perform: popup.dismiss)
  }
}
