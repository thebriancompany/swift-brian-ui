# Gradients and Multicolor Effects

Apply smoothly blended colors to heroes, onboarding, content covers, recommendation cards, buttons, and badges.

## Choosing expressive colors

``BrianTheme/gradient`` provides expressive tokens separate from the standard UI's semantic colors.
Use existing `theme.color` values for success, warning, and error states, and gradients for atmosphere and emphasis.

| Palette | Colors | Example uses |
| --- | --- | --- |
| `aurora` | Cyan · blue · lilac · pink | Ideas, AI features, new experiences |
| `sunset` | Peach · coral · lavender | Inspiration, editorial content, warm welcomes |
| `lagoon` | Mint · sky blue · green | Exploration, focus, calm introductions |

These are suggestions rather than fixed functional meanings. Choose one main gradient
per screen and pair it with solid surfaces for input fields and body content.

## Applying backgrounds and text colors together

`gradientBackground(_:strength:)` sets a mesh background and a readable default foreground color together.
The default `.subtle` strength blends colors at 18% over the theme's elevated background,
while `.vivid` uses the vivid palette directly.

```swift
import BrianUI
import SwiftUI

struct GradientCardExample: View {
  @Environment(\.theme) private var theme

  var body: some View {
    VStack(alignment: .leading, spacing: theme.spacing.medium) {
      Label("New ideas", systemImage: "sparkles")
        .typography(theme.typography.title.medium)

      Text("Find inspiration in a space of softly blended colors.")
        .typography(theme.typography.body.medium)
    }
    .padding(theme.spacing.xLarge)
    .frame(maxWidth: .infinity, alignment: .leading)
    .gradientBackground(.aurora, strength: .vivid)
    .clipShape(.rect(cornerRadius: theme.radius.xLarge))
  }
}
```

The modifier does not add padding or corners. Apply it after padding and clip to the desired
shape last. Explicit descendant `foregroundStyle` and button styles remain in effect,
so check contrast against the background when specifying custom colors.

For a background alone, place ``BrianGradient`` using `.background { BrianGradient(.sunset) }`.
In that case, the caller sets the content color. For icons or decorative borders,
use `theme.gradient.aurora.linearGradient`.

## Applying gradients to buttons and badges

Add `buttonGradient(_:)` to an existing button style or `badgeGradient(_:)` to a badge.
Choose only the palette; intensity follows the existing style or badge variant.

| Style / variant | Gradient appearance |
| --- | --- |
| `solid` | Vivid mesh fill and palette foreground color |
| `weak` | Subtle mesh fill and theme default foreground color |
| `outline` | Contrast-enhanced mesh border and theme default foreground color |
| Button `ghost` | Transparent normally, subtle mesh fill while pressed |

```swift
import BrianUI
import SwiftUI

struct GradientControlsExample: View {
  @State private var count = 0

  var body: some View {
    VStack(spacing: 16) {
      Button("Generate ideas · \(count)", systemImage: "sparkles") {
        count += 1
      }
      .buttonStyle(.solid)
      .buttonGradient(.aurora)

      BrianBadge(title: "Recommended", systemImage: "sparkles")
        .badgeVariant(.weak)
        .badgeGradient(.sunset)
    }
  }
}
```

Modifiers are inherited by descendants. Apply `buttonGradient(nil)` or
`badgeGradient(nil)` to an individual element to restore its default solid-color style.
You can also configure them through `BrianButtonProperty(gradient:)` and `BrianBadgeProperty(gradient:)`.
Replacing the entire `buttonProperty(_:)` or `badgeProperty(_:)` also replaces the gradient setting.

A gradient takes precedence over `tone` when enabled. Disabled controls use their existing disabled
colors. As with existing loading behavior, `.isLoading(true)` blocks interaction while retaining enabled colors
and a solid-color spinner. Floating buttons have a separate style and do not support this option.

`outline` blends in 48% of the theme's default foreground color to define the edge. With increased contrast,
it uses a solid `border.strong` theme border. For badges communicating success, warning, or error,
use existing semantic solid colors; reserve gradients for AI, recommendations, or new content.

## Changing theme palettes

Define the four colors and `foreground` of ``GradientPalette`` together.
Use `Color.adaptive(light:dark:)` to configure light and dark modes together.
The brand settings in `BrianTheme(palette:brand:)` do not automatically change gradients.

```swift
import BrianUI
import SwiftUI

struct CustomGradientThemeExample: View {
  private var theme: BrianTheme {
    var theme = BrianTheme()
    theme.gradient.aurora = GradientPalette(
      start: .adaptive(light: 0xA8E4EC, dark: 0x174651),
      middle: .adaptive(light: 0xB0BEF4, dark: 0x303D69),
      end: .adaptive(light: 0xD7B9F0, dark: 0x50385F),
      highlight: .adaptive(light: 0xF4C7DD, dark: 0x60364D),
      foreground: .adaptive(light: 0x20192E, dark: 0xFAF5FF)
    )
    return theme
  }

  var body: some View {
    Text("My color story")
      .padding(24)
      .gradientBackground(.aurora, strength: .vivid)
      .clipShape(.rect(cornerRadius: 24))
      .environment(\.theme, theme)
  }
}
```

## Readability and behavior

- Default palettes provide dark foreground colors in light mode and light foreground colors in dark mode.
- With the system's increased contrast setting, `.subtle` becomes a solid elevated background and `.vivid` becomes the palette's solid `middle` color.
- Default theme and palette backgrounds are opaque. Custom color opacity is not adjusted. The base is the theme's `background.elevated` for `.subtle` and the palette's `middle` for `.vivid`. Translucent colors may reveal surfaces behind them; check contrast over the actual surface.
- Gradient backgrounds do not participate in touch handling or VoiceOver navigation.
- The mesh is static, without animation. It remains still regardless of Reduce Motion settings.
- For custom palettes, check foreground contrast across every color and blended region. Do not use gradients alone to distinguish selection or error states.
