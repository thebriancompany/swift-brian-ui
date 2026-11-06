import SwiftUI

extension View {
  func brianDatePickerPopup<Content: View>(
    isPresented: Binding<Bool>, width: CGFloat,
    @ViewBuilder content: () -> Content
  ) -> some View {
    background(
      BrianDatePickerWindowAnchor(
        isPresented: isPresented, width: width, popup: content()
      ))
  }
}

@MainActor
struct BrianDatePickerWindowAnchor<Content: View> {
  @Environment(\.self) var environment
  @Binding var isPresented: Bool
  let width: CGFloat
  let popup: Content

  func overlay(anchor: CGRect, bounds: CGRect) -> BrianDatePickerPopupContent<Content> {
    BrianDatePickerPopupContent(
      anchor: anchor, bounds: bounds, width: width, environment: environment,
      content: popup, dismiss: { isPresented = false }
    )
  }
}
