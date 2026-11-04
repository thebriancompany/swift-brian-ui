# ``BrianUI``

Brian Design System provides consistent themes and components for SwiftUI apps.

## Overview

Supports iOS 18 or later and macOS 15 or later. The package manifest requires Swift tools 6.4.
Import `BrianUI` to start using the default theme immediately.

Apply BrianUI styles to SwiftUI `Button` views. For input and selection controls,
use components with the `Brian` prefix. The caller owns state and passes it through bindings.

## Topics

### Getting started

- <doc:GettingStarted>
- <doc:Theming>
- <doc:Gradients>
- <doc:Symbols>
- <doc:Forms>
- <doc:Presentations>

### Themes and tokens

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

### Gradient backgrounds

- ``BrianGradient``
- ``SwiftUICore/View/gradientBackground(_:strength:)``
- ``SwiftUICore/View/buttonGradient(_:)``
- ``SwiftUICore/View/badgeGradient(_:)``

### Buttons and feedback

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

### Input and selection

- ``BrianTextField``
- ``BrianTextArea``
- ``BrianCheckbox``
- ``BrianCheckboxGroup``
- ``BrianChip``
- ``BrianChipLabel``
- ``BrianChipProperty``
- ``BrianSwitch``
- ``BrianQuantityPicker``

### Alerts and menus

- ``BrianAlert``
- ``BrianAlertButton``
- ``BrianAlertFooter``
- ``BrianBottomSheetContainer``
- ``BrianBottomSheetSnapPoint``
- ``BrianMenuItem``
- ``BrianMenuGroup``
- ``BrianMenuDivider``
