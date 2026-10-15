import SwiftUI

extension EnvironmentValues {
  @Entry var isLoading: Bool = false
}

extension View {
  /// Displays the loading state and disables interaction while loading.
  public func isLoading(_ isLoading: Bool) -> some View {
    environment(\.isLoading, isLoading)
      .disabled(isLoading)
  }
}
