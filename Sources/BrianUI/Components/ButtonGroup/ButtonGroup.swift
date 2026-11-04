import SwiftUI

/// A button group that adapts its layout to the size of its content.
///
/// Arranges horizontally when both buttons' ideal widths fit the available width, otherwise vertically.
/// Horizontal order is secondary → primary; vertical order is primary → secondary.
///
/// When adding buttons, give their content an infinite maximum width to fill the available space.
///
/// ```swift
/// BrianButtonGroup {
///   Button {
///
///   } label: {
///     Text("Primary Solid")
///       .frame(maxWidth: .infinity)
///   }
///   .buttonStyle(.solid)
/// } secondary: {
///   Button {
///
///   } label: {
///     Text("Secondary Outline")
///       .frame(maxWidth: .infinity)
///   }
///   .buttonStyle(.outline)
/// }
/// ```
public struct BrianButtonGroup<Primary: View, Secondary: View>: View {
  @Environment(\.theme) private var theme
  private let primary: Primary
  private let secondary: Secondary

  public init(
    @ViewBuilder primary: () -> Primary,
    @ViewBuilder secondary: () -> Secondary
  ) {
    self.primary = primary()
    self.secondary = secondary()
  }

  public var body: some View {
    BrianButtonGroupLayout(
      spacing: theme.spacing.medium
    ) {
      primary
        .frame(maxWidth: .infinity)

      secondary
        .frame(maxWidth: .infinity)
    }
  }
}
