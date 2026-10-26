# 입력과 선택 상태 다루기

호출자가 소유한 상태를 연결하고 표시 설정과 검증 로직을 구분합니다.

## 입력과 검증

`requirement(.required)`는 필수 표시를 추가합니다. 빈 값의 검증이나 제출 차단은 하지 않습니다.
`maximumLength(_:)`는 `String.count`와 최대 길이를 표시하고 초과 상태를 강조합니다. 텍스트를 자르지 않습니다.
`errorMessage(_:)`의 비어 있지 않은 메시지가 도움말보다 우선합니다.

컴포넌트 고유 메서드는 `Self`를 반환합니다. `.padding()`이나 환경 수정자처럼 `some View`를 반환하는
일반 수정자보다 먼저 호출해야 계속 사용할 수 있습니다.

```swift
import SwiftUI
import BrianUI

struct BrianFormExample: View {
  @State private var name = ""
  @State private var memo = ""
  @State private var submitted = false
  @FocusState private var nameFocused: Bool

  private var nameError: String? {
    submitted && name.isEmpty ? "이름을 입력하세요." : nil
  }

  var body: some View {
    VStack {
      BrianTextField(title: "이름", text: $name)
        .helperText("20자 이내로 입력하세요.")
        .requirement(.required)
        .maximumLength(20)
        .errorMessage(nameError)
        .textFieldFocused($nameFocused)
        .textFieldSize(.large)

      BrianTextArea(title: "메모", text: $memo)
        .maximumLength(200)
        .textAreaSizing(.automatic(maximumLines: 5))

      Button("검증") {
        submitted = true
        nameFocused = name.isEmpty
      }
      .buttonStyle(.solid)
      .disabled(name.count > 20 || memo.count > 200)
    }
    .padding()
  }
}
```

읽기 전용은 `.textFieldReadOnly(true)`, `.textAreaReadOnly(true)`로 설정합니다.
비활성화는 `.disabled(true)`를 사용합니다. 읽기 전용은 편집 대신 텍스트 표시를 사용합니다.

## 전체 선택과 수량 범위

``BrianCheckboxGroup``은 배치만 담당합니다. 전체 선택은 ``BrianCheckbox``의 `sources:`로 연결합니다.
빈 `sources`는 선택되지 않은 비활성 체크박스가 됩니다.

``BrianQuantityPicker``에는 범위 인자가 없습니다. 감소·증가 버튼의 비활성화 조건을 직접 계산하세요.
다른 경로에서 수량을 변경할 때의 범위 검증도 앱이 담당합니다.

```swift
import SwiftUI
import BrianUI

struct BrianSelectionExample: View {
  @State private var terms = false
  @State private var privacy = false
  @State private var quantity = 1

  var body: some View {
    VStack {
      BrianCheckboxGroup {
        BrianCheckbox("이용약관", isOn: $terms)
        BrianCheckbox("개인정보 처리방침", isOn: $privacy)
      } header: {
        BrianCheckbox("전체 동의", sources: [$terms, $privacy])
      }

      BrianQuantityPicker(
        quantity: $quantity,
        isDecrementDisabled: quantity <= 1,
        isIncrementDisabled: quantity >= 10
      )
    }
  }
}
```
