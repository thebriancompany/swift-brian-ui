# 알림, 바텀 시트와 메뉴 표시하기

표시 상태와 콘텐츠를 연결합니다.

## 알림

``BrianAlert``는 콘텐츠를 배치합니다. 화면에 표시하려면 BrianUI `alert` 수정자를 사용합니다.
SwiftUI 기본 알림과 인자 구성이 다릅니다.

``BrianAlertFooter``는 직접적인 액션 뷰 한 개 또는 두 개를 지원합니다.
첫 번째는 주 액션이며 `.solid`, 두 번째는 보조 액션이며 `.weak` 스타일입니다.
``BrianAlertButton``은 기본적으로 알림 닫기 처리에 액션을 전달합니다.
작업이 끝날 때까지 유지하려면 `dismissOnAction: false`를 사용하고 표시 바인딩을 직접 변경하세요.

```swift
import SwiftUI
import BrianUI

struct BrianAlertExample: View {
  @State private var showsAlert = false
  @State private var deleted = false

  var body: some View {
    Button(deleted ? "삭제됨" : "삭제") {
      showsAlert = true
    }
    .buttonStyle(.outline)
    .alert(
      isPresented: $showsAlert,
      title: "삭제할까요?",
      description: "이 동작은 되돌릴 수 없습니다."
    ) {
      BrianAlertButton("삭제") { deleted = true }

      BrianAlertButton("취소") {}
    }
  }
}
```

## 바텀 시트

`bottomSheet` 수정자에 표시 상태를 전달하고, 제목과 하단 액션 배치가 필요하면
``BrianBottomSheetContainer``로 콘텐츠를 구성합니다.
스냅 지점은 유효한 높이를 정렬하고 중복을 제거한 뒤 가장 낮은 지점에서 시작합니다.
빈 배열이면 콘텐츠에 맞춰 높이를 정합니다. 모든 경우에 구현의 최대 높이 제한이 적용됩니다.

```swift
import SwiftUI
import BrianUI

struct BrianSheetExample: View {
  @State private var showsSheet = false

  var body: some View {
    Button("상세 보기") { showsSheet = true }
      .buttonStyle(.weak)
      .bottomSheet(isPresented: $showsSheet, snapPoints: [.fraction(0.5), .fraction(0.9)]) {
        BrianBottomSheetContainer(title: "상세 정보") {
          Text("바텀 시트의 본문입니다.")
        } footer: {
          Button("완료") { showsSheet = false }
            .buttonStyle(.solid)
        }
        .bottomSheetShowsCloseButton(true)
      }
  }
}
```

`isDismissible: false`는 배경 탭과 드래그에 의한 닫기를 막습니다.
표시 바인딩 변경이나 컨테이너의 닫기 버튼까지 막지는 않습니다.
스냅 지점이 있으면 `bottomSheetShowsHandle(false)`여도 핸들을 표시합니다.

## 앵커 메뉴

`menuAnchor(id:)`는 위치만 등록합니다. 버튼 액션에서 선택 ID를 설정해야 메뉴가 열립니다.
앵커의 ID 타입과 선택 바인딩의 타입이 같아야 하며 `menuScope`는 앵커를 포함하는 상위 뷰에 적용합니다.
``BrianMenuItem``은 메뉴를 닫은 뒤 액션을 호출합니다.

```swift
import SwiftUI
import BrianUI

struct BrianMenuExample: View {
  @State private var selectedMenu: String?
  @State private var title = "문서"

  var body: some View {
    VStack {
      Text(title)

      Button("더 보기") { selectedMenu = "document" }
        .menuAnchor(id: "document")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .menuScope(selection: $selectedMenu) { _ in
      BrianMenuGroup {
        BrianMenuItem(title: "이름 변경", systemImage: "pencil") {
          title = "새 문서"
        }
      }
    }
  }
}
```
