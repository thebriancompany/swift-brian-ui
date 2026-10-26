import SwiftUI

/// 알림의 액션 뷰 한 개 또는 두 개를 배치하는 결과 빌더입니다.
///
/// 첫 번째 뷰에는 `.solid`, 두 번째 뷰에는 `.weak` 스타일을 적용합니다.
/// 두 개일 때는 ``BrianButtonGroup``으로 배치하며 모두 `.large` 크기를 사용합니다.
/// 세 개 이상의 직접적인 액션이나 조건 분기를 위한 빌더 메서드는 제공하지 않습니다.
@MainActor
@resultBuilder
public struct BrianAlertFooter {
  public static func buildBlock<Primary: View>(_ primary: Primary) -> some View {
    primary
      .buttonStyle(.solid)
      .buttonSize(.large)
  }

  public static func buildBlock<Primary: View, Secondary: View>(
    _ primary: Primary,
    _ secondary: Secondary
  ) -> some View {
    BrianButtonGroup {
      primary
        .buttonStyle(.solid)
        .buttonSize(.large)
    } secondary: {
      secondary
        .buttonStyle(.weak)
        .buttonSize(.large)
    }
  }
}
