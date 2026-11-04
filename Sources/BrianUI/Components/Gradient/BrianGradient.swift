import SwiftUI

/// A static mesh gradient background that blends four theme colors along curves.
///
/// Fills the proposed size. The caller controls layout size and corner shape.
/// Decorative only; excluded from touch handling and accessibility navigation. To apply
/// a matching content color too, use the `gradientBackground(_:strength:)` modifier.
///
/// Default theme and palette bases are opaque. Custom color opacity is not adjusted.
/// Uses a solid color with increased contrast. Does not use animation or external images.
public struct BrianGradient: View {
  @Environment(\.theme) private var theme
  @Environment(\.colorSchemeContrast) private var contrast

  private let style: GradientToken.Style
  private let strength: Strength

  // Add subtle palette hues while preserving the base brightness.
  private static let subtleBlendOpacity = 0.18

  /// Selects a theme palette and intensity.
  ///
  /// - Parameters:
  ///   - style: The palette name. Defaults to `.aurora`.
  ///   - strength: `.subtle` is a soft card background; `.vivid` is a vivid cover background.
  public init(_ style: GradientToken.Style = .aurora, strength: Strength = .subtle) {
    self.style = style
    self.strength = strength
  }

  public var body: some View {
    ZStack {
      base

      if contrast != .increased {
        MeshGradient(
          width: 3,
          height: 3,
          points: [
            [0, 0], [0.5, 0], [1, 0],
            [0, 0.5], [0.42, 0.58], [1, 0.5],
            [0, 1], [0.5, 1], [1, 1]
          ],
          colors: [
            palette.start, palette.start, palette.middle,
            palette.start, palette.highlight, palette.end,
            palette.middle, palette.end, palette.end
          ],
          smoothsColors: true
        )
        .opacity(strength == .subtle ? Self.subtleBlendOpacity : 1)
      }
    }
    .allowsHitTesting(false)
    .accessibilityHidden(true)
  }

  private var palette: GradientPalette { theme.gradient[style] }

  private var base: Color {
    strength == .subtle ? theme.color.background.elevated : palette.middle
  }
}

extension BrianGradient {
  /// The intensity of a gradient background.
  public enum Strength: CaseIterable, Hashable, Sendable {
    /// Blends the gradient at 18% over the theme's elevated background.
    case subtle
    /// Uses the palette colors directly.
    case vivid
  }
}
