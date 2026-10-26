# BrianUI 시작하기

패키지를 연결하고 기본 테마로 첫 화면을 만듭니다.

## 패키지 연결

Xcode의 패키지 의존성 추가 화면에서 다음 저장소를 연결하고 앱 타깃에 `BrianUI` 제품을 추가합니다.

`https://github.com/thebriancompany/swift-brian-ui.git`

프로젝트에서 검증한 태그나 리비전을 선택하세요. 이 문서는 현재 체크아웃의 API를 설명합니다.
Swift tools 6.4 이상, iOS 18 이상 또는 macOS 15 이상이 필요합니다.

## 첫 화면

별도 초기화나 전역 등록은 필요하지 않습니다. 기본 테마가 환경에 제공됩니다.

```swift
import SwiftUI
import BrianUI

struct BrianWelcomeView: View {
  @State private var name = ""
  @State private var notifications = true

  var body: some View {
    VStack(spacing: 16) {
      BrianTextField(title: "이름", text: $name, placeholder: "이름을 입력하세요")
        .helperText("프로필에 표시할 이름입니다.")

      BrianSwitch("알림 받기", isOn: $notifications)

      Button("이름 지우기") {
        name = ""
      }
      .buttonStyle(.solid)
      .buttonTone(.brand)
    }
    .padding()
  }
}
```

## 컴포넌트 선택

| 목적 | API | 설정 방법 |
| --- | --- | --- |
| 일반 버튼 | SwiftUI `Button` | `.buttonStyle(.solid / .weak / .outline / .ghost)` |
| 플로팅 버튼 | SwiftUI `Button` | `.buttonStyle(.floating)`, `floatingButtonSize(_:)` |
| 주·보조 액션 배치 | ``BrianButtonGroup`` | `primary`, `secondary` 클로저 |
| 한 줄 / 여러 줄 입력 | ``BrianTextField``, ``BrianTextArea`` | 문자열 바인딩, 전용 수정자 |
| 체크박스 / 전체 선택 | ``BrianCheckbox``, ``BrianCheckboxGroup`` | `isOn:` 또는 `sources:` |
| 켜기 / 끄기 | ``BrianSwitch`` | `isOn:` |
| 수량 조절 | ``BrianQuantityPicker`` | `quantity:`, 방향별 비활성화 조건 |
| 상태 표시 | ``BrianBadge``, ``BrianCallout`` | 각 컴포넌트의 프로퍼티 수정자 |
| 로딩 표시 | ``BrianLoadingSpinner`` | 직접 배치하거나 버튼에 `isLoading(_:)` 적용 |
| 모달 표시 | BrianUI `alert`, `bottomSheet` 수정자 | 표시 바인딩과 콘텐츠 |
| 앵커 메뉴 | `menuAnchor(id:)`, `menuScope(selection:content:)` | 동일한 타입의 ID와 선택 바인딩 |

버튼 크기와 색상은 `buttonSize(_:)`, `buttonTone(_:)`으로 지정합니다.
컴포넌트마다 지원하는 크기와 색상 케이스가 다르므로 다른 컴포넌트의 값을 그대로 적용하지 마세요.

## 다음 단계

- <doc:Theming>: 환경을 통한 테마 및 컴포넌트 설정
- <doc:Forms>: 입력 상태와 검증 책임
- <doc:Presentations>: 알림, 바텀 시트, 메뉴
