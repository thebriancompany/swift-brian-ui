import SwiftUI

/// A centered, snapping wheel shared by the date and time columns.
struct BrianDatePickerWheel<Value: Hashable>: View {
  @Environment(\.theme) private var theme
  @Environment(\.isEnabled) private var isEnabled
  @State private var position: Value?
  @State private var phase = ScrollPhase.idle

  let values: [Value]
  let selection: Value
  let onSelect: (Value) -> Void

  private let labels: [Value: String]
  private let rowHeight: CGFloat = 44

  init(
    values: [Value],
    selection: Value,
    text: (Value) -> String,
    onSelect: @escaping (Value) -> Void
  ) {
    self.values = values
    self.selection = selection
    self.labels = Dictionary(uniqueKeysWithValues: values.map { ($0, text($0)) })
    self.onSelect = onSelect
  }

  var body: some View {
    ScrollView(.vertical) {
      // Eager layout keeps row offsets stable during fast scrolling and direction changes.
      VStack(spacing: .zero) {
        ForEach(values, id: \.self) { value in
          Button {
            rowTapped(value)
          } label: {
            Text(labels[value] ?? "")
              .typography(theme.typography.title.small)
              .fontWeight(value == position ? .semibold : .regular)
              .lineLimit(1)
              .minimumScaleFactor(0.5)
              .foregroundStyle(foregroundColor(for: value))
              .frame(maxWidth: .infinity)
              .frame(height: rowHeight)
              .contentShape(Rectangle())
          }
          .buttonStyle(.plain)
          .id(value)
        }
      }
      .scrollTargetLayout()
    }
    .safeAreaPadding(.vertical, rowHeight * 2)
    .scrollIndicators(.hidden)
    .scrollTargetBehavior(.viewAligned)
    .scrollPosition(id: $position, anchor: .center)
    .scrollDisabled(!isEnabled)
    .frame(height: rowHeight * 5)
    .background {
      RoundedRectangle(cornerRadius: theme.radius.medium)
        .fill(theme.color.background.subtle)
        .frame(height: rowHeight)
    }
    .mask {
      LinearGradient(
        stops: [
          .init(color: .clear, location: 0),
          .init(color: .black, location: 0.3),
          .init(color: .black, location: 0.7),
          .init(color: .clear, location: 1)
        ],
        startPoint: .top,
        endPoint: .bottom
      )
    }
    .onAppear {
      position = selection
    }
    .onChange(of: selection) { _, value in
      if position != value {
        position = value
      }
    }
    .onChange(of: values) { _, values in
      if let position, !values.contains(position) {
        self.position = selection
      }
    }
    .onScrollPhaseChange { _, newPhase in
      phase = newPhase
      if newPhase == .idle {
        commitPosition()
      }
    }
  }

  private func foregroundColor(for value: Value) -> Color {
    guard isEnabled else {
      return theme.color.foreground.disabled
    }
    return value == position ? theme.color.foreground.primary : theme.color.foreground.secondary
  }

  private func rowTapped(_ value: Value) {
    guard isEnabled else {
      return
    }

    withAnimation(.easeOut(duration: 0.2)) {
      position = value
    }
    onSelect(value)
  }

  private func commitPosition() {
    guard
      isEnabled,
      phase == .idle,
      let position,
      position != selection,
      values.contains(position)
    else {
      return
    }
    onSelect(position)
  }
}
