# Presenting Alerts, Bottom Sheets, and Menus

Connect presentation state to content.

## Alerts

``BrianAlert`` lays out content. Use the BrianUI `alert` modifier to present it.
Its arguments differ from SwiftUI's standard alert.

``BrianAlertFooter`` supports one or two direct action views.
The first is the primary action with `.solid` styling; the second is secondary with `.weak` styling.
``BrianAlertButton`` passes its action to the alert dismissal handler by default.
To keep the alert open until work finishes, use `dismissOnAction: false` and update the presentation binding yourself.

```swift
import SwiftUI
import BrianUI

struct BrianAlertExample: View {
  @State private var showsAlert = false
  @State private var deleted = false

  var body: some View {
    Button(deleted ? "Deleted" : "Delete") {
      showsAlert = true
    }
    .buttonStyle(.outline)
    .alert(
      isPresented: $showsAlert,
      title: "Delete this item?",
      description: "This action cannot be undone."
    ) {
      BrianAlertButton("Delete") { deleted = true }

      BrianAlertButton("Cancel") {}
    }
  }
}
```

## Bottom sheets

Pass presentation state to the `bottomSheet` modifier. For a title and footer actions,
compose content with ``BrianBottomSheetContainer``.
Valid snap heights are sorted and deduplicated, starting at the lowest point.
An empty array sizes the sheet to its content. The implementation's maximum height applies in all cases.

```swift
import SwiftUI
import BrianUI

struct BrianSheetExample: View {
  @State private var showsSheet = false

  var body: some View {
    Button("View details") { showsSheet = true }
      .buttonStyle(.weak)
      .bottomSheet(isPresented: $showsSheet, snapPoints: [.fraction(0.5), .fraction(0.9)]) {
        BrianBottomSheetContainer(title: "Details") {
          Text("This is the bottom sheet content.")
        } footer: {
          Button("Done") { showsSheet = false }
            .buttonStyle(.solid)
        }
        .bottomSheetShowsCloseButton(true)
      }
  }
}
```

`isDismissible: false` prevents dismissal by background taps and dragging.
It does not prevent dismissal through the presentation binding or the container's close button.
When snap points exist, the handle appears even with `bottomSheetShowsHandle(false)`.

## Anchored menus

`menuAnchor(id:)` registers only a position. Set the selected ID in a button action to open the menu.
The anchor ID and selection binding must use the same type. Apply `menuScope` to an ancestor containing the anchors.
``BrianMenuItem`` dismisses the menu before calling its action.

```swift
import SwiftUI
import BrianUI

struct BrianMenuExample: View {
  @State private var selectedMenu: String?
  @State private var title = "Document"

  var body: some View {
    VStack {
      Text(title)

      Button("More") { selectedMenu = "document" }
        .menuAnchor(id: "document")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .menuScope(selection: $selectedMenu) { _ in
      BrianMenuGroup {
        BrianMenuItem(title: "Rename", systemImage: "pencil") {
          title = "New document"
        }
      }
    }
  }
}
```
