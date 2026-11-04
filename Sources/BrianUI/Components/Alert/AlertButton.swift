import SwiftUI

/// An action button connected to BrianUI alert dismissal.
///
/// By default, passes the action to the presentation's dismissal handler.
/// Outside an alert environment, runs only the action.
public struct BrianAlertButton<S: StringProtocol>: View {
  @Environment(\.alertPresentation) private var presentation
  private let content: S
  private let dismissOnAction: Bool
  private let action: () -> Void

  /// Creates an alert action button.
  ///
  /// - Parameters:
  ///   - content: The text to display in the button.
  ///   - dismissOnAction: Whether tapping dismisses the alert. Defaults to `true`.
  ///     When `false`, only the action runs; the caller updates the presentation binding when needed.
  ///   - action: The task to perform when the button is tapped.
  public init(
    _ content: S,
    dismissOnAction: Bool = true,
    action: @escaping () -> Void
  ) {
    self.content = content
    self.dismissOnAction = dismissOnAction
    self.action = action
  }

  public var body: some View {
    Button(action: buttonTapped) {
      Text(content)
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
    }
  }

  private func buttonTapped() {
    guard let presentation else {
      action()
      return
    }
    if dismissOnAction {
      presentation.performAction(action)
    } else {
      action()
    }
  }
}
