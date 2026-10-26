# 문서 작성과 검증

BrianUI의 문서는 한국어로 작성합니다. API 식별자와 코드 표기는 원래 이름을 유지합니다.

## 문서의 역할

| 위치 | 담을 내용 |
| --- | --- |
| 소스의 `///` | API 동작, 인자 의미와 기본값, 반환값, 상태 변경, 제약 조건 |
| `Sources/BrianUI/BrianUI.docc` | 모듈 개요, 여러 API를 조합하는 사용 예제, DocC 심볼 탐색 |
| `docs/AI_GUIDE.md` | AI의 읽기 순서, API 선택 규칙, 오해하기 쉬운 동작, 소스 위치 |
| `README.md` | 설치 조건과 문서 진입점 |

API의 정확한 계약은 소스 주석에 기록하고, 사용 흐름은 DocC 문서로 설명합니다.
동일한 긴 예제를 여러 파일에 복사하지 말고 링크로 연결합니다.
AI 가이드는 전체 API 사전 대신 선택 기준과 실수 방지에 집중합니다.

## DocC 주석 기준

공개 타입, 초기화 메서드, 수정자, 의미가 있는 프로퍼티와 enum 케이스를 문서화합니다.
`body`, `makeBody` 등 프로토콜 구현의 반복 설명보다 사용자에게 필요한 진입점을 우선합니다.
기존 주석은 삭제하지 않고 실제 동작과 일치하도록 보완합니다.

첫 문장은 API의 역할을 독립적으로 설명합니다. 이어서 필요한 경우 다음 내용을 씁니다.

- 호출자가 소유할 상태와 변경되는 값
- 기본값, `nil`, 빈 문자열·컬렉션, 범위를 벗어나는 값의 처리
- 환경을 통해 하위 뷰에 적용되는 범위와 수정자 순서
- 표시만 하는 설정과 검증·입력 차단을 하는 설정의 구분
- `- Parameters:`, `- Returns:`와 필요할 경우 짧은 예제

```swift
/// 글자 수와 최대 길이를 표시하고, 길이를 초과하면 오류 스타일을 적용합니다.
///
/// 입력값을 자르거나 입력을 차단하지 않습니다.
///
/// - Parameter length: 최대 길이입니다. `nil`이면 제한 표시를 제거합니다.
/// - Returns: 최대 길이가 설정된 입력 컴포넌트입니다.
```

심볼 링크는 이중 백틱, DocC 문서 링크는 `<doc:Forms>` 형태를 사용합니다.
오버로드 링크는 DocC에서 실제로 해석되는지 확인합니다.
문서의 Swift 코드 블록은 가능한 한 import, `View`, 상태 선언까지 포함해 타입 검사할 수 있게 작성합니다.
예제에서 나란히 배치하는 컴포넌트 사이는 빈 줄로 구분하고, 각 컴포넌트와 수정자 체인은 붙여 씁니다.

## 로컬 검증

Xcode의 전체 개발 도구가 선택된 macOS에서 저장소 루트를 기준으로 실행합니다.
추가 패키지 플러그인 없이 SwiftPM과 Xcode에 포함된 DocC를 사용합니다.

```sh
swift package dump-symbol-graph
xcrun docc convert Sources/BrianUI/BrianUI.docc \
  --additional-symbol-graph-dir .build/out/symbolgraph \
  --fallback-display-name BrianUI \
  --fallback-bundle-identifier com.thebriancompany.BrianUI \
  --output-path .build/BrianUI.doccarchive \
  --warnings-as-errors
```

`dump-symbol-graph`가 출력하는 실제 심볼 그래프 경로가 다르면 그 경로를 사용합니다.
생성된 `.doccarchive`는 Xcode에서 열어 문서 탐색을 확인할 수 있습니다.

DocC 변환은 코드 블록을 컴파일하지 않습니다. 사용 예제는 별도로 앱 타깃에 넣어 빌드하거나
빌드된 BrianUI 모듈을 대상으로 `swiftc -typecheck`하여 검증해야 합니다.
컴파일 검증과 별개로 사용자 인터랙션이 바뀌면 해당 플랫폼에서 동작을 확인합니다.

## API 변경 시 함께 갱신할 것

1. 변경된 공개 선언의 주석과 기본값 설명
2. 관련 DocC 예제와 모듈의 Topics 목록
3. AI 가이드의 선택 규칙 및 동작 차이
4. 설치 조건이 바뀌었다면 README

현재 문서화는 핵심 사용 경로와 동작상 주의점부터 시작합니다.
모든 토큰 및 보조 공개 심볼의 주석이 완비된 상태는 아니므로, API를 수정할 때 해당 영역을 함께 보완합니다.

## 버전별 문서 배포

라이브러리와 문서는 같은 Git 태그를 기준으로 배포합니다. 첫 릴리스 태그는 `0.1.0`입니다.
GitHub Pages는 `gh-pages` 브랜치의 루트를 게시하며, 버전별 문서를 `/<버전>/`에 보관합니다.
예: https://thebriancompany.github.io/swift-brian-ui/0.1.0/documentation/brianui/

릴리스할 커밋에서 다음 명령으로 정적 호스팅용 문서를 생성합니다.

```sh
swift build -c release
swift package dump-symbol-graph
xcrun docc convert Sources/BrianUI/BrianUI.docc \
  --additional-symbol-graph-dir .build/out/symbolgraph \
  --fallback-display-name BrianUI \
  --fallback-bundle-identifier com.thebriancompany.BrianUI \
  --output-path .build/BrianUI.doccarchive \
  --hosting-base-path swift-brian-ui/0.1.0 \
  --warnings-as-errors
```

생성된 아카이브의 내용을 `gh-pages` 브랜치의 `0.1.0/`에 복사합니다.
브랜치 루트에는 `.nojekyll` 파일과 문서 진입 페이지를 둡니다.
다음 릴리스에서는 명령의 버전과 배포 디렉터리를 함께 변경하고, 이전 버전 문서는 유지합니다.
문서 빌드는 로컬 Xcode에서 수행하며, `gh-pages` 푸시 후 GitHub Pages의 배포 완료를 확인합니다.
