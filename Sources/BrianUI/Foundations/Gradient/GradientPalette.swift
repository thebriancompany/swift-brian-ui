import SwiftUI

/// Four background colors and a content color for an expressive gradient.
///
/// Use separately from semantic status colors. Configure custom palettes so `foreground`
/// remains readable over every background color, and check both light and dark modes.
/// Color opacity is not adjusted. Check translucent colors for contrast over their actual surface.
public struct GradientPalette: Hashable, Sendable {
  /// The color starting at the top left.
  public var start: Color
  /// The color connecting the top and bottom left, also used as a solid background with increased contrast.
  public var middle: Color
  /// The color extending toward the bottom right.
  public var end: Color
  /// The color softly spreading through the center.
  public var highlight: Color
  /// The content color used over a vivid gradient background.
  public var foreground: Color

  /// Specifies background colors and the content color displayed over them together.
  public init(
    start: Color,
    middle: Color,
    end: Color,
    highlight: Color,
    foreground: Color
  ) {
    self.start = start
    self.middle = middle
    self.end = end
    self.highlight = highlight
    self.foreground = foreground
  }

  /// A diagonal linear gradient for icons or decorative borders.
  ///
  /// Do not use as the sole color for body text or status indicators. The caller checks background contrast.
  public var linearGradient: LinearGradient {
    LinearGradient(
      colors: [start, middle, end],
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    )
  }
}
