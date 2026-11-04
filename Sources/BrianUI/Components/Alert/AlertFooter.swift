import SwiftUI

/// A result builder that lays out one or two alert action views.
///
/// Applies `.solid` to the first view and `.weak` to the second.
/// When there are two views, arranges them with ``BrianButtonGroup``. All use `.large` size.
/// Does not provide builder methods for three or more direct actions or conditional branches.
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
