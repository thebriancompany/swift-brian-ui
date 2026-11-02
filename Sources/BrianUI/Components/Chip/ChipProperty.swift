import SwiftUI

/// 칩의 크기, 선택 상태 표현 방식과 콘텐츠 배치입니다.
public struct BrianChipProperty: Hashable, Sendable {
  /// 칩의 최소 높이와 아이콘 크기입니다.
  public var size: Size
  /// 선택 여부에 따른 배경과 테두리 표현입니다.
  public var variant: Variant
  /// 텍스트 포함 여부에 따른 최소 너비입니다.
  public var layout: Layout

  /// 기본값은 `.medium`, `.solid`, `.withText`입니다.
  public init(
    size: Size = .medium,
    variant: Variant = .solid,
    layout: Layout = .withText
  ) {
    self.size = size
    self.variant = variant
    self.layout = layout
  }
}

extension BrianChipProperty {
  /// 칩의 크기입니다. 큰 글꼴에서는 콘텐츠에 맞춰 높이가 늘어납니다.
  public enum Size: CaseIterable, Hashable, Sendable {
    /// 최소 높이 32pt입니다.
    case small
    /// 최소 높이 36pt입니다.
    case medium
    /// 최소 높이 40pt입니다.
    case large
  }

  /// 칩의 선택 상태를 구분하는 스타일입니다.
  public enum Variant: CaseIterable, Hashable, Sendable {
    /// 옅은 배경을 사용하며, 선택하면 진한 배경으로 전환합니다.
    case solid
    /// 테두리를 사용하며, 선택하면 진한 배경으로 전환합니다.
    case outlineStrong
    /// 테두리를 사용하며, 선택하면 옅은 배경과 진한 테두리로 강조합니다.
    case outlineWeak
  }

  /// 칩 콘텐츠에 맞춘 배치입니다.
  public enum Layout: CaseIterable, Hashable, Sendable {
    /// 텍스트와 선택적인 앞뒤 콘텐츠를 표시합니다.
    case withText
    /// 아이콘 하나를 표시합니다.
    case iconOnly
  }
}

extension BrianChipProperty.Size {
  var minimumHeight: CGFloat {
    switch self {
    case .small: 32
    case .medium: 36
    case .large: 40
    }
  }

  var minimumTextWidth: CGFloat {
    minimumHeight + 12
  }

  var iconSize: CGFloat {
    switch self {
    case .small: 14
    case .medium, .large: 16
    }
  }

  var suffixIconSize: CGFloat {
    switch self {
    case .small, .medium: 14
    case .large: 16
    }
  }

  var imageSize: CGFloat {
    switch self {
    case .small: 20
    case .medium: 24
    case .large: 28
    }
  }

  func horizontalPadding(_ spacing: SpacingToken) -> CGFloat {
    switch self {
    case .small: spacing.medium / 2
    case .medium: spacing.small
    case .large: (spacing.small + spacing.medium) / 2
    }
  }
}
