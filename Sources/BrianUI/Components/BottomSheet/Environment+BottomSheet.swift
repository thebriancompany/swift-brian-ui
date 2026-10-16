import SwiftUI

extension EnvironmentValues {
  @Entry var bottomSheetHeaderAlignment: HorizontalAlignment = .leading
  @Entry var bottomSheetShowsHandle = true
  @Entry var bottomSheetShowsCloseButton = false
  @Entry var bottomSheetIsPresented: Binding<Bool>? = nil
}

extension View {
  public func bottomSheetHeaderAlignment(_ alignment: HorizontalAlignment) -> some View {
    environment(\.bottomSheetHeaderAlignment, alignment)
  }

  public func bottomSheetShowsHandle(_ showsHandle: Bool) -> some View {
    environment(\.bottomSheetShowsHandle, showsHandle)
  }

  public func bottomSheetShowsCloseButton(_ showsCloseButton: Bool) -> some View {
    environment(\.bottomSheetShowsCloseButton, showsCloseButton)
  }
}
