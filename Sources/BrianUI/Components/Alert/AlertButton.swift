import SwiftUI

public struct BrianAlertButton<S: StringProtocol>: View {
  @Environment(\.alertPresentation) private var presentation
  private let content: S
  private let dismissOnAction: Bool
  private let action: () -> Void

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
