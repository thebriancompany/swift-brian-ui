import SwiftUI

extension EnvironmentValues {
  @Entry var isLoading: Bool = false
}

extension View {
  /// 로딩 상태를 하위 뷰에 전달하고 로딩 중 상호작용을 비활성화합니다.
  ///
  /// 로딩 표현은 이 환경값을 읽는 BrianUI 버튼 스타일에서 제공됩니다.
  /// 임의의 뷰에 스피너를 추가하거나 비동기 작업을 시작하지 않습니다.
  ///
  /// - Parameter isLoading: 로딩 중인지 여부입니다.
  /// - Returns: 로딩 환경과 비활성화 상태가 적용된 뷰입니다.
  public func isLoading(_ isLoading: Bool) -> some View {
    environment(\.isLoading, isLoading)
      .disabled(isLoading)
  }
}
