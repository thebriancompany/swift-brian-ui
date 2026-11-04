# Writing and Validating Documentation

Write BrianUI documentation in English, including DocC articles, source documentation comments, and example text. Keep API identifiers unchanged. Only the README has a Korean translation: `README.md` is the English default and `README.ko.md` is Korean. Keep both READMEs synchronized and preserve their language-switch links.

## Documentation responsibilities

| Location | Content |
| --- | --- |
| Source `///` comments | API behavior, parameter meanings and defaults, return values, state changes, and constraints |
| `Sources/BrianUI/BrianUI.docc` | Module overview, examples combining APIs, and DocC symbol navigation |
| `docs/AI_GUIDE.md` | AI reading order, API selection rules, common misconceptions, and source locations |
| `README.md`, `README.ko.md` | Installation requirements and documentation entry points in English and Korean |

Record exact API contracts in source comments and explain usage flows in DocC articles.
Link to long examples instead of duplicating them across files.
Keep the AI guide focused on selection and error prevention rather than a complete API dictionary.

## DocC comment guidelines

Document public types, initializers, modifiers, meaningful properties, and enum cases.
Prioritize user-facing entry points over repetitive descriptions of protocol implementations such as `body` and `makeBody`.
Preserve existing comments and improve them to match actual behavior.

The first sentence should explain the API's role on its own. Add the following where needed:

- Caller-owned state and values that change
- Defaults and handling of `nil`, empty strings or collections, and out-of-range values
- Scope through the environment and modifier ordering
- The distinction between display settings and validation or input blocking
- `- Parameters:`, `- Returns:`, and a short example if needed

```swift
/// Displays the character count and maximum length, applying error styling when the limit is exceeded.
///
/// Does not truncate or block input.
///
/// - Parameter length: The maximum length. Pass `nil` to remove the limit indicator.
/// - Returns: The input component with the maximum length configured.
```

Use double backticks for symbol links and `<doc:Forms>` for DocC article links.
Verify that overloaded symbol links resolve in DocC.
Where possible, include imports, a `View`, and state declarations in Swift code blocks so they can be type-checked.
Separate adjacent components in examples with blank lines, keeping each component and its modifier chain together.

## Local validation

Run from the repository root on macOS with the full Xcode developer tools selected.
Use SwiftPM and the DocC bundled with Xcode without additional package plugins.

```sh
swift package dump-symbol-graph --skip-synthesized-members
xcrun docc convert Sources/BrianUI/BrianUI.docc \
  --additional-symbol-graph-dir .build/out/symbolgraph \
  --fallback-display-name BrianUI \
  --fallback-bundle-identifier com.thebriancompany.BrianUI \
  --output-path .build/BrianUI.doccarchive \
  --warnings-as-errors
```

If `dump-symbol-graph` reports a different symbol graph path, use that path.
Open the generated `.doccarchive` in Xcode to check documentation navigation.

DocC conversion does not compile code blocks. Validate examples by building them in an app target or
running `swiftc -typecheck` against the built BrianUI module.
In addition to compilation, check behavior on the relevant platform when user interactions change.

## Updates required for API changes

1. Comments and default-value descriptions for changed public declarations
2. Relevant DocC examples and the module's Topics list
3. Selection rules and behavior differences in the AI guide
4. Both READMEs if installation requirements change

Documentation currently focuses on core usage paths and behavioral caveats.
Comments do not yet cover every token and supporting public symbol; improve the relevant area when changing an API.

## Releases and documentation deployment

After merging code and documentation into main, publish a version tag such as `0.1.0`.
The **Publish DocC** GitHub Actions workflow builds the library and DocC with Xcode 27 and
publishes them to GitHub Pages. It generates documentation for all stable version tags, preserving earlier version URLs.

- Workflow: `.github/workflows/documentation.yml`
- Deployment results: Actions → Publish DocC
- Documentation URL: `https://thebriancompany.github.io/swift-brian-ui/<version>/documentation/brianui/`
- Redeploy: Actions → Publish DocC → Run workflow, selecting main

Set Settings → Pages → Source to **GitHub Actions** in the repository.
Do not move published release tags.
