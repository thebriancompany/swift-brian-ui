# Applying Themes and Styles

Configure descendant component tokens and styles through the environment.

## Injecting a theme

``BrianTheme`` contains color, gradient, spacing, radius, typography, and shadow tokens.
Modify the default theme and inject it into a screen or the app root.

```swift
import SwiftUI
import BrianUI

struct BrianThemeExample: View {
  private var theme: BrianTheme {
    var theme = BrianTheme()
    theme.spacing.medium = 12
    return theme
  }

  var body: some View {
    BrianThemeContent()
      .environment(\.theme, theme)
  }
}

private struct BrianThemeContent: View {
  @Environment(\.theme) private var theme

  var body: some View {
    VStack(spacing: theme.spacing.medium) {
      Text("Theme preview")
        .typography(theme.typography.title.medium)
        .foregroundStyle(theme.color.foreground.primary)

      Button("OK") {}
        .buttonStyle(.brian(.solid))
    }
    .padding(theme.spacing.large)
  }
}
```

Read tokens in descendant views of the injected environment. In custom screens, use semantic
`theme.color.foreground`, `theme.color.background`, and spacing tokens to match components.

Use `theme.gradient` and `gradientBackground(_:strength:)` for heroes and highlighted cards.
See <doc:Gradients> for palette selection and examples.

## Component configuration scope

`buttonProperty(_:)` replaces the entire size, tone, and gradient configuration.
`buttonSize(_:)` and `buttonTone(_:)` change only their respective fields.
`buttonGradient(_:)` and `badgeGradient(_:)` select an expressive palette; `nil` clears it.
These settings preserve size and tone, but the gradient takes precedence over tone when enabled.
Settings on a parent container are shared by descendant buttons; individual buttons can override them locally.

```swift
import SwiftUI
import BrianUI

struct BrianButtonStylesExample: View {
  var body: some View {
    VStack {
      Button("Save") {}
        .buttonStyle(.brian(.solid))

      Button("Delete") {}
        .buttonStyle(.brian(.outline))
        .buttonTone(.critical)
    }
    .buttonSize(.large)
    .buttonTone(.brand)
  }
}
```

Combining whole-property replacement and individual field changes on the same view can produce order-dependent results.
Prefer one clear approach where possible. Use dedicated settings such as `floatingButtonProperty(_:)` for floating buttons.

## Loading and disabled states

`isLoading(true)` passes a loading environment value and disables interaction.
The `.brian(...)` and `.floating` button styles display a spinner; `.press` leaves loading content to the caller.
Applying it to a general container does not automatically add a spinner.
The app manages asynchronous task start and completion, error handling, and loading state.
