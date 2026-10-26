import SwiftUI

extension EnvironmentValues {
  @Entry var buttonProperty = BrianButtonProperty()
}

extension View {
  /// 하위 기본 버튼의 크기와 색상 역할을 함께 설정합니다.
  public func buttonProperty(_ property: BrianButtonProperty) -> some View {
    environment(\.buttonProperty, property)
  }

  /// 하위 기본 버튼의 크기만 변경하고 색상 역할은 유지합니다.
  public func buttonSize(_ size: BrianButtonProperty.Size) -> some View {
    transformEnvironment(\.buttonProperty) { $0.size = size }
  }

  /// 하위 기본 버튼의 색상 역할만 변경하고 크기는 유지합니다.
  public func buttonTone(_ tone: BrianButtonProperty.Tone) -> some View {
    transformEnvironment(\.buttonProperty) { $0.tone = tone }
  }
}
