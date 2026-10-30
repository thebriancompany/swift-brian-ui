# AI를 위한 BrianUI 사용 가이드

이 문서는 BrianUI를 소비하는 앱의 코드를 작성할 때 참고하는 가이드입니다.
현재 체크아웃 기준이며 설치한 버전이 다르면 해당 버전의 소스와 공개 선언을 먼저 확인하세요.
저장소 기여 규칙과 문서 작성법은 [문서화 가이드](DOCUMENTATION.md)를 참고하세요.

## 읽는 순서

1. [시작하기](../Sources/BrianUI/BrianUI.docc/Articles/GettingStarted.md): 설치 조건과 컴포넌트 선택표
2. [테마](../Sources/BrianUI/BrianUI.docc/Articles/Theming.md): 환경값과 스타일 범위
3. [폼](../Sources/BrianUI/BrianUI.docc/Articles/Forms.md): 입력과 선택 상태
4. [프레젠테이션](../Sources/BrianUI/BrianUI.docc/Articles/Presentations.md): 알림, 바텀 시트, 메뉴
5. 구현할 컴포넌트의 `Sources/BrianUI/Components/<이름>/` 공개 선언과 주석

다색 배경이나 AI 보조 기능의 시각적 강조에는 [그라디언트](../Sources/BrianUI/BrianUI.docc/Articles/Gradients.md)도 참고하세요.

각 DocC 문서의 Swift 예제에는 import와 상태 선언이 포함되어 있습니다.
문서에 없는 초기화 인자, 수정자, enum 케이스를 추측해서 만들지 마세요.

## 코드 작성 규칙

- `import SwiftUI`와 `import BrianUI`를 사용합니다. 제품 및 모듈 이름은 `BrianUI`입니다.
- 패키지는 Swift tools 6.4, iOS 18 이상, macOS 15 이상을 요구합니다.
- 별도 설정 없이 기본 테마로 작동합니다. 커스텀 테마는 `.environment(\.theme, theme)`으로 주입합니다.
- 일반 버튼은 SwiftUI `Button`에 `.buttonStyle(.solid)`, `.weak`, `.outline`, `.ghost`를 적용합니다. `BrianButton`이라는 뷰는 제공하지 않습니다.
- 플로팅 버튼은 `.buttonStyle(.floating)`과 `floatingButton...` 수정자를 사용합니다.
- 선택·제안·입력 칩은 `BrianChip`과 `chipSize(_:)`, `chipVariant(_:)`를 사용합니다. 아이콘 전용은 커스텀 레이블과 `chipLayout(.iconOnly)`를 함께 지정합니다.
- 상태는 앱의 `@State`, 모델, 바인딩이 소유합니다. 사용자 입력에 `.constant`를 사용하면 변경값을 유지할 수 없습니다.
- 색상과 간격은 가능한 한 `@Environment(\.theme)`에서 의미별 토큰을 읽어 사용합니다.
- 표현용 다색 배경은 `.gradientBackground(.aurora, strength: .vivid)`처럼 사용합니다. 팔레트는 `.aurora`, `.sunset`, `.lagoon`, 강도는 `.subtle`, `.vivid`를 지원합니다. 기본값은 `.aurora`, `.subtle`입니다.
- 버튼과 배지에는 각각 `.buttonGradient(.aurora)`, `.badgeGradient(.sunset)`를 사용합니다. `solid`는 선명한 채움, `weak`는 은은한 채움, `outline`은 테두리입니다. 버튼 `ghost`는 눌렀을 때만 그라디언트를 표시합니다. `nil`로 상속을 해제합니다.
- 그라디언트는 히어로·커버·추천 카드에 사용하고 성공·경고·오류는 기존 의미별 색상으로 전달합니다. 한 화면에서 주요 그라디언트 하나를 중심으로 사용합니다.
- 각 컴포넌트의 `Property` 타입에서 지원하는 크기, 색상, 변형을 확인합니다. 모든 컴포넌트가 같은 케이스를 지원하지 않습니다.
- 입력의 `helperText`, `errorMessage`, `requirement`, `maximumLength`, 포커스 메서드는 컴포넌트 고유 메서드입니다. `.padding()`이나 환경 수정자보다 먼저 적용합니다.
- BrianUI에서 확장한 `alert`, `shadow`, `textFieldStyle`은 SwiftUI에도 같은 이름이 있습니다. 인자 타입과 레이블을 확인합니다.

## 잘못 가정하기 쉬운 동작

