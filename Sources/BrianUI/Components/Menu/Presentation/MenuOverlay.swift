import SwiftUI

struct BrianMenuOverlay<Content: View>: View {
  @Environment(\.theme) private var theme
  @Environment(\.menuProperty) private var property
  @Environment(\.layoutDirection) private var layoutDirection
  let anchor: CGRect
  let bounds: CGRect
  let dismiss: () -> Void
  let content: Content
  @State private var contentHeight: CGFloat = 0

  var body: some View {
    let frame = menuFrame
    ZStack(alignment: .topLeading) {
      Color.clear
        .contentShape(.rect)
        .onTapGesture(perform: dismiss)

      ScrollView {
        VStack(alignment: .leading, spacing: .zero) {
          content
        }
        .padding(.vertical, theme.spacing.small)
        .frame(maxWidth: .infinity, alignment: .leading)
        .fixedSize(horizontal: false, vertical: true)
        .background {
          GeometryReader { proxy in
            Color.clear.preference(
              key: BrianMenuHeightPreference.self, value: proxy.size.height)
          }
        }
      }
      .scrollBounceBehavior(.basedOnSize)
      .frame(width: frame.width, height: frame.height)
      .background(theme.color.background.elevated)
      .clipShape(.rect(cornerRadius: theme.radius.large))
      .overlay {
        RoundedRectangle(cornerRadius: theme.radius.large)
          .strokeBorder(theme.color.border.base.opacity(0.4), lineWidth: 0.5)
          .allowsHitTesting(false)
      }
      .shadow(theme.shadow.elevated)
      .environment(\.dismissMenu, BrianMenuDismissAction(action: dismiss))
      .environment(\.layoutDirection, layoutDirection)
      .onPreferenceChange(BrianMenuHeightPreference.self) { contentHeight = $0 }
      .position(x: frame.midX, y: frame.midY)
      .opacity(contentHeight > 0 ? 1 : 0)
    }
    .environment(\.layoutDirection, .leftToRight)
  }

  private var menuFrame: CGRect {
    let gap = theme.spacing.small
    let available = bounds.insetBy(dx: min(gap, bounds.width / 2), dy: min(gap, bounds.height / 2))
    let above = max(0, min(available.height, anchor.minY - gap - available.minY))
    let below = max(0, min(available.height, available.maxY - anchor.maxY - gap))
    let desiredHeight = min(contentHeight > 0 ? contentHeight : 480, 480)
    let prefersBottom = property.placement == .bottom
    let preferredSpace = prefersBottom ? below : above
    let oppositeSpace = prefersBottom ? above : below
    let usesPreferred = preferredSpace >= desiredHeight || preferredSpace >= oppositeSpace
    let opensBelow = usesPreferred ? prefersBottom : !prefersBottom
    let height = min(desiredHeight, opensBelow ? below : above)
    let fixedWidth: CGFloat = property.size == .small ? 200 : 240
    let width = min(property.width == .trigger ? anchor.width : fixedWidth, available.width)
    let isRTL = layoutDirection == .rightToLeft
    let proposedX: CGFloat
    switch property.alignment {
    case .leading:
      proposedX = isRTL ? anchor.maxX - width : anchor.minX

    case .center:
      proposedX = anchor.midX - width / 2

    case .trailing:
      proposedX = isRTL ? anchor.minX : anchor.maxX - width
    }
    return CGRect(
      x: min(max(proposedX, available.minX), available.maxX - width),
      y: min(
        max(opensBelow ? anchor.maxY + gap : anchor.minY - gap - height, available.minY),
        available.maxY - height),
      width: width,
      height: height
    )
  }
}

private struct BrianMenuHeightPreference: PreferenceKey {
  static let defaultValue: CGFloat = 0

  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = max(value, nextValue())
  }
}
