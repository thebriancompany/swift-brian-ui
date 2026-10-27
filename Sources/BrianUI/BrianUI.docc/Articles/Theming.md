# 테마와 스타일 적용하기

환경을 통해 하위 컴포넌트의 토큰과 스타일을 설정합니다.

## 테마 주입

``BrianTheme``은 색상, 그라디언트, 간격, 모서리, 글꼴, 그림자 토큰을 담습니다.
기본 테마를 수정해서 특정 화면 또는 앱 루트에 주입할 수 있습니다.

```swift
import SwiftUI
import BrianUI

struct BrianThemeExample: View {
  private var theme: BrianTheme {
    var theme = BrianTheme()
    theme.spacing.medium = 12
    return theme
  }

  var body: some View {
    BrianThemeContent()
      .environment(\.theme, theme)
  }
}

private struct BrianThemeContent: View {
  @Environment(\.theme) private var theme

  var body: some View {
    VStack(spacing: theme.spacing.medium) {
      Text("테마 미리보기")
        .typography(theme.typography.title.medium)
        .foregroundStyle(theme.color.foreground.primary)

      Button("확인") {}
        .buttonStyle(.solid)
    }
    .padding(theme.spacing.large)
  }
}
```

토큰은 주입된 환경의 하위 뷰에서 읽습니다. 자체 화면을 만들 때도 의미에 맞는
`theme.color.foreground`, `theme.color.background`와 간격 토큰을 사용하면 컴포넌트와 맞출 수 있습니다.

히어로와 강조 카드에는 `theme.gradient`와 `gradientBackground(_:strength:)`를 사용합니다.
팔레트 선택과 사용 예제는 <doc:Gradients>를 참고하세요.

## 컴포넌트 설정 범위

`buttonProperty(_:)`는 크기, 색상 역할과 그라디언트 설정 전체를 교체합니다.
`buttonSize(_:)`와 `buttonTone(_:)`은 해당 필드만 변경합니다.
`buttonGradient(_:)`와 `badgeGradient(_:)`는 표현용 팔레트를 선택하고, `nil`로 해제합니다.
이 설정은 크기·tone을 유지하며, 활성 상태에서는 tone보다 그라디언트가 우선합니다.
부모 컨테이너에 적용하면 하위 버튼이 공유하고, 개별 버튼에서 더 가까운 설정을 적용할 수 있습니다.

```swift
import SwiftUI
import BrianUI

struct BrianButtonStylesExample: View {
  var body: some View {
    VStack {
      Button("저장") {}
        .buttonStyle(.solid)

      Button("삭제") {}
        .buttonStyle(.outline)
        .buttonTone(.critical)
    }
    .buttonSize(.large)
    .buttonTone(.brand)
  }
}
```

같은 뷰에 전체 프로퍼티 교체와 개별 필드 수정을 중복해서 적용하면 순서에 따라 결과가 달라질 수 있습니다.
가능하면 한 가지 방식으로 명확하게 설정하세요. 플로팅 버튼에는 `floatingButtonProperty(_:)` 등 전용 설정을 사용합니다.

## 로딩과 비활성화

`isLoading(true)`는 로딩 환경값을 전달하고 상호작용을 비활성화합니다.
이를 읽는 BrianUI 버튼 스타일은 로딩 표시를 제공합니다. 일반 컨테이너에 적용해도 스피너를 자동으로 추가하지는 않습니다.
비동기 작업의 시작과 종료, 오류 처리, 로딩 상태 관리는 앱이 담당합니다.
