# BrianUI Usage Guide for AI

Use this guide when writing app code that consumes BrianUI.
It describes the current checkout. If the installed version differs, check that version's source and public declarations first.
For repository contribution rules and documentation practices, see the [documentation guide](DOCUMENTATION.md).

## Reading order

1. [Getting started](../Sources/BrianUI/BrianUI.docc/Articles/GettingStarted.md): requirements and component selection
2. [Theming](../Sources/BrianUI/BrianUI.docc/Articles/Theming.md): environment values and style scope
3. [Forms](../Sources/BrianUI/BrianUI.docc/Articles/Forms.md): input and selection state
4. [Presentations](../Sources/BrianUI/BrianUI.docc/Articles/Presentations.md): alerts, bottom sheets, and menus
5. Public declarations and comments in `Sources/BrianUI/Components/<Name>/` for the component being implemented

For multicolor backgrounds or visual emphasis on AI features, also see [Gradients](../Sources/BrianUI/BrianUI.docc/Articles/Gradients.md).

Swift examples in each DocC article include imports and state declarations.
Do not invent undocumented initializer arguments, modifiers, or enum cases.

For icons, check the component-specific arguments in [BrianSymbols](../Sources/BrianUI/BrianUI.docc/Articles/Symbols.md).

## Coding guidelines

