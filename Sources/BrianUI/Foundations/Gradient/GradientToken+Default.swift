import SwiftUI

extension GradientToken {
  /// 라이트 모드의 밝은 색과 다크 모드의 깊은 색을 함께 제공하는 기본 토큰입니다.
  ///
  /// 브랜드의 단색 팔레트와 독립적으로 구성됩니다. 브랜드에 맞게 바꾸려면
  /// `theme.gradient` 또는 개별 팔레트를 교체하세요.
  public static let `default` = Self(
    aurora: .init(
      start: .adaptive(light: 0x73DDFA, dark: 0x124D61),
      middle: .adaptive(light: 0x9CA8FA, dark: 0x26316B),
      end: .adaptive(light: 0xC1A1EF, dark: 0x493267),
      highlight: .adaptive(light: 0xF6B8DC, dark: 0x662B50),
      foreground: .adaptive(light: 0x1B1730, dark: 0xF7F4FF)
    ),
    sunset: .init(
      start: .adaptive(light: 0xFFB783, dark: 0x733A20),
      middle: .adaptive(light: 0xF29AAF, dark: 0x702C45),
      end: .adaptive(light: 0xC3ABF3, dark: 0x413064),
      highlight: .adaptive(light: 0xFFE5AD, dark: 0x645025),
      foreground: .adaptive(light: 0x1B1730, dark: 0xF7F4FF)
    ),
    lagoon: .init(
      start: .adaptive(light: 0x87E1C5, dark: 0x125243),
      middle: .adaptive(light: 0x86CBEC, dark: 0x17485D),
      end: .adaptive(light: 0xA6B2F4, dark: 0x313967),
      highlight: .adaptive(light: 0xD3E8B8, dark: 0x344C30),
      foreground: .adaptive(light: 0x1B1730, dark: 0xF7F4FF)
    )
  )
}
