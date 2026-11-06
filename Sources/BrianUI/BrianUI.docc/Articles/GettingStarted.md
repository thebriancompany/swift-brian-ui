# Getting Started with BrianUI

Add the package and build your first screen with the default theme.

## Adding the package

In Xcode's package dependency dialog, add the following repository and the `BrianUI` product to your app target.

`https://github.com/thebriancompany/swift-brian-ui.git`

Choose a tag or revision validated for your project. This article describes the current checkout's APIs.
Requires Swift tools 6.4 or later, iOS 18 or later, or macOS 15 or later.

BrianSymbols is fetched as a BrianUI dependency. See <doc:Symbols> for icon selection and usage.

## Your first screen

No separate initialization or global registration is needed. The default theme is provided through the environment.

```swift
import SwiftUI
import BrianUI

struct BrianWelcomeView: View {
  @State private var name = ""
  @State private var notifications = true

  var body: some View {
    VStack(spacing: 16) {
      BrianTextField(title: "Name", text: $name, placeholder: "Enter your name")
        .helperText("The name shown on your profile.")

      BrianSwitch("Receive notifications", isOn: $notifications)

      Button("Clear name") {
        name = ""
      }
      .buttonStyle(.solid)
      .buttonTone(.brand)
    }
    .padding()
  }
}
```

## Choosing components

| Purpose | API | Configuration |
| --- | --- | --- |
| Standard button | SwiftUI `Button` | `.buttonStyle(.solid / .weak / .outline / .ghost)` |
| Floating button | SwiftUI `Button` | `.buttonStyle(.floating)`, `floatingButtonSize(_:)` |
| Primary and secondary action layout | ``BrianButtonGroup`` | `primary`, `secondary` closures |
| Single-line / multiline input | ``BrianTextField``, ``BrianTextArea`` | String binding, dedicated modifiers |
| Checkbox / select all | ``BrianCheckbox``, ``BrianCheckboxGroup`` | `isOn:` or `sources:` |
| Selection / suggestion / input chip | ``BrianChip`` | `isSelected:`, `action:`, `onRemove:`, `chipVariant(_:)` |
| On / off | ``BrianSwitch`` | `isOn:` |
| Quantity adjustment | ``BrianQuantityPicker`` | `quantity:`, per-direction disabled conditions |
| Date / time selection | ``BrianDatePicker`` | `selection:`, optional `in:` range, `displayedComponents:`; compact presentation uses the current window (see <doc:Forms>) |
| Status display | ``BrianBadge``, ``BrianCallout`` | Component-specific property modifiers |
| Loading indicator | ``BrianLoadingSpinner`` | Place directly or apply `isLoading(_:)` to a button |
| Modal presentation | BrianUI `alert`, `bottomSheet` modifiers | Presentation binding and content |
| Anchored menu | `menuAnchor(id:)`, `menuScope(selection:content:)` | Matching ID types and selection binding |

Set button size and tone with `buttonSize(_:)` and `buttonTone(_:)`.
Supported size and tone cases differ by component; do not assume values transfer between components.

## Next steps

- <doc:Theming>: themes and component configuration through the environment
- <doc:Forms>: input state and validation responsibilities
- <doc:Presentations>: alerts, bottom sheets, and menus
