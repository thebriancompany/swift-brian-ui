import SwiftUI

extension EnvironmentValues {
  @Entry var chipProperty = BrianChipProperty()
}

extension View {
  /// 하위 칩의 크기, 스타일과 배치를 함께 교체합니다.
  public func chipProperty(_ property: BrianChipProperty) -> some View {
    environment(\.chipProperty, property)
  }

  /// 나머지 설정을 유지하면서 하위 칩의 크기를 변경합니다.
  public func chipSize(_ size: BrianChipProperty.Size) -> some View {
    transformEnvironment(\.chipProperty) { $0.size = size }
  }

  /// 나머지 설정을 유지하면서 하위 칩의 선택 상태 표현을 변경합니다.
  public func chipVariant(_ variant: BrianChipProperty.Variant) -> some View {
    transformEnvironment(\.chipProperty) { $0.variant = variant }
  }

  /// 하위 칩의 최소 너비를 콘텐츠 배치에 맞게 변경합니다.
  ///
  /// `.iconOnly`는 텍스트를 자동으로 숨기지 않습니다. `Label`에 `.labelStyle(.iconOnly)`를 적용하세요.
  public func chipLayout(_ layout: BrianChipProperty.Layout) -> some View {
    transformEnvironment(\.chipProperty) { $0.layout = layout }
  }
}
