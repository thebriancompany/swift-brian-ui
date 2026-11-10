import SwiftUI

extension EnvironmentValues {
  @Entry var isLoading: Bool = false
}

extension View {
  /// Passes loading state to descendants and disables interaction while loading.
  ///
  /// The `.brian(...)` and `.floating` button styles replace their labels with a spinner.
  /// The `.press` style suppresses press feedback but leaves loading content to the caller.
  /// Does not add a spinner to arbitrary views or start asynchronous work.
  ///
  /// - Parameter isLoading: Whether loading is in progress.
  /// - Returns: A view with the loading environment value and disabled state applied.
  public func isLoading(_ isLoading: Bool) -> some View {
    environment(\.isLoading, isLoading)
      .disabled(isLoading)
  }
}
