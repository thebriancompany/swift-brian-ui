import SwiftUI

extension ButtonStyle where Self == BrianButtonStyle {
  /// Applies a themed appearance and shape; size, tone, and gradient use environment modifiers.
  public static func brian(
    _ appearance: BrianButtonStyle.Appearance,
    shape: BrianButtonStyle.Shape = .rounded
  ) -> BrianButtonStyle {
    .init(appearance, shape: shape)
  }
}

extension ButtonStyle where Self == BrianPressButtonStyle {
  /// Adds scale feedback without changing the label's layout or styling.
  public static var press: BrianPressButtonStyle {
    .init()
  }

  /// Adds the chosen press feedback without changing the label's layout or styling.
  public static func press(_ effect: BrianPressButtonStyle.Effect) -> BrianPressButtonStyle {
    .init(effect)
  }
}
