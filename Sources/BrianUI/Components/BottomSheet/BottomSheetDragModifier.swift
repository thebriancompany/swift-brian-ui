import SwiftUI

struct BrianBottomSheetDragModifier: ViewModifier {
  let isEnabled: Bool
  let onChanged: (CGFloat) -> Void
  let onEnded: (CGFloat?) -> Void

#if os(macOS)
  @GestureState private var isDragging = false
#endif

  func body(content: Content) -> some View {
#if os(iOS)
    content.gesture(
      BrianBottomSheetDragGesture(
        isEnabled: isEnabled,
        onChanged: onChanged,
        onEnded: onEnded
      )
    )
#else
    content
      .simultaneousGesture(
        DragGesture(coordinateSpace: .global)
          .updating($isDragging) { _, state, _ in state = true }
          .onChanged { value in
            guard isEnabled, abs(value.translation.height) > abs(value.translation.width) else {
              return
            }
            onChanged(value.translation.height)
          }
          .onEnded { value in
            guard isEnabled else { return }
            onEnded(
              abs(value.translation.height) > abs(value.translation.width)
              ? value.predictedEndTranslation.height : nil
            )
          },
        including: isEnabled ? .all : .subviews
      )
      .onChange(of: isDragging) { _, newValue in
        if !newValue { onEnded(nil) }
      }
#endif
  }
}
