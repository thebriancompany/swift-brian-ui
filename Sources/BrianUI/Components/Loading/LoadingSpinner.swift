import SwiftUI

public struct BrianLoadingSpinner: View {
  private let size: CGFloat
  private let lineWidth: CGFloat

  public init(
    size: CGFloat = 20,
    lineWidth: CGFloat? = nil
  ) {
    self.size = max(0, size)
    self.lineWidth = min(max(0, lineWidth ?? size / 10), max(0, size))
  }

  public var body: some View {
    GeometryReader { geometry in
      let diameter = max(0, min(size, geometry.size.width, geometry.size.height))
      let strokeWidth = size > 0 ? lineWidth * diameter / size : 0

      spinner(lineWidth: strokeWidth)
        .frame(width: diameter, height: diameter)
        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
    }
    .frame(idealWidth: size, maxWidth: size, idealHeight: size, maxHeight: size)
  }

  private func spinner(lineWidth: CGFloat) -> some View {
    arc(from: 0, to: 0.25, lineWidth: lineWidth)
      .keyframeAnimator(initialValue: AnimationValues(), repeating: true) { _, value in
        arc(from: value.start, to: value.end, lineWidth: lineWidth)
          .rotationEffect(.degrees(value.rotation))
      } keyframes: { _ in
        KeyframeTrack(\.rotation) {
          LinearKeyframe(180, duration: 1.4)
        }
        KeyframeTrack(\.start) {
          CubicKeyframe(0, duration: 0.7, startVelocity: 0, endVelocity: 0)
          CubicKeyframe(0.5, duration: 0.7, startVelocity: 0, endVelocity: 0)
        }
        KeyframeTrack(\.end) {
          CubicKeyframe(0.75, duration: 0.7, startVelocity: 0, endVelocity: 0)
          CubicKeyframe(0.75, duration: 0.7, startVelocity: 0, endVelocity: 0)
        }
      }
  }

  nonisolated private func arc(
    from start: CGFloat,
    to end: CGFloat,
    lineWidth: CGFloat
  ) -> some View {
    Circle()
      .trim(from: start, to: end)
      .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
      .padding(lineWidth / 2)
      .rotationEffect(.degrees(-90))
  }

  private struct AnimationValues {
    var rotation: Double = 0
    var start: CGFloat = 0
    var end: CGFloat = 0.25
  }
}
