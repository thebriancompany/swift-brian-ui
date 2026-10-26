import SwiftUI

extension ButtonStyle where Self == BrianGhostButtonStyle {
  /// SwiftUI `Button`에 적용하는 배경 강조를 줄인 버튼 스타일입니다.
  ///
  /// `.buttonStyle(.ghost)`으로 사용하고, `buttonSize(_:)`와 `buttonTone(_:)`으로 조정합니다.
  public static var ghost: BrianGhostButtonStyle {
    .init()
  }
}

extension ButtonStyle where Self == BrianOutlineButtonStyle {
  /// SwiftUI `Button`에 적용하는 테두리로 구분하는 버튼 스타일입니다.
  ///
  /// `.buttonStyle(.outline)`으로 사용하고, `buttonSize(_:)`와 `buttonTone(_:)`으로 조정합니다.
  public static var outline: BrianOutlineButtonStyle {
    .init()
  }
}

extension ButtonStyle where Self == BrianSolidButtonStyle {
  /// SwiftUI `Button`에 적용하는 채워진 배경으로 강조하는 버튼 스타일입니다.
  ///
  /// `.buttonStyle(.solid)`으로 사용하고, `buttonSize(_:)`와 `buttonTone(_:)`으로 조정합니다.
  public static var solid: BrianSolidButtonStyle {
    .init()
  }
}

extension ButtonStyle where Self == BrianWeakButtonStyle {
  /// SwiftUI `Button`에 적용하는 약한 배경색을 사용하는 버튼 스타일입니다.
  ///
  /// `.buttonStyle(.weak)`으로 사용하고, `buttonSize(_:)`와 `buttonTone(_:)`으로 조정합니다.
  public static var weak: BrianWeakButtonStyle {
    .init()
  }
}
