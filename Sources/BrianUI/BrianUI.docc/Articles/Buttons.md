# Styling buttons

Combine appearance and shape with `.buttonStyle(.brian(_:shape:))`.
Use `.press` when the label already defines its own appearance and layout.

## Standard and circular buttons

``BrianButtonStyle`` supports solid, weak, outline, and ghost appearances.
Choose rounded, capsule, or circle shape at the style call. Size, tone, and gradient
remain environment settings and can be applied to a container.

```swift
import SwiftUI
import BrianUI

struct ButtonExamples: View {
  @Environment(\.theme) private var theme

  var body: some View {
    HStack(spacing: theme.spacing.medium) {
      Button("Save") {}
        .buttonStyle(.brian(.solid))
        .buttonTone(.brand)

      Button {} label: {
        Label {
          Text("Add")
        } icon: {
          Image(symbol: .plus)
        }
      }
      .labelStyle(.iconOnly)
      .buttonStyle(.brian(.weak, shape: .circle))
      .buttonSize(.small)

      Button("Continue") {}
        .buttonStyle(.brian(.outline, shape: .capsule))
    }
  }
}
```

Circle uses equal width and height instead of standard button padding.
It does not hide text automatically: use an icon-only label while keeping its accessible title.
Use `Image(symbol:)` in the label for BrianSymbols icons; see <doc:Symbols>.
For custom images, configure resizing, fitting, and clipping inside the label.
See ``BrianButtonStyle/Shape`` for the diameter and symbol font at each size.

All standard appearances support `buttonGradient(_:)` and `isLoading(_:)`.
Loading keeps the layout dimensions, shows a centered spinner, and blocks interaction.
Ghost still applies standard layout and typography, even when its background is transparent.
Floating buttons retain their separate `.floating` style and properties.

## Feedback for custom content

``BrianPressButtonStyle`` leaves padding, frame, font, foreground, background,
clipping, and the hit region to the caller. It ignores standard button size, tone,
and gradient settings.

```swift
import SwiftUI
import BrianUI

struct CustomButtonExample: View {
  @Environment(\.theme) private var theme

  var body: some View {
    let shape = RoundedRectangle(cornerRadius: theme.radius.medium)

    Button {} label: {
      HStack(spacing: theme.spacing.small) {
        Image(symbol: .personCircle)
        Text("Open profile")
      }
      .typography(theme.typography.body.medium)
      .foregroundStyle(theme.color.foreground.primary)
      .padding(theme.spacing.medium)
      .background(theme.color.background.neutral.weak.normal, in: shape)
      .contentShape(shape)
    }
    .buttonStyle(.press)
  }
}
```

The custom label reads its colors, typography, spacing, and corner radius from the
environment theme. Its background and hit region use the same shape.

Use `.press(.opacity)` for feedback without scaling. Scale feedback changes only
rendered size, preserving layout dimensions. With Reduce Motion enabled, scale
feedback uses opacity without animation instead.

Disabled and loading buttons do not show press feedback. The caller owns disabled
appearance and loading content; `.isLoading(true)` blocks interaction without adding
a spinner to this style. A button takes one style: standard buttons already include
press feedback, so do not append `.press` to a `.brian(...)` style.