| API | 실제 동작 / 호출자의 책임 |
| --- | --- |
| `maximumLength(_:)` | 글자 수와 초과 상태를 표시합니다. 입력을 자르거나 제출을 차단하지 않습니다. 음수는 0, `nil`은 제한 표시 해제입니다. |
| `requirement(.required)` | 필수 표시만 추가합니다. 빈 값 검증은 앱에서 합니다. |
| `errorMessage(_:)` | 비어 있지 않은 오류가 도움말에 우선합니다. `nil` 또는 빈 문자열로 메시지를 제거합니다. |
| `isLoading(_:)` | 환경값과 비활성화를 적용합니다. 이를 읽는 버튼 스타일이 로딩을 표시합니다. 작업 자체를 실행하지 않습니다. |
| `BrianQuantityPicker` | 1씩 증감합니다. 범위 인자는 없으며 `isDecrementDisabled`, `isIncrementDisabled` 조건을 앱이 계산합니다. |
| `BrianCheckboxGroup` | 배치용입니다. 전체 선택은 `BrianCheckbox(..., sources: [...])`로 바인딩을 연결합니다. |
| `BrianCheckbox(sources:)` | 빈 컬렉션이면 선택되지 않은 비활성 상태입니다. |
| `BrianChip(isSelected:)` | 바인딩이면 탭할 때 반전합니다. `Bool`과 액션을 전달하면 표시만 하며 상태 변경은 액션에서 처리합니다. |
| `BrianChip(removable:onRemove:)` | 뒤쪽 삭제 버튼만 액션을 실행합니다. 실제 데이터와 칩 제거는 호출자가 처리합니다. |
| `chipLayout(.iconOnly)` | 최소 너비를 아이콘에 맞춥니다. 텍스트를 자동으로 숨기지 않으므로 `Label`에는 `.labelStyle(.iconOnly)`를 함께 적용합니다. |
| `BrianAlert`, `BrianBottomSheetContainer` | 콘텐츠 배치용입니다. 실제 표시는 각각 `alert`, `bottomSheet` 수정자로 연결합니다. |
| `BrianAlertFooter` | 직접적인 액션 뷰 한 개 또는 두 개를 지원합니다. 세 개 이상의 액션이나 조건 분기 지원을 가정하지 마세요. |
| `BrianAlertButton` | 기본적으로 알림 닫기 처리에 액션을 전달합니다. 유지해야 하면 `dismissOnAction: false`와 표시 바인딩을 사용합니다. |
| `bottomSheet(isDismissible: false)` | 배경 탭과 드래그에 의한 닫기를 막습니다. 바인딩이나 닫기 버튼에 의한 닫기는 가능합니다. |
| `bottomSheetShowsHandle(false)` | 스냅 지점이 있으면 핸들이 표시됩니다. |
| `menuAnchor(id:)` | 위치만 등록합니다. 탭 시 선택 ID 변경은 호출자가 구현합니다. |
| `menuScope(selection:content:)` | 하위 앵커와 동일한 ID 타입을 사용합니다. 일치하는 활성 앵커가 있어야 표시됩니다. |
| `BrianMenuItem` | 메뉴를 닫은 뒤 액션을 호출합니다. |
| `contentFog` | 테마 배경색 그라디언트로 가장자리를 덮습니다. blur 필터가 아닙니다. |
| `gradientBackground(_:strength:)` | 메쉬 배경과 기본 전경색을 함께 적용합니다. 패딩 뒤에 호출하고 모서리는 별도 `clipShape`로 지정합니다. 하위 뷰의 명시적인 전경색·버튼 스타일을 덮어쓰지 않습니다. |
| `BrianGradient` | 배경만 그립니다. 기본은 `.subtle`이며 크기·모서리·콘텐츠 색은 호출자가 정합니다. 대비 증가 시 단색으로 표시합니다. |
| `buttonGradient(_:)`, `badgeGradient(_:)` | 선택적 팔레트이며 기본값은 `nil`입니다. 활성 상태에서 tone에 우선하고 비활성 상태에서는 기존 단색을 사용합니다. 로딩 버튼은 활성 색상을 유지합니다. 플로팅 버튼에는 적용되지 않습니다. |
| `BrianTheme(palette:brand:)` | 브랜드 단색 설정은 `theme.gradient`를 변경하지 않습니다. 표현용 팔레트는 별도로 지정합니다. |

## 소스 탐색 지도

- `Foundations/Theme`: `BrianTheme`, `EnvironmentValues.theme`
- `Foundations/Color`, `Gradient`, `Font`, `Spacing`, `Radius`, `Shadow`: 토큰과 기본값
- `Components/Gradient`: 메쉬 배경과 배경·전경색 수정자
- `Components/Button/Style`: 버튼 스타일과 `.solid` 등 정적 접근자
- `Components/<컴포넌트>/Environment+*.swift`: 환경을 설정하는 공개 수정자
- `Components/<컴포넌트>/*Property*.swift`: 설정 타입, 기본값, enum 케이스
- `Components/Alert/View+Alert.swift`, `BottomSheet/View+BottomSheet.swift`, `Menu/View+Menu.swift`: 표시 진입점

공개 타입이어도 외부에서 호출할 수 있는 `public init`이 있는지 확인하세요.
내부 프레젠터나 UIKit/AppKit 구현을 앱 코드에서 직접 사용하지 않습니다.

## 앱 작업에 첨부할 요청 예시

> 이 프로젝트의 BrianUI 버전에 맞춰 화면을 구현해 주세요. 먼저 BrianUI 저장소의
> `docs/AI_GUIDE.md`와 관련 DocC 사용 예제를 읽고, 공개 API 선언을 확인해 주세요.
> 입력 상태와 검증 로직은 앱이 소유하고 BrianUI 컴포넌트에 바인딩으로 연결해 주세요.

이 파일은 자동으로 모든 AI 도구에 로드되지 않습니다. 앱 저장소의 에이전트 지침에서
이 파일을 참조하거나 작업 컨텍스트에 함께 제공하세요.
