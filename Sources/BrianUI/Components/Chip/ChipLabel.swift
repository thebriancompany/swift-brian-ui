import BrianSymbols
import SwiftUI

/// Lays out a chip's single-line text and optional leading and trailing decorations.
public struct BrianChipLabel: View {
  @Environment(\.theme) private var theme
  @Environment(\.chipProperty) private var property

  private let title: String
  private let prefix: Prefix?
  private let suffixImageStyle: Image.Style?

  /// A decoration displayed before the text.
  public enum Prefix {
    /// A BrianSymbols or SF Symbols icon.
    case icon(Image.Style)

    /// Specifies an SF Symbols icon using a legacy string name.
    public static func icon(_ systemName: String) -> Self {
      .icon(.system(systemName))
    }

    /// An avatar clipped to a circle.
    case avatar(Image)
    /// An image clipped to a rounded rectangle.
    case image(Image)
  }

  /// Specifies text, an optional leading decoration, and a trailing SF Symbols icon.
  public init(
    _ title: String,
    prefix: Prefix? = nil,
    suffixSystemImage: String? = nil
  ) {
    self.title = title
    self.prefix = prefix
    self.suffixImageStyle = .init(systemName: suffixSystemImage)
  }

  /// Specifies text, an optional leading decoration, and a trailing BrianSymbols icon.
  ///
  /// Hides the trailing icon when `suffixSymbol` is `nil`.
  public init(
    _ title: String,
    prefix: Prefix? = nil,
    suffixSymbol: BrianSymbol?
  ) {
    self.title = title
    self.prefix = prefix
    self.suffixImageStyle = .init(symbol: suffixSymbol)
  }

  public var body: some View {
    HStack(spacing: .zero) {
      prefixContent

      Text(title)
        .lineLimit(1)
        .truncationMode(.tail)
        .padding(.horizontal, theme.spacing.medium / 2)

      if let suffixImageStyle {
        Image(style: suffixImageStyle)
          .font(.system(size: property.size.suffixIconSize, weight: .medium))
          .frame(width: property.size.suffixIconSize, height: property.size.suffixIconSize)
          .padding(.trailing, theme.spacing.medium / 2)
      }
    }
  }

  @ViewBuilder
  private var prefixContent: some View {
    switch prefix {
    case let .icon(style):
      Image(style: style)
        .font(.system(size: property.size.iconSize, weight: .medium))
        .frame(width: property.size.iconSize, height: property.size.iconSize)
        .padding(.leading, theme.spacing.medium / 2)

    case let .avatar(image):
      image
        .resizable()
        .scaledToFill()
        .frame(width: property.size.imageSize, height: property.size.imageSize)
        .clipShape(.circle)

    case let .image(image):
      image
        .resizable()
        .scaledToFill()
        .frame(width: property.size.imageSize, height: property.size.imageSize)
        .clipShape(.rect(cornerRadius: theme.radius.xSmall))

    case nil:
      EmptyView()
    }
  }
}
