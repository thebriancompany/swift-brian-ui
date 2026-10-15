import Foundation

extension BrianSwitchProperty {
  public enum Size: CaseIterable, Hashable, Sendable {
    /// 기본값 16
    case small
    /// 기본값 24
    case medium
    /// 기본값 32
    case large
  }
}

extension BrianSwitchProperty.Size {
  func height(_ token: SpacingToken) -> CGFloat {
    switch self {
    case .small: token.large
    case .medium: token.xLarge
    case .large: token.xxLarge
    }
  }

  func width(_ token: SpacingToken) -> CGFloat {
    switch self {
    case .small: height(token) * 26 / 16
    case .medium: height(token) * 38 / 24
    case .large: height(token) * 52 / 32
    }
  }

  func inset(_ token: SpacingToken) -> CGFloat {
    switch self {
    case .small: height(token) * 2 / 16
    case .medium: height(token) * 2 / 24
    case .large: height(token) * 3 / 32
    }
  }

  func minimumHeight(_ token: SpacingToken) -> CGFloat {
    max(height(token), token.xLarge)
  }

  func spacing(_ token: SpacingToken) -> CGFloat {
    switch self {
    case .small: token.medium / 2
    case .medium: token.small
    case .large: (token.small + token.medium) / 2
    }
  }

  func typography(_ token: TypographyToken) -> Typography {
    switch self {
    case .small: token.body.small
    case .medium: token.body.medium
    case .large: token.body.large
    }
  }
}
