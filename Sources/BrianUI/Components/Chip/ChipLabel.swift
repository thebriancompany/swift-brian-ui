import SwiftUI

/// 칩의 한 줄 텍스트와 선택적인 앞뒤 장식을 배치합니다.
public struct BrianChipLabel: View {
  @Environment(\.theme) private var theme
  @Environment(\.chipProperty) private var property

  private let title: String
  private let prefix: Prefix?
  private let suffixSystemImage: String?

  /// 텍스트 앞에 표시할 장식입니다.
  public enum Prefix {
    /// SF Symbols 아이콘입니다.
    case icon(String)
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
    self.suffixSystemImage = suffixSystemImage
  }

  public var body: some View {
    HStack(spacing: .zero) {
      prefixContent

      Text(title)
        .lineLimit(1)
        .truncationMode(.tail)
        .padding(.horizontal, theme.spacing.medium / 2)

      if let suffixSystemImage {
        Image(systemName: suffixSystemImage)
          .font(.system(size: property.size.suffixIconSize, weight: .medium))
          .frame(width: property.size.suffixIconSize, height: property.size.suffixIconSize)
          .padding(.trailing, theme.spacing.medium / 2)
      }
    }
  }

  @ViewBuilder
  private var prefixContent: some View {
    switch prefix {
    case let .icon(systemImage):
      Image(systemName: systemImage)
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
