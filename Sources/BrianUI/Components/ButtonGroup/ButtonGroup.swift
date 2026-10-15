import SwiftUI

/// 내부 컨텐츠의 크기에 따라 레이아웃이 변경되는 버튼 그룹 컴포넌트입니다.
///
/// 두 버튼의 이상적인 너비가 주어진 폭에 들어가면 가로로, 그렇지 않으면 세로로 배치합니다.
/// 가로 배치는 secondary → primary, 세로 배치는 primary → secondary 순서입니다.
///
/// 버튼을 추가할 때는 내부 영역을 infinite로 설정하여 컨텐츠를 꽉 채우는 것을 권장합니다.
///
/// ```swift
/// BrianButtonGroup {
///   Button {
///
///   } label: {
///     Text("Primary Solid")
///       .frame(maxWidth: .infinity)
///   }
///   .buttonStyle(.solid)
/// } secondary: {
///   Button {
///
///   } label: {
///     Text("Secondary Outline")
///       .frame(maxWidth: .infinity)
///   }
///   .buttonStyle(.outline)
/// }
/// ```
public struct BrianButtonGroup<Primary: View, Secondary: View>: View {
  @Environment(\.theme) private var theme
  private let primary: Primary
  private let secondary: Secondary

  public init(
    @ViewBuilder primary: () -> Primary,
    @ViewBuilder secondary: () -> Secondary
  ) {
    self.primary = primary()
    self.secondary = secondary()
  }

  public var body: some View {
    BrianButtonGroupLayout(
      spacing: theme.spacing.medium
    ) {
      primary
        .frame(maxWidth: .infinity)

      secondary
        .frame(maxWidth: .infinity)
    }
  }
}
