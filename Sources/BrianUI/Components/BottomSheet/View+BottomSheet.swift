import SwiftUI

extension View {
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

  var body: some View {
    GeometryReader { proxy in
      let totalHeight = proxy.size.height + proxy.safeAreaInsets.bottom
      let maximum = max(0, min(totalHeight * 0.9, proxy.size.height))
      let heights = Array(
        Set(
          snapPoints.compactMap {
            $0.resolved(in: totalHeight, maximum: maximum)
          }
        )
      ).sorted()
      let height = heights.isEmpty ? nil : min(selectedHeight ?? heights[0], maximum)

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

        ViewThatFits(in: .vertical) {
          if heights.isEmpty {
            card(
              heights: heights,
              height: height,
              bottomInset: proxy.safeAreaInsets.bottom
            )
            .fixedSize(horizontal: false, vertical: true)
          }

          card(
            heights: heights,
            height: height,
            bottomInset: proxy.safeAreaInsets.bottom
          )
        }
        .frame(maxWidth: 480)
        .frame(height: height.map { max(0, min(maximum, $0 - drag)) })
        .frame(maxHeight: maximum, alignment: .bottom)
        .offset(
          y: presentation.isVisible ? (heights.isEmpty && isDismissible ? max(0, drag) : 0) : totalHeight
        )
        .padding(.bottom, -proxy.safeAreaInsets.bottom)
        .onChange(of: heights) { _, newValue in
          selectedHeight = newValue.min(by: {
            abs($0 - (selectedHeight ?? 0)) < abs($1 - (selectedHeight ?? 0))
          })
        }
        .modifier(
          BrianBottomSheetDragModifier(
            isEnabled: isDismissible || heights.count > 1,
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
