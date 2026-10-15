import SwiftUI

public struct BrianSwitchmark: View {
  @Environment(\.theme) private var theme
  @Environment(\.switchProperty) private var property
  @Environment(\.switchIsPressed) private var isPressed
  @Environment(\.isEnabled) private var isEnabled
  @Environment(\.layoutDirection) private var layoutDirection

  private let isOn: Bool

  public init(_ isOn: Bool = false) {
    self.isOn = isOn
  }

  public var body: some View {
    Circle()
      .fill(thumbColor)
      .frame(width: thumbSize, height: thumbSize)
      .scaleEffect(isOn ? 1 : 0.8)
      .offset(x: thumbOffset)
      .frame(width: size.width(theme.spacing), height: size.height(theme.spacing))
      .background(trackColor, in: .capsule)
      .scaleEffect(isEnabled && isPressed ? 0.9 : 1)
      .animation(.easeInOut(duration: 0.2), value: isOn)
      .animation(.easeInOut(duration: 0.15), value: isEnabled)
      .animation(
        .interactiveSpring(
          response: 0.22,
          dampingFraction: 0.75,
          blendDuration: 0.1
        ),
        value: isPressed
      )
  }

  private var size: BrianSwitchProperty.Size {
    property.size
  }

  private var inset: CGFloat {
    size.inset(theme.spacing)
  }

  private var thumbSize: CGFloat {
    size.height(theme.spacing) - inset * 2
  }

  private var thumbOffset: CGFloat {
    let travel = (size.width(theme.spacing) - size.height(theme.spacing)) / 2
    let direction: CGFloat = layoutDirection == .leftToRight ? 1 : -1
    return (isOn ? travel : -travel) * direction
  }

  private var trackColor: Color {
    let colors: ColorToken.State
    if isOn {
      colors = switch property.tone {
      case .neutral: theme.color.background.neutral.solid
      case .brand: theme.color.background.brand.solid
      }
    } else {
      colors = theme.color.background.neutral.weak
    }
    guard isEnabled else {
      return colors.disabled
    }
    return isPressed ? colors.pressed : colors.normal
  }

  private var thumbColor: Color {
    guard isEnabled else {
      return theme.color.foreground.disabled
    }
    switch property.tone {
    case .neutral: return theme.color.foreground.inverse
    case .brand: return theme.color.foreground.brand.solid
    }
  }
}
