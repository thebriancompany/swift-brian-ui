import SwiftUI

/// BrianUI 알림의 닫기 동작과 연결되는 액션 버튼입니다.
///
/// 기본적으로 프레젠테이션의 닫기 처리에 액션을 전달합니다.
/// 알림 환경 밖에서는 액션만 실행합니다.
public struct BrianAlertButton<S: StringProtocol>: View {
  @Environment(\.alertPresentation) private var presentation
  private let content: S
  private let dismissOnAction: Bool
  private let action: () -> Void

  /// 알림 액션 버튼을 만듭니다.
  ///
  /// - Parameters:
  ///   - content: 버튼에 표시할 문자열입니다.
  ///   - dismissOnAction: 탭 시 알림을 닫을지 여부입니다. 기본값은 `true`입니다.
  ///     `false`이면 액션만 실행하므로 호출자가 필요한 시점에 표시 바인딩을 변경합니다.
  ///   - action: 버튼을 눌렀을 때 실행할 작업입니다.
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
