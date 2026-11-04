import SwiftUI

/// A chip's size, selection appearance, and content layout.
public struct BrianChipProperty: Hashable, Sendable {
  /// The chip's minimum height and icon size.
  public var size: Size
  /// Background and border appearance based on selection.
  public var variant: Variant
  /// The minimum width based on whether text is included.
  public var layout: Layout

  /// Defaults to `.medium`, `.solid`, and `.withText`.
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
  /// The chip size. With large fonts, height grows to fit the content.
  public enum Size: CaseIterable, Hashable, Sendable {
    /// A minimum height of 32 pt.
    case small
    /// A minimum height of 36 pt.
    case medium
    /// A minimum height of 40 pt.
    case large
  }

  /// A style that distinguishes a chip's selection state.
  public enum Variant: CaseIterable, Hashable, Sendable {
    /// Uses a subtle background, switching to a strong background when selected.
    case solid
    /// Uses a border, switching to a strong background when selected.
    case outlineStrong
    /// Uses a border, adding a subtle background and strong border when selected.
    case outlineWeak
  }

  /// A layout suited to the chip's content.
  public enum Layout: CaseIterable, Hashable, Sendable {
    /// Displays text and optional leading and trailing content.
    case withText
    /// Displays a single icon.
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
