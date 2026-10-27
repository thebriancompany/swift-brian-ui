import SwiftUI

/// 테마의 네 가지 색상을 곡선으로 혼합하는 정적인 메쉬 그라디언트 배경입니다.
///
/// 제안된 크기를 채우며 레이아웃 크기와 모서리 모양은 호출자가 정합니다.
/// 장식용이므로 터치와 접근성 탐색에 참여하지 않습니다. 콘텐츠 색상까지 함께
/// 적용하려면 `gradientBackground(_:strength:)` 수정자를 사용하세요.
///
/// 기본 테마와 팔레트의 바탕은 불투명합니다. 커스텀 색상의 불투명도는 보정하지 않습니다.
/// 시스템의 대비 증가 설정에서는 단색으로 표시합니다. 애니메이션과 외부 이미지를 사용하지 않습니다.
public struct BrianGradient: View {
  @Environment(\.theme) private var theme
  @Environment(\.colorSchemeContrast) private var contrast

  private let style: GradientToken.Style
  private let strength: Strength

  // 바탕의 밝기를 유지하면서 팔레트의 색조를 은은하게 더합니다.
  private static let subtleBlendOpacity = 0.18

  /// 테마에서 팔레트와 표현 강도를 선택합니다.
  ///
  /// - Parameters:
  ///   - style: 팔레트 이름입니다. 기본값은 `.aurora`입니다.
  ///   - strength: `.subtle`은 카드용 은은한 배경, `.vivid`는 선명한 커버 배경입니다.
  public init(_ style: GradientToken.Style = .aurora, strength: Strength = .subtle) {
    self.style = style
    self.strength = strength
  }

  public var body: some View {
    ZStack {
      base

      if contrast != .increased {
        MeshGradient(
          width: 3,
          height: 3,
          points: [
            [0, 0], [0.5, 0], [1, 0],
            [0, 0.5], [0.42, 0.58], [1, 0.5],
            [0, 1], [0.5, 1], [1, 1]
          ],
          colors: [
            palette.start, palette.start, palette.middle,
            palette.start, palette.highlight, palette.end,
            palette.middle, palette.end, palette.end
          ],
          smoothsColors: true
        )
        .opacity(strength == .subtle ? Self.subtleBlendOpacity : 1)
      }
    }
    .allowsHitTesting(false)
    .accessibilityHidden(true)
  }

  private var palette: GradientPalette { theme.gradient[style] }

  private var base: Color {
    strength == .subtle ? theme.color.background.elevated : palette.middle
  }
}

extension BrianGradient {
  /// 그라디언트 배경의 표현 강도입니다.
  public enum Strength: CaseIterable, Hashable, Sendable {
    /// 테마의 elevated 배경 위에 그라디언트를 18%로 혼합합니다.
    case subtle
    /// 팔레트의 색상을 그대로 사용합니다.
    case vivid
  }
}
