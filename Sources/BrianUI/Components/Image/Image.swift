import BrianSymbols
import SwiftUI

extension Image {
  /// Specifies an icon from BrianSymbols or SF Symbols.
  public enum Style: Hashable, Sendable {
    /// A typed symbol provided by BrianSymbols.
    case symbol(BrianSymbol)
    /// An SF Symbols icon specified by name.
    case system(String)
  }

  /// Creates an image from the specified icon source.
  public init(style: Style) {
    switch style {
    case let .symbol(symbol):
      self = .init(brianSymbol: symbol)

    case let .system(name):
      self = .init(systemName: name)
    }
  }

  /// Creates an image from a BrianSymbols symbol.
  public init(symbol: BrianSymbol) {
    self = .init(brianSymbol: symbol)
  }
}

extension Image.Style {
  /// Converts an optional symbol. Returns `nil` when the input is `nil`.
  public init?(symbol: BrianSymbol?) {
    guard let symbol else {
      return nil
    }
    self = .symbol(symbol)
  }

  /// Converts an optional SF Symbols name. Returns `nil` when the input is `nil`.
  public init?(systemName name: String?) {
    guard let name else {
      return nil
    }
    self = .system(name)
  }
}
