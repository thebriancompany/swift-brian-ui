import SwiftUI

/// A gradient that softly reveals the top or bottom boundary of a content area.
///
/// Uses the theme's base background color.
///
/// Direction supports up and down values.
/// Up fades toward the top.
/// Down fades toward the bottom.
///
/// ```swift
/// Rectangle()
///   .fill(.pink)
///   .frame(height: 100)
///   .frame(maxWidth: .infinity)
///   .overlay(alignment: .top) {
///     BrianContentFog(direction: .down)
///       .frame(height: 40)
///   }
///   .overlay(alignment: .bottom) {
///     BrianContentFog(direction: .up)
///       .frame(height: 40)
///   }
/// ```
public struct BrianContentFog: View {
  public enum Direction: Hashable, Sendable {
    /// Fades from the background color at the bottom to transparent at the top.
    case up
    /// Fades from the background color at the top to transparent at the bottom.
    case down
  }

  @Environment(\.theme) private var theme

  private let direction: Direction
  private let color: Color?
  private var backgroundColor: Color {
    if let color {
      return color
    }
    return theme.color.background.base
  }

  public init(
    direction: Direction = .up,
    color: Color? = nil
  ) {
    self.direction = direction
    self.color = color
  }

  public var body: some View {
    LinearGradient(
      colors: colors,
      startPoint: .top,
      endPoint: .bottom
    )
    .allowsHitTesting(false)
  }

  private var colors: [Color] {
    switch direction {
    case .up:
      return [
        backgroundColor.opacity(0),
        backgroundColor,
      ]

    case .down:
      return [
        backgroundColor,
        backgroundColor.opacity(0),
      ]
    }
  }
}
