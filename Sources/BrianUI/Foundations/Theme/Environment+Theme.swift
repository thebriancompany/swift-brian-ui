import SwiftUI

extension EnvironmentValues {
  /// 하위 BrianUI 컴포넌트가 사용하는 테마입니다. 기본 테마가 자동으로 제공됩니다.
  @Entry public var theme: BrianTheme = .init(
    color: .init(),
    radius: .default,
    spacing: .default,
    typography: .default
  )
}
