import BrianSymbols
import SwiftUI

/// 칩의 한 줄 텍스트와 선택적인 앞뒤 장식을 배치합니다.
public struct BrianChipLabel: View {
  @Environment(\.theme) private var theme
  @Environment(\.chipProperty) private var property

  private let title: String
  private let prefix: Prefix?
  private let suffixImageStyle: Image.Style?

  /// 텍스트 앞에 표시할 장식입니다.
  public enum Prefix {
    /// BrianSymbols 또는 SF Symbols 아이콘입니다.
    case icon(Image.Style)

    /// 기존 문자열 이름으로 SF Symbols 아이콘을 지정합니다.
    public static func icon(_ systemName: String) -> Self {
      .icon(.system(systemName))
    }

    /// 원형으로 자른 아바타입니다.
    case avatar(Image)
    /// 둥근 사각형으로 자른 이미지입니다.
    case image(Image)
  }

  /// 텍스트와 선택적인 앞쪽 장식, 뒤쪽 SF Symbols 아이콘을 지정합니다.
  public init(
    _ title: String,
    prefix: Prefix? = nil,
    suffixSystemImage: String? = nil
  ) {
    self.title = title
    self.prefix = prefix
    self.suffixImageStyle = .init(systemName: suffixSystemImage)
  }

  /// 텍스트와 선택적인 앞쪽 장식, 뒤쪽 BrianSymbols 아이콘을 지정합니다.
  ///
  /// `suffixSymbol`이 `nil`이면 뒤쪽 아이콘을 표시하지 않습니다.
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
