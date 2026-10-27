import Foundation

/// 히어로, 콘텐츠 커버와 강조 카드에 사용하는 다색 그라디언트 토큰입니다.
///
/// 성공·경고·오류 등의 상태는 기존 ``ColorToken``으로 표현합니다.
public struct GradientToken: Hashable, Sendable {
  /// 시안, 블루, 라일락과 핑크가 섞이는 팔레트입니다.
  public var aurora: GradientPalette
  /// 피치, 코랄, 라벤더와 따뜻한 빛이 섞이는 팔레트입니다.
  public var sunset: GradientPalette
  /// 민트, 스카이 블루와 부드러운 그린이 섞이는 팔레트입니다.
  public var lagoon: GradientPalette

  /// 세 가지 표현용 팔레트를 지정합니다.
  public init(aurora: GradientPalette, sunset: GradientPalette, lagoon: GradientPalette) {
    self.aurora = aurora
    self.sunset = sunset
    self.lagoon = lagoon
  }

  /// 이름으로 그라디언트 팔레트를 읽거나 교체합니다.
  public subscript(style: Style) -> GradientPalette {
    get {
      switch style {
      case .aurora: aurora
      case .sunset: sunset
      case .lagoon: lagoon
      }
    }
    set {
      switch style {
      case .aurora: aurora = newValue
      case .sunset: sunset = newValue
      case .lagoon: lagoon = newValue
      }
    }
  }
}

extension GradientToken {
  /// 테마에서 선택할 표현용 그라디언트의 이름입니다.
  public enum Style: CaseIterable, Hashable, Sendable {
    /// 시안·블루·라일락·핑크 조합입니다.
    case aurora
    /// 피치·코랄·라벤더 조합입니다.
    case sunset
    /// 민트·블루·그린 조합입니다.
    case lagoon
  }
}