- Use `import SwiftUI` and `import BrianUI`. Both the product and module are named `BrianUI`.
- Specify BrianSymbols with `Image(symbol:)`, `symbol:` for badges and menus, `icon:` for callouts, and `suffixSymbol:` for chips. Chip prefixes use `.icon(.symbol(.checkmark))` and also support SF Symbols.
- The package requires Swift tools 6.4, iOS 18 or later, and macOS 15 or later.
- The default theme works without setup. Inject a custom theme with `.environment(\.theme, theme)`.
- For standard buttons, apply `.buttonStyle(.solid)`, `.weak`, `.outline`, or `.ghost` to a SwiftUI `Button`. There is no `BrianButton` view.
- For floating buttons, use `.buttonStyle(.floating)` and `floatingButton...` modifiers.
- For selection, suggestion, and input chips, use `BrianChip`, `chipSize(_:)`, and `chipVariant(_:)`. For an icon-only chip, combine a custom label with `chipLayout(.iconOnly)`.
- App `@State`, models, and bindings own state. Using `.constant` for user input cannot retain changes.
- For dates and times, use `BrianDatePicker` with a `Binding<Date>`, optional `in:` range, and `displayedComponents`. It has its own calendar and wheels. For compact buttons, apply `.datePickerStyle(.compact)` directly to the picker and `.datePickerScope()` to an ancestor screen outside scroll views. Apply `.labelsHidden()` before general view modifiers. See [Forms](../Sources/BrianUI/BrianUI.docc/Articles/Forms.md#selecting-dates-and-times).
- Where possible, read semantic color and spacing tokens from `@Environment(\.theme)`.
- Use expressive multicolor backgrounds with `.gradientBackground(.aurora, strength: .vivid)`. Palettes are `.aurora`, `.sunset`, and `.lagoon`; strengths are `.subtle` and `.vivid`. Defaults are `.aurora` and `.subtle`.
- Use `.buttonGradient(.aurora)` for buttons and `.badgeGradient(.sunset)` for badges. `solid` uses a vivid fill, `weak` a subtle fill, and `outline` a border. Button `ghost` shows a gradient only while pressed. Pass `nil` to clear inheritance.
- Use gradients for heroes, covers, and recommendation cards. Use existing semantic colors for success, warning, and error states. Choose one main gradient per screen.
- Check each component's `Property` type for supported sizes, tones, and variants. Components do not all support the same cases.
- Input methods `helperText`, `errorMessage`, `requirement`, `maximumLength`, and focus methods are component-specific. Apply them before `.padding()` or environment modifiers.
- BrianUI's `alert`, `shadow`, and `textFieldStyle` extensions share names with SwiftUI APIs. Check argument types and labels.

## Commonly misunderstood behavior

| API | Actual behavior / caller responsibility |
| --- | --- |
| `maximumLength(_:)` | Displays the count and overflow state. Does not truncate input or block submission. Negative values become 0; `nil` removes the limit indicator. |
| `requirement(.required)` | Adds only a required indicator. The app validates empty values. |
| `errorMessage(_:)` | A nonempty error takes precedence over helper text. Pass `nil` or an empty string to remove it. |
| `isLoading(_:)` | Sets an environment value and disables interaction. Button styles that read it show loading. Does not execute the task. |
| `BrianQuantityPicker` | Changes by 1. Has no range argument; the app computes `isDecrementDisabled` and `isIncrementDisabled`. |
| `BrianDatePicker` | Calendar paging only browses. For cancelable editing, bind to an app-owned draft. See [date and time selection](../Sources/BrianUI/BrianUI.docc/Articles/Forms.md#selecting-dates-and-times) for wheel updates and range handling. |
| `BrianCheckboxGroup` | Handles layout. Connect select-all bindings with `BrianCheckbox(..., sources: [...])`. |
| `BrianCheckbox(sources:)` | An empty collection produces an unchecked, disabled control. |
| `BrianChip(isSelected:)` | A binding toggles on tap. With a `Bool` and action, the value is display-only and the action handles changes. |
| `BrianChip(removable:onRemove:)` | Only the trailing remove button runs the action. The caller removes the data and chip. |
| `chipLayout(.iconOnly)` | Adjusts minimum width for an icon. Does not hide text automatically; also apply `.labelStyle(.iconOnly)` to a `Label`. |
| `BrianAlert`, `BrianBottomSheetContainer` | Lay out content. Present them with the `alert` and `bottomSheet` modifiers, respectively. |
| `BrianAlertFooter` | Supports one or two direct action views. Do not assume support for three or more actions or conditional branches. |
| `BrianAlertButton` | By default, passes the action to the alert dismissal handler. To keep the alert open, use `dismissOnAction: false` and the presentation binding. |
| `bottomSheet(isDismissible: false)` | Prevents dismissal by background taps and dragging. Binding changes and the close button can still dismiss it. |
| `bottomSheetShowsHandle(false)` | The handle remains visible when snap points exist. |
| `menuAnchor(id:)` | Registers only a position. The caller changes the selected ID on tap. |
| `menuScope(selection:content:)` | Uses the same ID type as descendant anchors. A matching active anchor is required for presentation. |
| `BrianMenuItem` | Dismisses the menu before calling the action. |
| `contentFog` | Covers edges with a theme background color gradient. It is not a blur filter. |
| `gradientBackground(_:strength:)` | Applies a mesh background and default foreground color. Call after padding; use a separate `clipShape` for corners. Does not override explicit foreground colors or button styles in descendants. |
| `BrianGradient` | Draws only the background. Defaults to `.subtle`; the caller sets size, corners, and content color. Uses a solid color with increased contrast. |
| `buttonGradient(_:)`, `badgeGradient(_:)` | Optional palettes defaulting to `nil`. Override tone when enabled; use existing solid colors when disabled. Loading buttons retain enabled colors. Do not apply to floating buttons. |
| `BrianTheme(palette:brand:)` | Solid brand color settings do not change `theme.gradient`. Set expressive palettes separately. |

## Source map

- `Foundations/Theme`: `BrianTheme`, `EnvironmentValues.theme`
- `Foundations/Color`, `Gradient`, `Font`, `Spacing`, `Radius`, `Shadow`: tokens and defaults
- `Components/Image`: `Image.Style`, BrianSymbols and SF Symbols image initializers
- `Components/Gradient`: mesh backgrounds and background/foreground modifiers
- `Components/Button/Style`: button styles and static accessors such as `.solid`
- `Components/<Component>/Environment+*.swift`: public environment modifiers
- `Components/<Component>/*Property*.swift`: configuration types, defaults, and enum cases
- `Components/Alert/View+Alert.swift`, `BottomSheet/View+BottomSheet.swift`, `Menu/View+Menu.swift`: presentation entry points

Even for public types, check for an externally accessible `public init`.
Do not use internal presenters or UIKit/AppKit implementations directly in app code.

## Example prompt for an app task

> Implement a screen for this project's BrianUI version. First read the BrianUI repository's
> `docs/AI_GUIDE.md` and relevant DocC examples, then check public API declarations.
> Keep input state and validation in the app, and connect them to BrianUI components through bindings.

Not all AI tools load this file automatically. Reference it in the app repository's agent instructions
or include it in the task context.
