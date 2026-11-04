# BrianSymbols 아이콘 사용하기

BrianUI는 BrianSymbols를 의존성으로 연결하며, 기본 컨트롤의 체크·닫기·증감 아이콘에 사용합니다.
기존 SF Symbols 이름을 받는 API도 사용할 수 있습니다. 이 문서는 현재 체크아웃의 API를 설명하며
README에 연결된 이전 릴리스에는 새 API가 포함되지 않을 수 있습니다.

## 이미지와 컴포넌트에 적용하기

`Image(symbol:)`은 BrianSymbols 이미지를 만들고, `Image(style:)`은
`.symbol(BrianSymbol)`과 `.system(String)` 중 하나를 선택합니다.
컴포넌트의 선택적 아이콘 인자에 `nil`을 전달하면 아이콘을 표시하지 않습니다.

```swift
import SwiftUI
import BrianUI

struct BrianSymbolsExample: View {
  @State private var isSelected = false

  var body: some View {
    VStack {
      Image(symbol: .checkmark)

      Image(style: .system("star"))

      BrianBadge(title: "완료", symbol: .checkmark)

      BrianCallout("저장했습니다.", icon: .checkmark)

      BrianMenuItem(title: "추가", symbol: .plus) {}

      BrianChip(
        "선택",
        isSelected: $isSelected,
        prefix: .icon(.symbol(.checkmark)),
        suffixSymbol: .chevronDown
      )
    }
  }
}
```

타입 추론으로 `.checkmark` 등을 전달할 때는 `import BrianUI`로 사용할 수 있습니다.
`BrianSymbol` 타입을 직접 선언하거나 `BrianSymbol.allCases`에 접근하는 코드는
`BrianSymbols` 제품을 앱 타깃의 의존성에 추가하고 `import BrianSymbols`를 사용하세요.
심볼 목록은 BrianSymbols의 `BrianSymbol` 선언에서 확인합니다.

## 컴포넌트별 인자

| 컴포넌트 | BrianSymbols | SF Symbols |
| --- | --- | --- |
| `BrianBadge`, `BrianMenuItem` | `symbol:` | `systemImage:` |
| `BrianCallout` | `icon:` | `systemImage:` |
| `BrianChipLabel`, 텍스트 기반 `BrianChip` | `suffixSymbol:` | `suffixSystemImage:` |
| 칩의 앞쪽 장식 | `prefix: .icon(.symbol(.checkmark))` | `prefix: .icon(.system("star"))` |

콜아웃은 표시 전용, `action:`, `onDismiss:` 초기화 모두 `icon:`을 지원합니다.
칩의 `suffixSymbol:`은 선택 바인딩과 액션 초기화에서 사용할 수 있습니다.
삭제 가능한 칩은 기본 닫기 아이콘을 사용합니다.

기존 `prefix: .icon("star")` 호출은 SF Symbols 아이콘으로 유지됩니다.
새 코드에서는 `.symbol(...)` 또는 `.system(...)`으로 아이콘 종류를 명시할 수 있습니다.

## 의존성 버전

현재 BrianUI는 BrianSymbols의 `main` 브랜치를 참조합니다.
브랜치 업데이트에 따라 심볼 목록과 이미지가 바뀔 수 있으므로 앱에서 검증한
의존성 해석 결과를 `Package.resolved`로 관리하세요.
