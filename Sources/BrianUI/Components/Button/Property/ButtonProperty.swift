import Foundation

/// The size, tone, and optional gradient for standard button styles.
///
/// Defaults to `.medium` size and `.neutral` tone. Floating buttons use separate properties.
public struct BrianButtonProperty: Hashable, Sendable {
  public var size: Size
  public var tone: Tone
  /// A gradient that overrides `tone` on enabled buttons. `nil` uses a solid-color style.
  ///
  /// Solid uses a vivid fill, weak a subtle fill, outline a border,
  /// and ghost a subtle fill only while pressed. Does not apply to floating buttons.
  public var gradient: GradientToken.Style?

  /// Specifies size, base tone, and an optional gradient.
  public init(
    size: Size = .medium,
    tone: Tone = .neutral,
    gradient: GradientToken.Style? = nil
  ) {
    self.size = size
    self.tone = tone
    self.gradient = gradient
  }
}

extension BrianButtonProperty {
  public enum Size: CaseIterable, Hashable, Sendable {
    case xsmall
    case small
    case medium
    case large
  }

  public enum Tone: CaseIterable, Hashable, Sendable {
    case brand
    case neutral
    case critical
  }
}
