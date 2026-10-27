# ``BrianUI``

SwiftUI 앱에서 일관된 테마와 컴포넌트를 사용하는 Brian Design System입니다.

## Overview

iOS 18 이상과 macOS 15 이상을 지원하며, 패키지 매니페스트는 Swift tools 6.4를 요구합니다.
`import BrianUI` 후 기본 테마로 바로 사용할 수 있습니다.

버튼은 SwiftUI `Button`에 BrianUI 스타일을 적용하고, 입력과 선택 컨트롤은
`Brian` 접두사가 붙은 컴포넌트를 사용합니다. 상태는 호출자가 소유하고 바인딩으로 전달합니다.

## Topics

### 시작하기

- <doc:GettingStarted>
- <doc:Theming>
- <doc:Gradients>
- <doc:Forms>
- <doc:Presentations>

### 테마와 토큰

- ``BrianTheme``
- ``ColorPalette``
- ``ColorToken``
- ``GradientToken``
- ``GradientPalette``
- ``SpacingToken``
- ``RadiusToken``
- ``TypographyToken``
- ``Typography``
- ``ShadowToken``
- ``Shadow``

### 그라디언트 배경

- ``BrianGradient``
- ``SwiftUICore/View/gradientBackground(_:strength:)``
- ``SwiftUICore/View/buttonGradient(_:)``
- ``SwiftUICore/View/badgeGradient(_:)``

### 버튼과 피드백

- ``BrianSolidButtonStyle``
- ``BrianWeakButtonStyle``
- ``BrianOutlineButtonStyle``
- ``BrianGhostButtonStyle``
- ``BrianFloatingButtonStyle``
- ``BrianButtonProperty``
- ``BrianButtonGroup``
- ``BrianBadge``
- ``BrianCallout``
- ``BrianLoadingSpinner``

### 입력과 선택

- ``BrianTextField``
- ``BrianTextArea``
- ``BrianCheckbox``
- ``BrianCheckboxGroup``
- ``BrianSwitch``
- ``BrianQuantityPicker``

### 알림과 메뉴

- ``BrianAlert``
- ``BrianAlertButton``
- ``BrianAlertFooter``
- ``BrianBottomSheetContainer``
- ``BrianBottomSheetSnapPoint``
- ``BrianMenuItem``
- ``BrianMenuGroup``
- ``BrianMenuDivider``
