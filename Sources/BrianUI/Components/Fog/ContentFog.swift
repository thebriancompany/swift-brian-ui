import SwiftUI

/// 컨텐츠 영역의 위/아래 경계를 자연스럽게 노출시키기 위한 Gradient입니다.
///
/// 테마의 background base 색상을 사용합니다.
///
/// Direction에는 up, down 값이 존재합니다.
/// up은 위로 가면서 점차 옅어집니다.
/// down은 아래로 가면서 점차 옅어집니다.
///
/// ```swift
/// Rectangle()
///   .fill(.pink)
///   .frame(height: 100)
///   .frame(maxWidth: .infinity)
///   .overlay(alignment: .top) {
///     BrianContentFog(direction: .down)
///       .frame(height: 40)
///   }
///   .overlay(alignment: .bottom) {
///     BrianContentFog(direction: .up)
///       .frame(height: 40)
///   }
/// ```
public struct BrianContentFog: View {
  public enum Direction: Hashable, Sendable {
    /// 아래쪽 배경색에서 위쪽으로 갈수록 투명해집니다.
    case up
    /// 위쪽 배경색에서 아래쪽으로 갈수록 투명해집니다.
    case down
  }

  @Environment(\.theme) private var theme

  private let direction: Direction
  private let color: Color?
  private var backgroundColor: Color {
    if let color {
      return color
    }
    return theme.color.background.base
  }

  public init(
    direction: Direction = .up,
    color: Color? = nil
  ) {
    self.direction = direction
    self.color = color
  }

  public var body: some View {
    LinearGradient(
      colors: colors,
      startPoint: .top,
      endPoint: .bottom
    )
    .allowsHitTesting(false)
  }

  private var colors: [Color] {
    switch direction {
    case .up:
      return [
        backgroundColor.opacity(0),
        backgroundColor,
      ]

    case .down:
      return [
        backgroundColor,
        backgroundColor.opacity(0),
      ]
    }
  }
}
