import BrianSymbols
import SwiftUI

extension Image {
  /// BrianSymbols와 SF Symbols 중 표시할 아이콘을 지정합니다.
  public enum Style: Hashable, Sendable {
    /// BrianSymbols에서 제공하는 타입 심볼입니다.
    case symbol(BrianSymbol)
    /// 이름으로 지정하는 SF Symbols 아이콘입니다.
    case system(String)
  }

  /// 지정한 아이콘 종류로 이미지를 만듭니다.
  public init(style: Style) {
    switch style {
    case let .symbol(symbol):
      self = .init(brianSymbol: symbol)

    case let .system(name):
      self = .init(systemName: name)
    }
  }

  /// BrianSymbols 심볼로 이미지를 만듭니다.
  public init(symbol: BrianSymbol) {
    self = .init(brianSymbol: symbol)
  }
}

extension Image.Style {
  /// 선택적인 심볼을 변환합니다. 입력이 `nil`이면 `nil`을 반환합니다.
  public init?(symbol: BrianSymbol?) {
    guard let symbol else {
      return nil
    }
    self = .symbol(symbol)
  }

  /// 선택적인 SF Symbols 이름을 변환합니다. 입력이 `nil`이면 `nil`을 반환합니다.
  public init?(systemName name: String?) {
    guard let name else {
      return nil
    }
    self = .system(name)
  }
}
