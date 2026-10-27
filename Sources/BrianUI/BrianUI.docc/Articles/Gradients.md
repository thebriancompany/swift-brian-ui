# 그라디언트와 다색 표현

부드럽게 섞이는 여러 색상을 히어로, 온보딩, 콘텐츠 커버, 추천 카드, 버튼과 배지에 적용합니다.

## 표현용 색상 선택

``BrianTheme/gradient``는 기본 UI의 의미별 색상과 별개인 표현용 토큰입니다.
성공·경고·오류는 기존 `theme.color`로 전달하고, 그라디언트는 콘텐츠의 분위기와 강조에 사용합니다.

| 팔레트 | 색 조합 | 사용 예 |
| --- | --- | --- |
| `aurora` | 시안 · 블루 · 라일락 · 핑크 | 아이디어, AI 보조 기능, 새로운 경험 |
| `sunset` | 피치 · 코랄 · 라벤더 | 영감, 에디토리얼, 따뜻한 환영 |
| `lagoon` | 민트 · 스카이 블루 · 그린 | 탐색, 집중, 차분한 소개 |

이는 사용 방향의 예시이며 기능별 의미를 강제하지 않습니다. 한 화면의 주요 그라디언트는
하나를 중심으로 선택하고, 입력 필드와 본문 영역에는 단색 표면을 함께 사용하세요.

## 배경과 텍스트를 함께 적용하기

`gradientBackground(_:strength:)`는 메쉬 배경과 그 위에 읽기 좋은 기본 전경색을 함께 설정합니다.
기본 강도인 `.subtle`은 테마의 elevated 배경 위에 색을 18%로 섞고,
`.vivid`는 선명한 팔레트를 그대로 사용합니다.

```swift
import BrianUI
import SwiftUI

struct GradientCardExample: View {
  @Environment(\.theme) private var theme

  var body: some View {
    VStack(alignment: .leading, spacing: theme.spacing.medium) {
      Label("새로운 아이디어", systemImage: "sparkles")
        .typography(theme.typography.title.medium)

      Text("여러 색이 부드럽게 섞이는 공간에서 영감을 발견하세요.")
        .typography(theme.typography.body.medium)
    }
    .padding(theme.spacing.xLarge)
    .frame(maxWidth: .infinity, alignment: .leading)
    .gradientBackground(.aurora, strength: .vivid)
    .clipShape(.rect(cornerRadius: theme.radius.xLarge))
  }
}
```

수정자는 패딩과 모서리를 자동으로 추가하지 않습니다. 패딩 뒤에 적용하고 마지막에 원하는
모양으로 자릅니다. 하위 뷰에서 지정한 `foregroundStyle`이나 버튼 스타일은 그대로 적용되므로,
별도 색상을 지정하는 경우 배경과의 대비를 확인하세요.

배경만 필요하면 ``BrianGradient``를 `.background { BrianGradient(.sunset) }`로 배치할 수 있습니다.
이 경우 콘텐츠 색상은 호출자가 설정합니다. 아이콘이나 장식 테두리에는
`theme.gradient.aurora.linearGradient`를 사용할 수 있습니다.

## 버튼과 배지에 선택적으로 적용하기

기존 버튼 스타일에 `buttonGradient(_:)`, 배지에는 `badgeGradient(_:)`를 추가합니다.
팔레트만 선택하면 표현 강도는 기존 스타일과 배지의 variant를 따릅니다.

| 스타일 / variant | 그라디언트 표현 |
| --- | --- |
| `solid` | 선명한 메쉬 채움과 팔레트의 전경색 |
| `weak` | 은은한 메쉬 채움과 테마의 기본 전경색 |
| `outline` | 명암을 보강한 메쉬 테두리와 테마의 기본 전경색 |
| 버튼 `ghost` | 평소에는 투명, 눌렀을 때 은은한 메쉬 채움 |

