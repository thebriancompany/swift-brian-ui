import SwiftUI

extension EnvironmentValues {
  @Entry public var theme: BrianTheme = .init(
    color: .init(),
    radius: .default,
    spacing: .default,
    typography: .default
  )
}
