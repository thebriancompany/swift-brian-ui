import SwiftUI

/// 버튼과 배지가 공유하는 그라디언트 채움입니다.
struct ControlGradientFill: View {
  @Environment(\.theme) private var theme

  let style: GradientToken.Style
  let strength: BrianGradient.Strength
  let shape: RoundedRectangle
  var isPressed = false

  // 눌림을 표시하되 전경색과 배경의 대비가 과도하게 줄어들지 않도록 약하게 혼합합니다.
  private static let pressedOverlayOpacity = 0.04

  var body: some View {
    BrianGradient(style, strength: strength)
      .overlay {
        foreground.opacity(isPressed ? Self.pressedOverlayOpacity : 0)
      }
      .clipShape(shape)
      .allowsHitTesting(false)
      .accessibilityHidden(true)
  }

  private var foreground: Color {
    strength == .vivid ? theme.gradient[style].foreground : theme.color.foreground.primary
  }
}

/// 작은 컨트롤에서도 경계가 보이도록 전경색을 혼합하는 장식 테두리입니다.
struct ControlGradientBorder: View {
  @Environment(\.theme) private var theme
  @Environment(\.colorSchemeContrast) private var contrast

  let style: GradientToken.Style
  let shape: RoundedRectangle

  // 메쉬의 색조를 남기면서 얇은 테두리의 명암을 보강합니다.
  private static let borderContrastOpacity = 0.48

  var body: some View {
    Group {
      if contrast == .increased {
        shape.strokeBorder(theme.color.border.strong, lineWidth: 1)
      } else {
        BrianGradient(style, strength: .vivid)
          .overlay {
            theme.color.foreground.primary.opacity(Self.borderContrastOpacity)
          }
          .mask {
            shape.strokeBorder(lineWidth: 1)
          }
      }
    }
    .allowsHitTesting(false)
    .accessibilityHidden(true)
  }
}