```swift
import BrianUI
import SwiftUI

struct GradientControlsExample: View {
  @State private var count = 0

  var body: some View {
    VStack(spacing: 16) {
      Button("아이디어 만들기 · \(count)", systemImage: "sparkles") {
        count += 1
      }
      .buttonStyle(.solid)
      .buttonGradient(.aurora)

      BrianBadge(title: "추천", systemImage: "sparkles")
        .badgeVariant(.weak)
        .badgeGradient(.sunset)
    }
  }
}
```

수정자는 하위 요소에 상속되며, 개별 요소에 `buttonGradient(nil)` 또는
`badgeGradient(nil)`을 적용하면 그 요소만 기본 단색 스타일을 사용합니다.
`BrianButtonProperty(gradient:)`, `BrianBadgeProperty(gradient:)`로도 설정할 수 있습니다.
전체 `buttonProperty(_:)`나 `badgeProperty(_:)`를 교체하면 그라디언트 설정도 함께 교체됩니다.

그라디언트가 있으면 활성 상태에서 `tone`보다 우선합니다. 비활성 상태에서는 기존 비활성 색상을
사용합니다. 버튼은 기존 로딩 동작처럼 `.isLoading(true)`에서 상호작용을 막으면서 활성 색상과
단색 스피너를 유지합니다. 플로팅 버튼은 별도의 스타일이며 이 옵션을 적용하지 않습니다.

`outline`은 경계를 식별하기 위해 테마의 기본 전경색을 48% 혼합합니다. 대비 증가 설정에서는
테마의 `border.strong` 단색 테두리를 사용합니다. 성공·경고·오류처럼 의미 전달이 중요한 배지는
기존 의미별 단색을 사용하고, 그라디언트는 AI·추천·신규 콘텐츠 등의 표현에 사용하세요.

## 테마에서 팔레트 변경하기

``GradientPalette``의 네 가지 색상과 `foreground`를 함께 정의합니다.
`Color.adaptive(light:dark:)`를 사용하면 라이트·다크 모드를 함께 구성할 수 있습니다.
기존 `BrianTheme(palette:brand:)`의 브랜드 설정은 그라디언트를 자동으로 변경하지 않습니다.

```swift
import BrianUI
import SwiftUI

struct CustomGradientThemeExample: View {
  private var theme: BrianTheme {
    var theme = BrianTheme()
    theme.gradient.aurora = GradientPalette(
      start: .adaptive(light: 0xA8E4EC, dark: 0x174651),
      middle: .adaptive(light: 0xB0BEF4, dark: 0x303D69),
      end: .adaptive(light: 0xD7B9F0, dark: 0x50385F),
      highlight: .adaptive(light: 0xF4C7DD, dark: 0x60364D),
      foreground: .adaptive(light: 0x20192E, dark: 0xFAF5FF)
    )
    return theme
  }

  var body: some View {
    Text("나만의 컬러 스토리")
      .padding(24)
      .gradientBackground(.aurora, strength: .vivid)
      .clipShape(.rect(cornerRadius: 24))
      .environment(\.theme, theme)
  }
}
```

## 가독성과 동작

- 기본 팔레트는 라이트 모드에서 어두운 전경색, 다크 모드에서 밝은 전경색을 제공합니다.
- 시스템의 대비 증가 설정에서는 `.subtle`이 elevated 단색 배경으로, `.vivid`가 팔레트의 `middle` 단색으로 바뀝니다.
- 기본 테마와 기본 팔레트의 배경은 불투명합니다. 커스텀 색상의 불투명도는 보정하지 않으며, `.subtle`의 바탕은 테마의 `background.elevated`, `.vivid`의 바탕은 팔레트의 `middle`입니다. 반투명 색상을 사용하면 뒤쪽 표면이 비칠 수 있으므로 실제 배치할 표면 위에서 대비를 확인하세요.
- 그라디언트 배경은 터치나 VoiceOver 탐색에 참여하지 않습니다.
- 애니메이션이 없는 정적 메쉬입니다. 움직임 감소 설정과 무관하게 정지 상태를 유지합니다.
- 커스텀 팔레트는 모든 색상과 중간 혼합 영역에서 전경색의 대비를 확인하세요. 그라디언트만으로 선택·오류 상태를 구분하지 않습니다.
