# Managing Input and Selection State

Connect caller-owned state and distinguish display settings from validation logic.

## Input and validation

`requirement(.required)` adds a required indicator. It does not validate empty values or block submission.
`maximumLength(_:)` displays `String.count` and the maximum length, highlighting overflow. It does not truncate text.
A nonempty `errorMessage(_:)` takes precedence over helper text.

Component-specific methods return `Self`. Call them before general modifiers that return `some View`,
such as `.padding()` or environment modifiers, to keep those methods available.

```swift
import SwiftUI
import BrianUI

struct BrianFormExample: View {
  @State private var name = ""
  @State private var memo = ""
  @State private var submitted = false
  @FocusState private var nameFocused: Bool

  private var nameError: String? {
    submitted && name.isEmpty ? "Enter your name." : nil
  }

  var body: some View {
    VStack {
      BrianTextField(title: "Name", text: $name)
        .helperText("Enter up to 20 characters.")
        .requirement(.required)
        .maximumLength(20)
        .errorMessage(nameError)
        .textFieldFocused($nameFocused)
        .textFieldSize(.large)

      BrianTextArea(title: "Memo", text: $memo)
        .maximumLength(200)
        .textAreaSizing(.automatic(maximumLines: 5))

      Button("Validate") {
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

Set read-only mode with `.textFieldReadOnly(true)` or `.textAreaReadOnly(true)`.
Use `.disabled(true)` to disable interaction. Read-only mode displays text instead of an editor.

## Displaying selections and input values with chips

Passing a `Binding<Bool>` to ``BrianChip`` toggles selection on tap.
For single selection, pass a `Bool` and an action that updates the selected ID.
For input chips created with `removable:onRemove:`, only the trailing remove button acts; the app removes the actual data.

```swift
import SwiftUI
import BrianUI

struct BrianChipExample: View {
  @State private var includesSoldItems = false
  @State private var category = "All"
  @State private var keywords = ["Furniture", "Lighting"]
  @State private var sortByPrice = false

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      BrianChip(
        "Include sold items",
        isSelected: $includesSoldItems,
        prefix: .icon(.symbol(.checkmark))
      )
      .chipVariant(.outlineWeak)

      ScrollView(.horizontal) {
        HStack {
          ForEach(["All", "Furniture", "Home"], id: \.self) { item in
            BrianChip(item, isSelected: category == item) {
              category = item
            }
          }
        }
      }
      .chipVariant(.outlineStrong)

      HStack {
        ForEach(keywords, id: \.self) { keyword in
          BrianChip(removable: keyword, onRemove: {
            keywords.removeAll { $0 == keyword }
          })
        }
      }
      .chipSize(.small)

      BrianChip("Price", suffixSystemImage: "chevron.down") {
        sortByPrice.toggle()
      }

      BrianChip(isSelected: $sortByPrice) {
        Label("Sort by price", systemImage: "arrow.up.arrow.down")
          .labelStyle(.iconOnly)
      }
      .chipLayout(.iconOnly)

      BrianChip("Coming soon", isSelected: .constant(false))
        .disabled(true)
    }
    .chipSize(.medium)
    .padding()
  }
}
```

`chipSize(_:)` supports `.small`, `.medium`, and `.large`.
`chipVariant(_:)` supports `.solid` for a filled style, `.outlineStrong` for a strong fill when selected,
and `.outlineWeak` for a subtle background and strong border when selected.
Use `.outlineWeak` to reduce emphasis when displaying multiple selections.

Before the text, you can use `prefix: .icon(.system("star"))`, `.avatar(Image("profile"))`, or `.image(Image("thumbnail"))`.
For BrianSymbols and trailing icons, see <doc:Symbols>.

A custom `label` can combine display views such as badges. Do not nest separate buttons inside a chip.
Arrange chips with `HStack`, `ScrollView`, or similar containers. The app handles selection limits and filter resets.

## Select all and quantity ranges

``BrianCheckboxGroup`` handles only layout. Connect select-all behavior through ``BrianCheckbox``'s `sources:`.
Empty `sources` produce an unchecked, disabled checkbox.

``BrianQuantityPicker`` has no range argument. Compute the conditions that disable decrement and increment yourself.
The app also validates the range when quantity changes through other paths.

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
        BrianCheckbox("Terms of service", isOn: $terms)
        BrianCheckbox("Privacy policy", isOn: $privacy)
      } header: {
        BrianCheckbox("Agree to all", sources: [$terms, $privacy])
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
