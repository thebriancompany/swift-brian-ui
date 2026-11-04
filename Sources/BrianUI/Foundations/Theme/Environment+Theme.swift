import SwiftUI

extension EnvironmentValues {
  /// The theme used by descendant BrianUI components. A default theme is provided automatically.
  @Entry public var theme: BrianTheme = .init(
    color: .init(),
    radius: .default,
    spacing: .default,
    typography: .default
  )
}
