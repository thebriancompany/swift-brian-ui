import SwiftUI

extension View {
  /// Presents a BrianUI bottom sheet at the bottom of the screen.
  ///
  /// Deduplicates and sorts valid snap points, starting at the lowest point.
  /// Without valid points, fits the content height up to the screen's permitted maximum height.
  ///
  /// - Parameters:
  ///   - isPresented: The presentation state. Changing it to `false` dismisses the sheet.
  ///   - snapPoints: Heights where the sheet stops. Defaults to an empty array.
  ///   - isDismissible: Whether background taps or downward dragging can dismiss the sheet.
  ///     Even when `false`, binding changes or the close button can dismiss it.
  ///   - content: The content displayed in the sheet.
  /// - Returns: A view connected to a bottom sheet presenter.
  public func bottomSheet<SheetContent: View>(
    isPresented: Binding<Bool>,
    snapPoints: [BrianBottomSheetSnapPoint] = [],
    isDismissible: Bool = true,
    @ViewBuilder content: @escaping () -> SheetContent
  ) -> some View {
    background {
      BrianBottomSheetPresenter(isPresented: isPresented) { presentation in
        BrianBottomSheetStage(
          isPresented: isPresented,
          presentation: presentation,
          snapPoints: snapPoints,
          isDismissible: isDismissible,
          content: content()
        )
        .onAppear {
          presentation.didAppear()
        }
      }
      .frame(width: 0, height: 0)
    }
  }
}

private struct BrianBottomSheetStage<Content: View>: View {
  @Environment(\.theme) private var theme
  @Environment(\.bottomSheetShowsHandle) private var showsHandle

  @Binding var isPresented: Bool
  let presentation: BrianBottomSheetPresentation
  let snapPoints: [BrianBottomSheetSnapPoint]
  let isDismissible: Bool
  let content: Content

  @State private var selectedHeight: CGFloat?
  @State private var drag: CGFloat = 0
  @State private var restingSize: CGSize = .zero
  @State private var restingBottomInset: CGFloat = 0

  var body: some View {
    GeometryReader { proxy in
      let totalHeight = restingSize.height > 0
        ? restingSize.height + restingBottomInset
        : proxy.size.height + proxy.safeAreaInsets.bottom
      let keyboardIsVisible = restingSize.height > proxy.size.height + 1 || proxy.safeAreaInsets.bottom > restingBottomInset + 1
      let maximum = max(0, min(totalHeight * 0.9, proxy.size.height))
      let bottomInset = keyboardIsVisible ? 0 : restingBottomInset
      let heights = Array(
        Set(
          snapPoints.compactMap {
            $0.resolved(in: totalHeight, maximum: max(0, totalHeight * 0.9))
          }
        )
      ).sorted()
      let height: CGFloat? = keyboardIsVisible ? nil : (heights.isEmpty ? nil : min(selectedHeight ?? heights[0], maximum))

      ZStack(alignment: .bottom) {
        theme.color.background.overlay
          .opacity(presentation.isVisible ? 1 : 0)
          .ignoresSafeArea()
          .contentShape(.rect)
          .onTapGesture {
            if isDismissible {
              isPresented = false
            }
          }

        BrianBottomSheetCardLayout(fitsContent: heights.isEmpty || keyboardIsVisible) {
          card(
            heights: heights,
            height: height,
            bottomInset: bottomInset
          )
        }
        .frame(maxWidth: 480)
        .frame(height: height.map { max(0, min(maximum, $0 - drag)) })
        .frame(maxHeight: maximum, alignment: .bottom)
        .offset(
          y: presentation.isVisible ? (height == nil && isDismissible ? max(0, drag) : 0) : totalHeight
        )
        .padding(.bottom, -bottomInset)
        .onChange(of: heights) { _, newValue in
          selectedHeight = newValue.min(by: {
            abs($0 - (selectedHeight ?? 0)) < abs($1 - (selectedHeight ?? 0))
          })
        }
        .modifier(
          BrianBottomSheetDragModifier(
            isEnabled: isDismissible || (!keyboardIsVisible && heights.count > 1),
            onChanged: { translation in
              dragChanged(translation, heights: heights, height: height)
            },
            onEnded: { translation in
              dragEnded(translation, heights: heights, height: height)
            }
          )
        )
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
    .background {
      GeometryReader { _ in
        Color.clear
          .onGeometryChange(for: CGSize.self, of: \.size) { size in
            restingSize = size
          }
          .onGeometryChange(for: CGFloat.self, of: \.safeAreaInsets.bottom) { inset in
            restingBottomInset = inset
          }
      }
      .ignoresSafeArea(.keyboard)
    }
  }

  private func card(heights: [CGFloat], height: CGFloat?, bottomInset: CGFloat) -> some View {
    VStack(spacing: .zero) {
      if showsHandle || !heights.isEmpty {
        handle
      }
      
      content
        .environment(\.bottomSheetIsPresented, $isPresented)
    }
    .padding(.bottom, bottomInset)
    .frame(maxWidth: .infinity)
    .frame(height: height.map { max(0, $0 - drag) }, alignment: .top)
    .background(theme.color.background.base)
    .clipShape(
      .rect(
        topLeadingRadius: theme.radius.xLarge,
        topTrailingRadius: theme.radius.xLarge
      )
    )
  }

  private var handle: some View {
    Capsule()
      .fill(theme.color.foreground.tertiary)
      .frame(width: 36, height: 4)
      .frame(maxWidth: .infinity)
      .frame(height: 25)
      .contentShape(.rect)
  }

  private func dragChanged(_ translation: CGFloat, heights: [CGFloat], height: CGFloat?) {
    var transaction = Transaction()
    transaction.disablesAnimations = true
    withTransaction(transaction) {
      if let height, let maximum = heights.last {
        let downwardLimit = isDismissible ? height : max(0, height - (heights.first ?? height))
        drag = max(height - maximum, min(translation, downwardLimit))
      } else if isDismissible {
        drag = max(0, translation)
      }
    }
  }

  private func dragEnded(_ translation: CGFloat?, heights: [CGFloat], height: CGFloat?) {
    withAnimation(.easeOut(duration: 0.25)) {
      drag = 0
      guard let translation else { return }
      if let height, let minimum = heights.first {
        let proposed = height - translation
        if isDismissible && proposed < minimum / 2 {
          isPresented = false
        } else {
          selectedHeight = heights.min(by: { abs($0 - proposed) < abs($1 - proposed) })
        }
      } else if isDismissible && translation > 80 {
        isPresented = false
      }
    }
  }
}

private struct BrianBottomSheetCardLayout: Layout {
  let fitsContent: Bool

  func sizeThatFits(
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout ()
  ) -> CGSize {
    guard let card = subviews.first else {
      return .zero
    }
    guard fitsContent else {
      return card.sizeThatFits(proposal)
    }
    let ideal = card.sizeThatFits(ProposedViewSize(width: proposal.width, height: nil))
    return CGSize(
      width: ideal.width,
      height: min(ideal.height, proposal.height ?? ideal.height)
    )
  }

  func placeSubviews(
    in bounds: CGRect,
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout ()
  ) {
    subviews.first?.place(
      at: bounds.origin,
      anchor: .topLeading,
      proposal: ProposedViewSize(bounds.size)
    )
  }
}
