import Foundation

/// BrianUI 컴포넌트가 공유하는 색상, 모서리, 간격, 글꼴 및 그림자 토큰입니다.
///
/// 별도 설정 없이 기본 테마를 사용합니다. 하위 뷰의 테마를 변경하려면
/// `.environment(\.theme, theme)`을 적용합니다.
///
/// ```swift
/// ContentView()
///   .environment(\.theme, BrianTheme())
/// ```
///
/// 사용 예제는 <doc:Theming>을 참고하세요.
public struct BrianTheme: Hashable, Sendable {
  /// 의미별 색상 토큰입니다.
  public var color: ColorToken
  /// 모서리 반경 토큰입니다.
  public var radius: RadiusToken
  /// 레이아웃 간격 토큰입니다.
  public var spacing: SpacingToken
  /// 텍스트 역할별 글꼴 토큰입니다.
  public var typography: TypographyToken
  /// 그림자 토큰입니다.
  public var shadow: ShadowToken

  /// 각 토큰을 직접 지정하는 테마를 만듭니다.
  ///
  /// - Parameters:
  ///   - color: 사용할 의미별 색상 토큰입니다.
  ///   - radius: 모서리 반경입니다. 기본값은 `.default`입니다.
  ///   - spacing: 간격입니다. 기본값은 `.default`입니다.
  ///   - typography: 글꼴입니다. 기본값은 `.default`입니다.
  ///   - shadow: 그림자입니다. 기본값은 `.default`입니다.
  public init(
    color: ColorToken,
    radius: RadiusToken = .default,
    spacing: SpacingToken = .default,
    typography: TypographyToken = .default,
    shadow: ShadowToken = .default
  ) {
    self.color = color
    self.radius = radius
    self.spacing = spacing
    self.typography = typography
    self.shadow = shadow
  }

  /// 팔레트로부터 의미별 색상 토큰을 구성하는 테마를 만듭니다.
  ///
  /// - Parameters:
  ///   - palette: 색상 팔레트입니다. 기본 팔레트를 생략할 수 있습니다.
  ///   - brand: 브랜드 색상 스케일입니다. `nil`이면 팔레트의 기본 브랜드 구성을 사용합니다.
  ///   - shadow: 그림자 토큰입니다. 기본값은 `.default`입니다.
  public init(
    palette: ColorPalette = .default,
    brand: ColorPalette.Scale? = nil,
    shadow: ShadowToken = .default
  ) {
    self.init(
      color: ColorToken(palette: palette, brand: brand),
      radius: .default,
      spacing: .default,
      typography: .default,
      shadow: shadow
    )
  }
}
