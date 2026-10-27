import SwiftUI

extension EnvironmentValues {
  @Entry var buttonProperty = BrianButtonProperty()
}

extension View {
  /// 하위 기본 버튼의 크기, 색상 역할과 그라디언트 설정을 함께 교체합니다.
  public func buttonProperty(_ property: BrianButtonProperty) -> some View {
    environment(\.buttonProperty, property)
  }

  /// 하위 기본 버튼의 크기만 변경하고 나머지 설정은 유지합니다.
  public func buttonSize(_ size: BrianButtonProperty.Size) -> some View {
    transformEnvironment(\.buttonProperty) { $0.size = size }
  }

  /// 하위 기본 버튼의 색상 역할만 변경하고 나머지 설정은 유지합니다.
  /// 그라디언트가 설정되어 있으면 활성 상태에서 그라디언트가 우선합니다.
  public func buttonTone(_ tone: BrianButtonProperty.Tone) -> some View {
    transformEnvironment(\.buttonProperty) { $0.tone = tone }
  }

  /// 하위 기본 버튼에 표현용 그라디언트를 선택적으로 적용합니다.
  ///
  /// solid는 선명한 채움, weak는 은은한 채움, outline은 테두리로 표시합니다.
  /// ghost는 눌렀을 때만 은은한 채움을 표시합니다. 텍스트와 로딩 표시는 단색으로 유지합니다.
  /// 비활성 상태는 기존 비활성 색상을 사용하고, 로딩 중에는 기존 스타일처럼 활성 색상을 유지합니다.
  ///
  /// - Parameter style: 사용할 팔레트입니다. `nil`은 상위에서 상속한 그라디언트를 해제합니다.
  /// - Returns: 크기와 색상 역할을 유지하면서 그라디언트 설정을 변경한 뷰입니다.
  public func buttonGradient(_ style: GradientToken.Style?) -> some View {
    transformEnvironment(\.buttonProperty) { $0.gradient = style }
  }
}
