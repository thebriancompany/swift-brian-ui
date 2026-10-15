import SwiftUI

extension TypographyToken {
  public struct Label: Hashable, Sendable {
    public var large: Typography
    public var medium: Typography
    public var small: Typography

    public init(
      large: Typography,
      medium: Typography,
      small: Typography
    ) {
      self.large = large
      self.medium = medium
      self.small = small
    }
  }
}
