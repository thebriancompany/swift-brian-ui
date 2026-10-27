![Brian Design System](docs/assets/cover.webp)

![개발 중인 Brian Design System](docs/assets/wip.png)

# Brian Design System

SwiftUI 앱을 위한 테마와 UI 컴포넌트 라이브러리입니다. 현재 버전은 **0.1.0**이며, 1.0 이전에는 API가 변경될 수 있습니다.

## 설치

- Swift tools 6.4 이상
- iOS 18 이상 / macOS 15 이상
- 패키지 저장소: `https://github.com/thebriancompany/swift-brian-ui.git`
- 앱 타깃에 추가할 제품 및 import 모듈: `BrianUI`

Xcode에서 패키지 의존성을 추가하고 **Exact Version: 0.1.0**을 선택하세요.
기본 테마가 제공되므로 별도 초기화 없이 사용할 수 있습니다.

`Package.swift`에서는 다음과 같이 추가합니다. 앱 타깃의 dependencies에는
`.product(name: "BrianUI", package: "swift-brian-ui")`를 지정하세요.

```swift
.package(url: "https://github.com/thebriancompany/swift-brian-ui.git", exact: "0.1.0")
```

```swift
import BrianUI
import SwiftUI

struct ExampleView: View {
  var body: some View {
    Button("확인") {}
      .buttonStyle(.solid)
      .buttonTone(.brand)
  }
}
```

## 문서

- [BrianUI 0.1.0 API 문서 (DocC)](https://thebriancompany.github.io/swift-brian-ui/0.1.0/documentation/brianui/)
- [0.1.0 릴리스](https://github.com/thebriancompany/swift-brian-ui/releases/tag/0.1.0)
- [시작하기와 컴포넌트 선택](Sources/BrianUI/BrianUI.docc/Articles/GettingStarted.md)
- [테마와 스타일](Sources/BrianUI/BrianUI.docc/Articles/Theming.md)
- [그라디언트와 다색 표현](Sources/BrianUI/BrianUI.docc/Articles/Gradients.md) (현재 체크아웃 기준)
- [입력과 선택 상태](Sources/BrianUI/BrianUI.docc/Articles/Forms.md)
- [알림, 바텀 시트와 메뉴](Sources/BrianUI/BrianUI.docc/Articles/Presentations.md)
- [AI 사용 가이드](docs/AI_GUIDE.md)
- [문서 작성 기준과 DocC 빌드](docs/DOCUMENTATION.md)

AI로 앱을 구현할 때는 `docs/AI_GUIDE.md`를 컨텍스트에 제공하세요.
이 가이드는 현재 체크아웃의 API를 기준으로 하므로 사용하는 패키지 버전과 맞춰 확인해야 합니다.
