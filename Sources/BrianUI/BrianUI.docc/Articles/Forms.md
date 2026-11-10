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
      .buttonStyle(.brian(.solid))
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

## Selecting dates and times

``BrianDatePicker`` uses a caller-owned `Binding<Date>`. By default it shows both date and time controls.
Use `.date` for a calendar or `.hourAndMinute` for time selection only.

```swift
import SwiftUI
import BrianUI

struct BrianDateSelectionExample: View {
  @State private var appointment = Date()
  @State private var birthday = Date()
  @State private var reminder = Date()
  @State private var latestBirthday = Date()

  var body: some View {
    ScrollView {
      VStack(spacing: 24) {
        BrianDatePicker("Appointment", selection: $appointment)

        BrianDatePicker(
          "Birthday",
          selection: $birthday,
          in: ...latestBirthday,
          displayedComponents: .date
        )

        BrianDatePicker(
          "Reminder",
          selection: $reminder,
          displayedComponents: .hourAndMinute
        )
      }
      .padding()
    }
  }
}
```

### Change the selection

Swipe horizontally or use the arrows to browse months without changing the selected date.
Tap a day to select it. Tap the month heading to open separate year and month wheels at the selected date.
Changing year or month keeps the day and time where valid, adjusting to the target month and era when necessary.

Tap the time heading to open separate hour and minute wheels. The wheels replace the calendar;
tap the active heading again to return. Time-only controls expand the wheels below the heading.
The wheels use 24-hour values, while the time heading follows the environment's locale.

Day and wheel-row taps update the binding immediately. Scrolling a wheel updates it when scrolling settles.
The calendar, time zone, and locale follow the environment. Month and year lists expand as you navigate.

Colors, typography, and spacing follow `theme`. Today has a neutral background and outline that refresh
while the calendar is visible.

### Show compact date and time buttons

Apply `.datePickerStyle(.compact)` directly to `BrianDatePicker` to show buttons that open
BrianUI calendar and time popups. Add `.labelsHidden()` to hide the visible label.
The default style remains the expanded calendar.

A compact picker presents in its current window and ends active text editing before opening.
Tapping outside dismisses the popup.

```swift
import SwiftUI
import BrianUI

struct BrianCompactDatePickerExample: View {
  @State private var appointment = Date()

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        BrianDatePicker("Appointment", selection: $appointment)
          .datePickerStyle(.compact)
          .labelsHidden()

        BrianDatePicker("Time", selection: $appointment, displayedComponents: .hourAndMinute)
          .datePickerStyle(.compact)
      }
      .padding()
    }
  }
}
```

The popup inherits the picker's environment, including its theme, locale, and calendar.
Disabling the picker while its popup is open closes it. Menu width settings do not override
the DatePicker popup width; the popup still fits within the window's available space.

Use `.date` for a date-only button or `.hourAndMinute` for a time-only button.
The open button uses the theme's brand colors. The popup animates around the button position when opening or closing after an outside tap.
The position is recalculated when the picker updates.
The accessibility escape action also closes the popup.
This animation is specific to DatePicker popups and does not enable animations for ordinary menus.

Apply `datePickerStyle(.compact)` and `labelsHidden()` before modifiers such as `padding()`
or `environment`. These are methods on `BrianDatePicker`; applying SwiftUI's style to a parent
container does not configure descendant BrianDatePicker controls.
Selection changes take effect immediately. For cancellation, use the draft pattern below.

### Limit selectable dates

Use `in:` with a closed, lower-bounded, or upper-bounded range. Bounds are inclusive and apply
to the full instant, even when only dates or times are displayed. An out-of-range binding is clamped
on appearance and when the range or selection changes, including while the control is disabled.
Time-only controls can therefore move to another day when the range changes.

Keep bounds stable during editing, as `latestBirthday` does in the example. Capture time-based bounds
when editing begins instead of recomputing `Date()` whenever the binding changes.
See ``BrianDatePicker`` for the selection contract and its range overloads.

### Save or cancel changes

Pass an app-owned draft date to the picker. Save copies the draft to the model; Cancel discards it.
Once wheel scrolling settles, Save can use the draft without returning to the calendar.

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
