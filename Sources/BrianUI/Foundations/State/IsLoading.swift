import SwiftUI

extension EnvironmentValues {
  @Entry var isLoading: Bool = false
}

extension View {
  /// Passes loading state to descendants and disables interaction while loading.
  ///
  /// BrianUI button styles that read this environment value provide the loading appearance.
  /// Does not add a spinner to arbitrary views or start asynchronous work.
  ///
  /// - Parameter isLoading: Whether loading is in progress.
  /// - Returns: A view with the loading environment value and disabled state applied.
  public func isLoading(_ isLoading: Bool) -> some View {
    environment(\.isLoading, isLoading)
      .disabled(isLoading)
  }
}
