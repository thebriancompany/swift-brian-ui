import SwiftUI

extension ColorToken {
  public struct State: Hashable, Sendable {
    public var normal: Color
    public var pressed: Color
    public var focused: Color
    public var disabled: Color

    public init(
      normal: Color,
      pressed: Color,
      focused: Color,
      disabled: Color
    ) {
      self.normal = normal
      self.pressed = pressed
      self.focused = focused
      self.disabled = disabled
    }
  }
}
