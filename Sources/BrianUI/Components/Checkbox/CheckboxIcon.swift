import SwiftUI

public struct BrianCheckboxIcon: View {
  @Environment(\.theme) private var theme
  @Environment(\.checkboxProperty) private var property
  @Environment(\.checkboxIsPressed) private var isPressed
  @Environment(\.isEnabled) private var isEnabled

  private let state: BrianCheckboxState

  public init(state: BrianCheckboxState = .unselected) {
    self.state = state
  }

  public var body: some View {
    FoundesignCheckmarkLayout {
      Text(" ")
        .typography(typography)
        .fontWeight(property.weight.fontWeight)
        .hidden()
    }
    .overlay {
      Image(systemName: state == .indeterminate ? "minus" : "checkmark")
        .typography(typography)
        .fontWeight(.bold)
        .imageScale(property.shape == .outlined ? .small : .medium)
        .foregroundStyle(foregroundColor)
        .opacity(showsIcon ? 1 : 0)
    }
    .background(backgroundColor, in: shape)
    .overlay {
      shape.strokeBorder(borderColor, lineWidth: 1)
    }
    .scaleEffect(isEnabled && isPressed ? 0.9 : 1)
    .animation(.easeInOut(duration: 0.15), value: state)
    .animation(pressAnimation, value: isPressed)
  }

  private var typography: Typography {
    property.size.typography(theme.typography)
  }

  private var shape: RoundedRectangle {
    .rect(cornerRadius: theme.radius.small)
  }

  private var showsIcon: Bool {
    state != .unselected || property.shape == .ghost
  }

  private var foregroundColor: Color {
    guard isEnabled else {
      return theme.color.foreground.disabled
    }

    switch property.shape {
    case .outlined:
      switch property.tone {
      case .neutral: return theme.color.foreground.inverse
      case .brand: return theme.color.foreground.brand.solid
      }

    case .ghost:
      guard state != .unselected else {
        return theme.color.foreground.placeholder
      }
      switch property.tone {
      case .neutral: return theme.color.foreground.primary
      case .brand: return theme.color.foreground.brand.normal
      }
    }
  }

  private var backgroundColor: Color {
    switch property.shape {
    case .outlined:
      guard isEnabled else {
        return theme.color.background.disabled
      }
      let colors = state == .unselected ? theme.color.background.transparent : backgroundRole.solid
      return isPressed ? colors.pressed : colors.normal

    case .ghost:
      guard isEnabled && isPressed else {
        return .clear
      }
      return state == .unselected
        ? theme.color.background.transparent.pressed : backgroundRole.weak.pressed
    }
  }

  private var backgroundRole: ColorToken.Background.Role {
    switch property.tone {
    case .neutral: theme.color.background.neutral
    case .brand: theme.color.background.brand
    }
  }

  private var borderColor: Color {
    guard property.shape == .outlined else {
      return .clear
    }
    guard isEnabled else {
      return theme.color.border.disabled
    }
    return state == .unselected ? theme.color.border.base : .clear
  }

  private var pressAnimation: Animation {
    .interactiveSpring(response: 0.22, dampingFraction: 0.75, blendDuration: 0.1)
  }
}

/// Typography의 한 줄 높이로 정사각형을 구성합니다.
private struct FoundesignCheckmarkLayout: Layout {
  func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
    let height = subviews.first?.sizeThatFits(.unspecified).height ?? .zero
    return CGSize(width: height, height: height)
  }

  func placeSubviews(
    in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()
  ) {
    subviews.first?.place(
      at: CGPoint(x: bounds.midX, y: bounds.midY),
      anchor: .center,
      proposal: .unspecified
    )
  }
}
