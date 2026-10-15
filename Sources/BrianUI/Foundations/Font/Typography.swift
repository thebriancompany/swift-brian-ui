import SwiftUI

public struct Typography: Hashable, Sendable {
  public var font: Font

  public init(font: Font) {
    self.font = font
  }
}
