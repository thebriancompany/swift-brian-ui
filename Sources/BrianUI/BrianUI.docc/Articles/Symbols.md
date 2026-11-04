# Using BrianSymbols Icons

BrianUI depends on BrianSymbols and uses it for check, close, increment, and decrement icons in standard controls.
APIs accepting SF Symbols names remain available. This article describes the current checkout;
earlier releases linked from the README may not include new APIs.

## Applying icons to images and components

`Image(symbol:)` creates a BrianSymbols image, while `Image(style:)` selects between
`.symbol(BrianSymbol)` and `.system(String)`.
Pass `nil` to an optional component icon argument to hide the icon.

```swift
import SwiftUI
import BrianUI

struct BrianSymbolsExample: View {
  @State private var isSelected = false

  var body: some View {
    VStack {
      Image(symbol: .checkmark)

      Image(style: .system("star"))

      BrianBadge(title: "Done", symbol: .checkmark)

      BrianCallout("Saved.", icon: .checkmark)

      BrianMenuItem(title: "Add", symbol: .plus) {}

      BrianChip(
        "Select",
        isSelected: $isSelected,
        prefix: .icon(.symbol(.checkmark)),
        suffixSymbol: .chevronDown
      )
    }
  }
}
```

With type inference, values such as `.checkmark` are available through `import BrianUI`.
For code that declares the `BrianSymbol` type directly or accesses `BrianSymbol.allCases`,
add the `BrianSymbols` product to the app target's dependencies and use `import BrianSymbols`.
See the `BrianSymbol` declaration in BrianSymbols for the symbol list.

## Component arguments

| Component | BrianSymbols | SF Symbols |
| --- | --- | --- |
| `BrianBadge`, `BrianMenuItem` | `symbol:` | `systemImage:` |
| `BrianCallout` | `icon:` | `systemImage:` |
| `BrianChipLabel`, text-based `BrianChip` | `suffixSymbol:` | `suffixSystemImage:` |
| Chip prefix | `prefix: .icon(.symbol(.checkmark))` | `prefix: .icon(.system("star"))` |

Callouts support `icon:` in display-only, `action:`, and `onDismiss:` initializers.
Chips support `suffixSymbol:` in selection-binding and action initializers.
Removable chips use the default close icon.

Existing `prefix: .icon("star")` calls continue to use SF Symbols.
New code can specify the icon source explicitly with `.symbol(...)` or `.system(...)`.
