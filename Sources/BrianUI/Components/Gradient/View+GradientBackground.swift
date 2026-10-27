import SwiftUI

extension View {
  /// 그라디언트 배경과 해당 배경에 맞는 기본 콘텐츠 색상을 함께 적용합니다.
  ///
  /// `.subtle`은 테마의 기본 전경색, `.vivid`는 팔레트의 `foreground`를 사용합니다.
  /// 하위 뷰가 명시한 전경색과 버튼 스타일은 해당 뷰의 설정을 따릅니다.
  /// 패딩과 모서리는 추가하지 않습니다. 필요한 패딩 뒤에 적용하고 `clipShape`로 마무리하세요.
  ///
  /// - Parameters:
  ///   - style: 테마에서 선택할 팔레트입니다. 기본값은 `.aurora`입니다.
  ///   - strength: 배경 강도입니다. 기본값은 `.subtle`입니다.
  /// - Returns: 배경과 기본 콘텐츠 색상이 설정된 뷰입니다.
  public func gradientBackground(
    _ style: GradientToken.Style = .aurora,
    strength: BrianGradient.Strength = .subtle
  ) -> some View {
    modifier(GradientBackgroundModifier(style: style, strength: strength))
  }
}

private struct GradientBackgroundModifier: ViewModifier {
  @Environment(\.theme) private var theme

  let style: GradientToken.Style
  let strength: BrianGradient.Strength

  func body(content: Content) -> some View {
    content
      .foregroundStyle(
        strength == .subtle ? theme.color.foreground.primary : theme.gradient[style].foreground
      )
      .background {
        BrianGradient(style, strength: strength)
      }
  }
}
