import SwiftUI

@MainActor
@resultBuilder
public struct BrianAlertFooter {
  public static func buildBlock<Primary: View>(_ primary: Primary) -> some View {
    primary
      .buttonStyle(.solid)
      .buttonSize(.large)
  }

  public static func buildBlock<Primary: View, Secondary: View>(
    _ primary: Primary,
    _ secondary: Secondary
  ) -> some View {
    BrianButtonGroup {
      primary
        .buttonStyle(.solid)
        .buttonSize(.large)
    } secondary: {
      secondary
        .buttonStyle(.weak)
        .buttonSize(.large)
    }
  }
}
