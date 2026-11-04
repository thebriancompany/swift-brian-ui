import SwiftUI

extension View {
  /// Applies a fog effect to the specified content edges.
  ///
  /// Covers edges with a gradient of the theme's base background color. Does not apply a blur filter.
  ///
  /// `fraction` specifies the proportion covered by the fog effect at each selected edge.
  /// For example, a `fraction` of `0.2` applies the effect over 20% of the total height
  /// starting from the selected edge.
  ///
  /// With `.both`, the effect covers 20% at the top and 20% at the bottom.
  ///
  /// ```swift
  /// ScrollView {
  ///   ContentView()
  /// }
  /// .contentFog(.bottom, fraction: 0.2)
  /// ```
  ///
  /// - Parameters:
  ///   - variant: The edges receiving the effect. Defaults to ``BrianContentFogVariant/bottom``.
  ///   - fraction: The proportion covered by the fog effect at each selected edge.
  ///     Defaults to `0.2`, meaning 20% of the total height from each edge.
  ///     Typically a finite value in `0...1`; the implementation does not clamp the range automatically.
  ///
  /// - Returns: A view with a fog effect on the specified edges.
  public func contentFog(
    _ variant: BrianContentFogVariant = .bottom,
    fraction: CGFloat = 0.2
  ) -> some View {
    modifier(BrianContentFogModifier(variant: variant, height: .fraction(fraction)))
  }

  public func contentFog(
    _ variant: BrianContentFogVariant = .bottom,
    height: CGFloat
  ) -> some View {
    modifier(BrianContentFogModifier(variant: variant, height: .fixed(height)))
  }
}

/// The edges where fog is placed over content.
public enum BrianContentFogVariant: CaseIterable, Hashable, Sendable {
  /// Applies to the top edge.
  case top
  /// Applies to the bottom edge.
  case bottom
  /// Applies to both the top and bottom edges.
  case both
}

public enum BrianContentFogHeight: Hashable, Sendable {
  case fixed(CGFloat)
  case fraction(CGFloat)
}

private struct BrianContentFogModifier: ViewModifier {
  @Environment(\.theme) private var theme

  private let variant: BrianContentFogVariant
  private let height: BrianContentFogHeight

  public init(
    variant: BrianContentFogVariant,
    height: BrianContentFogHeight
  ) {
    self.variant = variant
    self.height = height
  }

  func body(content: Content) -> some View {
    content
      .overlay {
        GeometryReader { proxy in
          VStack(spacing: .zero) {
            if variant != .bottom {
              BrianContentFog(direction: .down)
                .frame(height: height(proxy.size.height))
            }

            Spacer()

            if variant != .top {
              BrianContentFog(direction: .up)
                .frame(height: height(proxy.size.height))
            }
          }
        }
      }
  }

  private func height(_ proxyHeight: CGFloat) -> CGFloat {
    switch height {
    case let .fixed(height): height
    case let .fraction(fraction): proxyHeight * fraction
    }
  }
}
