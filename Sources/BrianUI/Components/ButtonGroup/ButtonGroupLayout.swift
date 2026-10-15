import SwiftUI

struct BrianButtonGroupLayout: Layout {
  let spacing: CGFloat

  func sizeThatFits(
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout ()
  ) -> CGSize {
    guard subviews.count == 2 else {
      return .zero
    }
    let primary = subviews[0]
    let secondary = subviews[1]

    guard let width = proposal.width, width.isFinite else {
      return idealSize(
        primary: primary,
        secondary: secondary
      )
    }

    if fitsHorizontally(
      width: width,
      primary: primary,
      secondary: secondary
    ) {
      return horizontalSize(
        width: width,
        primary: primary,
        secondary: secondary
      )
    } else {
      return verticalSize(
        width: width,
        primary: primary,
        secondary: secondary
      )
    }
  }

  func placeSubviews(
    in bounds: CGRect,
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout ()
  ) {
    guard subviews.count == 2 else {
      return
    }
    let primary = subviews[0]
    let secondary = subviews[1]

    if fitsHorizontally(
      width: bounds.width,
      primary: primary,
      secondary: secondary
    ) {
      placeHorizontally(
        in: bounds,
        primary: primary,
        secondary: secondary
      )
    } else {
      placeVertically(
        in: bounds,
        primary: primary,
        secondary: secondary
      )
    }
  }
}

extension BrianButtonGroupLayout {
  private func fitsHorizontally(
    width: CGFloat,
    primary: LayoutSubview,
    secondary: LayoutSubview
  ) -> Bool {
    let itemWidth = max(0, (width - spacing) / 2)
    let primaryIdeal = primary.sizeThatFits(.unspecified)
    let secondaryIdeal = secondary.sizeThatFits(.unspecified)
    return primaryIdeal.width <= itemWidth && secondaryIdeal.width <= itemWidth
  }

  private func horizontalSize(
    width: CGFloat,
    primary: LayoutSubview,
    secondary: LayoutSubview
  ) -> CGSize {
    let itemWidth = max(0, (width - spacing) / 2)
    let proposal = ProposedViewSize(width: itemWidth, height: nil)
    let primarySize = primary.sizeThatFits(proposal)
    let secondarySize = secondary.sizeThatFits(proposal)
    return .init(
      width: width,
      height: max(
        primarySize.height,
        secondarySize.height
      )
    )
  }

  /// Secondary -> Primary 순으로 배치
  private func placeHorizontally(
    in bounds: CGRect,
    primary: LayoutSubview,
    secondary: LayoutSubview
  ) {
    let itemWidth = max(0, (bounds.width - spacing) / 2)
    let proposal = ProposedViewSize(width: itemWidth, height: nil)
    secondary.place(
      at: .init(
        x: bounds.minX,
        y: bounds.midY
      ),
      anchor: .leading,
      proposal: proposal
    )
    primary.place(
      at: .init(
        x: bounds.minX + itemWidth + spacing,
        y: bounds.midY
      ),
      anchor: .leading,
      proposal: proposal
    )
  }
}

extension BrianButtonGroupLayout {
  private func verticalSize(
    width: CGFloat,
    primary: LayoutSubview,
    secondary: LayoutSubview
  ) -> CGSize {
    let proposal = ProposedViewSize(width: width, height: nil)
    let primarySize = primary.sizeThatFits(proposal)
    let secondarySize = secondary.sizeThatFits(proposal)
    let height = primarySize.height + spacing + secondarySize.height
    return .init(
      width: width,
      height: height
    )
  }

  /// Primary -> Secondary 순으로 배치
  private func placeVertically(
    in bounds: CGRect,
    primary: LayoutSubview,
    secondary: LayoutSubview
  ) {
    let proposal = ProposedViewSize(width: bounds.width, height: nil)
    let primarySize = primary.sizeThatFits(proposal)
    primary.place(
      at: .init(
        x: bounds.minX,
        y: bounds.minY
      ),
      anchor: .topLeading,
      proposal: proposal
    )
    secondary.place(
      at: .init(
        x: bounds.minX,
        y: bounds.minY
          + primarySize.height
          + spacing
      ),
      anchor: .topLeading,
      proposal: proposal
    )
  }
}

extension BrianButtonGroupLayout {
  private func idealSize(
    primary: LayoutSubview,
    secondary: LayoutSubview
  ) -> CGSize {
    let primarySize = primary.sizeThatFits(.unspecified)
    let secondarySize = secondary.sizeThatFits(.unspecified)
    let width = primarySize.width + spacing + secondarySize.width
    let height = max(primarySize.height, secondarySize.height)
    return .init(
      width: width,
      height: height
    )
  }
}
