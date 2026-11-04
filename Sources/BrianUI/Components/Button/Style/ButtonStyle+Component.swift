import SwiftUI

extension ButtonStyle where Self == BrianGhostButtonStyle {
  /// A button style with reduced background emphasis for SwiftUI `Button`.
  ///
  /// Use `.buttonStyle(.ghost)` and adjust with `buttonSize(_:)` and `buttonTone(_:)`.
  /// Adding `buttonGradient(_:)` shows a subtle gradient only while pressed.
  public static var ghost: BrianGhostButtonStyle {
    .init()
  }
}

extension ButtonStyle where Self == BrianOutlineButtonStyle {
  /// A bordered button style for SwiftUI `Button`.
  ///
  /// Use `.buttonStyle(.outline)` and adjust with `buttonSize(_:)` and `buttonTone(_:)`.
  /// Adding `buttonGradient(_:)` uses a gradient border.
  public static var outline: BrianOutlineButtonStyle {
    .init()
  }
}

extension ButtonStyle where Self == BrianSolidButtonStyle {
  /// A filled button style that emphasizes SwiftUI `Button`.
  ///
  /// Use `.buttonStyle(.solid)` and adjust with `buttonSize(_:)` and `buttonTone(_:)`.
  /// Adding `buttonGradient(_:)` uses a vivid gradient background.
  public static var solid: BrianSolidButtonStyle {
    .init()
  }
}

extension ButtonStyle where Self == BrianWeakButtonStyle {
  /// A subtle background button style for SwiftUI `Button`.
  ///
  /// Use `.buttonStyle(.weak)` and adjust with `buttonSize(_:)` and `buttonTone(_:)`.
  /// Adding `buttonGradient(_:)` uses a subtle gradient background.
  public static var weak: BrianWeakButtonStyle {
    .init()
  }
}
