import BrianSymbols
import SwiftUI

/// A BrianUI calendar and time selector backed by caller-owned state.
///
/// Day and wheel-row taps update `selection` immediately; wheel scrolling updates it when it settles.
/// Paging browses months without changing selection. Year/month wheels open at the selected date.
/// Changing year/month preserves the day and time where possible, clamping to the target month and era.
/// Nonexistent local times advance to the calendar's next valid time.
///
/// On appearance, range changes, and external selection changes, an out-of-range value is
/// clamped to the nearest bound. This also applies when the control is disabled.
/// Keep bounds stable during binding updates; capture a time-based lower bound when editing begins.
///
/// The calendar, time zone, and locale come from the environment. Time wheels use 24-hour values.
/// Month and year lists expand as you navigate; they do not impose an additional year range.
/// See <doc:Forms> for layout examples and save/cancel flows.
public struct BrianDatePicker<Label: View>: View {
  @Environment(\.isEnabled) private var isEnabled
  @Environment(\.theme) private var theme
  @Environment(\.calendar) private var environmentCalendar
  @Environment(\.timeZone) private var timeZone
  @Environment(\.locale) private var locale
  @Binding private var selection: Date
  @State private var visibleMonth: Date
  @State private var scrollMonth: Date?
  @State private var monthPages: [Date] = []
  @State private var activePanel = Panel.calendar

  @State private var showsDate = false
  @State private var showsTime = false

  private var hidesLabel = false
  private var usesCompactStyle = false

  private let label: Label
  private let displayedComponents: DatePickerComponents
  private var dayHeight: CGFloat { usesCompactStyle ? 36 : 44 }
  private var calendarSpacing: CGFloat { usesCompactStyle ? theme.spacing.small : theme.spacing.large }
  private var daySpacing: CGFloat { usesCompactStyle ? theme.spacing.xSmall : theme.spacing.small }
  private let weekdayHeight: CGFloat = 20
  private var lowerBound: Date?
  private var upperBound: Date?

  private enum Panel {
    case calendar
    case month
    case time
  }

  /// Creates a calendar and time selector with a custom label and no date bounds.
  ///
  /// - Parameters:
  ///   - selection: The caller-owned date to display and update.
  ///   - displayedComponents: The controls to show. Defaults to both date and time.
  ///   - label: Content identifying the control.
  public init(
    selection: Binding<Date>,
    displayedComponents: DatePickerComponents = [.date, .hourAndMinute],
    @ViewBuilder label: () -> Label
  ) {
    self._selection = selection
    self._visibleMonth = State(initialValue: selection.wrappedValue)
    self.displayedComponents = displayedComponents
    self.label = label()
  }

  /// Creates a selector whose allowed dates include both range boundaries.
  ///
  /// - Parameters:
  ///   - selection: The caller-owned date, clamped to `range` on appearance and updates.
  ///   - range: Allowed instants, including time and seconds at each boundary.
  ///   - displayedComponents: The controls to show. Defaults to both date and time.
  ///   - label: Content identifying the control.
  public init(
    selection: Binding<Date>,
    in range: ClosedRange<Date>,
    displayedComponents: DatePickerComponents = [.date, .hourAndMinute],
    @ViewBuilder label: () -> Label
  ) {
    self.init(selection: selection, displayedComponents: displayedComponents, label: label)
    lowerBound = range.lowerBound
    upperBound = range.upperBound
  }

  /// Creates a selector accepting dates at or after the range's lower bound.
  ///
  /// - Parameters:
  ///   - selection: The caller-owned date, clamped to the lower bound when necessary.
  ///   - range: The inclusive earliest allowed instant; there is no upper date bound.
  ///   - displayedComponents: The controls to show. Defaults to both date and time.
  ///   - label: Content identifying the control.
  public init(
    selection: Binding<Date>,
    in range: PartialRangeFrom<Date>,
    displayedComponents: DatePickerComponents = [.date, .hourAndMinute],
    @ViewBuilder label: () -> Label
  ) {
    self.init(selection: selection, displayedComponents: displayedComponents, label: label)
    lowerBound = range.lowerBound
    upperBound = nil
  }

  /// Creates a selector accepting dates at or before the range's upper bound.
  ///
  /// - Parameters:
  ///   - selection: The caller-owned date, clamped to the upper bound when necessary.
  ///   - range: The inclusive latest allowed instant; there is no lower date bound.
  ///   - displayedComponents: The controls to show. Defaults to both date and time.
  ///   - label: Content identifying the control.
  public init(
    selection: Binding<Date>,
    in range: PartialRangeThrough<Date>,
    displayedComponents: DatePickerComponents = [.date, .hourAndMinute],
    @ViewBuilder label: () -> Label
  ) {
    self.init(selection: selection, displayedComponents: displayedComponents, label: label)
    lowerBound = nil
    upperBound = range.upperBound
  }

  /// Hides the visible label while retaining the compact control's accessibility label.
  ///
  /// Call before general view modifiers such as `padding()`.
  /// - Returns: The picker with its visible label hidden.
  public func labelsHidden() -> Self {
    var copy = self
    copy.hidesLabel = true
    return copy
  }

  /// Shows compact buttons that open the BrianUI calendar and time wheels.
  ///
  /// The popup is presented in the current window and dismisses active text input.
  /// Call this method before general view modifiers.
  /// Selection changes update the binding immediately; dismissing does not cancel changes.
  /// See <doc:Forms> for examples of compact controls and draft selection.
  ///
  /// - Parameter style: Pass `.compact` to use BrianUI's compact presentation.
  /// - Returns: The picker configured to present its calendar and wheels in a popup.
  public func datePickerStyle(_ style: CompactDatePickerStyle) -> Self {
    var copy = self
    copy.usesCompactStyle = true
    return copy
  }

  public var body: some View {
    Group {
      if usesCompactStyle {
        compactPicker
      } else {
        expandedPicker
      }
    }
    .onChange(of: isEnabled) { _, enabled in
      if !enabled {
        showsDate = false
        showsTime = false
      }
    }
    .onDisappear {
      showsDate = false
      showsTime = false
    }
    .onAppear { synchronizeCalendar() }
    .onChange(of: dateCalendar) { _, _ in synchronizeCalendar() }
    .onChange(of: selection) { oldValue, value in
      selectionChanged(from: oldValue, to: value)
    }
  }

  private var compactPicker: some View {
    ViewThatFits(in: .horizontal) {
      HStack(spacing: theme.spacing.small) {
        if !hidesLabel {
          label
          Spacer(minLength: theme.spacing.small)
        }
        compactButtons
      }
      VStack(alignment: .leading, spacing: theme.spacing.small) {
        if !hidesLabel { label }
        compactButtons
      }
    }
    .typography(theme.typography.body.medium)
    .foregroundStyle(foregroundColor)
    .accessibilityElement(children: .contain)
    .accessibilityLabel { _ in label }
  }

  private var compactCalendarPopup: some View {
    calendarContent
      .padding(theme.spacing.medium)
      .foregroundStyle(foregroundColor)
      .buttonStyle(BrianDatePickerButtonStyle())
      .onChange(of: scrollMonth) { _, value in
        if let value { visibleMonth = value }
      }
  }

  private var compactButtons: some View {
    HStack(spacing: theme.spacing.small) {
      if displayedComponents.contains(.date) {
        Button {
          synchronizeCalendar()
          activePanel = .calendar
          showsDate = true
        } label: {
          compactValue(compactDateFormatter.string(from: displayedSelection), isSelected: showsDate)
        }
        .brianDatePickerPopup(isPresented: $showsDate, width: 300) {
          compactCalendarPopup
        }
      }
      if displayedComponents.contains(.hourAndMinute) {
        Button {
          showsTime = true
        } label: {
          compactValue(formatted(displayedSelection, template: "jm"), isSelected: showsTime)
        }
        .brianDatePickerPopup(isPresented: $showsTime, width: 300) {
          timePicker.padding(theme.spacing.medium)
        }
      }
    }
    .buttonStyle(.plain)
  }

  private var compactDateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.locale = locale
    formatter.calendar = calendar
    formatter.timeZone = timeZone
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
  }

  private func compactValue(_ value: String, isSelected: Bool) -> some View {
    Text(value)
      .typography(theme.typography.body.medium)
      .monospacedDigit()
      .fixedSize()
      .padding(.horizontal, theme.spacing.small)
      .padding(.vertical, theme.spacing.small)
      .foregroundStyle(isSelected && isEnabled ? theme.color.foreground.brand.strong : foregroundColor)
      .background(
        isSelected && isEnabled
          ? theme.color.background.brand.weak.normal
          : theme.color.background.neutral.weak.normal,
        in: Capsule()
      )
      .overlay {
        if isSelected && isEnabled {
          Capsule()
            .strokeBorder(theme.color.border.brand.weak, lineWidth: 1)
            .allowsHitTesting(false)
        }
      }
      .accessibilityAddTraits(isSelected ? .isSelected : [])
      .frame(minHeight: 44)
      .contentShape(Rectangle())
  }

  private var expandedPicker: some View {
    VStack(alignment: .leading, spacing: theme.spacing.medium) {
      if !hidesLabel || displayedComponents.contains(.hourAndMinute) {
        ViewThatFits(in: .horizontal) {
          HStack(spacing: theme.spacing.small) {
            if !hidesLabel {
              label
                .typography(theme.typography.title.small)
            }

            Spacer(minLength: theme.spacing.small)

            if displayedComponents.contains(.hourAndMinute) {
              timeHeading
            }
          }

          VStack(alignment: .leading, spacing: theme.spacing.small) {
            if !hidesLabel {
              label
                .typography(theme.typography.title.small)
            }

            if displayedComponents.contains(.hourAndMinute) {
              timeHeading
            }
          }
        }
      }

      if displayedComponents.contains(.date) {
        calendarContent
      } else if displayedComponents.contains(.hourAndMinute), activePanel == .time {
        timePicker
          .transition(.opacity)
      }
    }
    .foregroundStyle(foregroundColor)
    .tint(theme.color.foreground.primary)
    .buttonStyle(BrianDatePickerButtonStyle())
    .padding(theme.spacing.medium)
    .background(theme.color.background.base, in: .rect(cornerRadius: theme.radius.medium))
    .onChange(of: displayedComponents) { _, _ in
      activePanel = .calendar
    }
    .onChange(of: scrollMonth) { _, value in
      if let value {
        visibleMonth = value
      }
    }
  }

  private var timeHeading: some View {
    Button(action: timeHeadingTapped) {
      HStack(spacing: theme.spacing.xSmall) {
        Text(formatted(displayedSelection, template: "jm"))
          .monospacedDigit()

        Image(symbol: .chevronRight)
          .typography(theme.typography.label.small)
          .rotationEffect(.degrees(activePanel == .time ? 90 : 0))
      }
    }
    .buttonStyle(.weak)
    .buttonTone(.neutral)
    .buttonSize(.small)
  }

  private var timePicker: some View {
    BrianDatePickerTimePicker(
      selection: $selection,
      calendar: calendar,
      locale: locale,
      lowerBound: lowerBound,
      upperBound: upperBound
    )
  }

  private var calendarContent: some View {
    VStack(spacing: calendarSpacing) {
      if usesCompactStyle {
        HStack(spacing: theme.spacing.xSmall) {
          monthHeading
            .frame(maxWidth: .infinity, alignment: .leading)

          if activePanel == .calendar {
            monthNavigation
              .fixedSize()
          }
        }
      } else {
        ViewThatFits(in: .horizontal) {
          HStack(spacing: theme.spacing.small) {
            monthHeading
              .fixedSize(horizontal: true, vertical: false)

            Spacer(minLength: theme.spacing.small)

            if activePanel == .calendar {
              monthNavigation
            }
          }

          VStack(alignment: .leading, spacing: theme.spacing.small) {
            monthHeading

            if activePanel == .calendar {
              HStack {
                Spacer()

                monthNavigation
              }
            }
          }
        }
      }

      Group {
        switch activePanel {
        case .calendar:
          calendarGrid

        case .month:
          BrianDatePickerMonthPicker(
            selectedMonth: displayedSelection,
            dateCalendar: dateCalendar,
            locale: locale,
            onSelect: monthPicked
          )

        case .time:
          timePicker
        }
      }
      .frame(minHeight: calendarHeight)
      .transition(.opacity)
    }
  }

  private var monthHeading: some View {
    Button(action: monthHeadingTapped) {
      HStack(spacing: usesCompactStyle ? theme.spacing.xSmall : theme.spacing.small) {
        Text(formatted(monthHeadingDate, template: "yMMMM"))
          .typography(usesCompactStyle ? theme.typography.body.small : theme.typography.title.small)
          .fontWeight(.bold)
          .lineLimit(1)
          .foregroundStyle(foregroundColor)

        Image(symbol: .chevronRight)
          .typography(usesCompactStyle ? theme.typography.label.small : theme.typography.label.medium)
          .rotationEffect(.degrees(activePanel == .month ? 90 : 0))
      }
      .frame(minHeight: 44)
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
  }

  private var monthNavigation: some View {
    HStack(spacing: usesCompactStyle ? theme.spacing.xSmall : theme.spacing.small) {
      Button {
        moveMonth(by: -1)
      } label: {
        Image(symbol: .chevronLeft)
          .typography(usesCompactStyle ? theme.typography.label.medium : theme.typography.title.small)
          .frame(width: 44, height: 44)
      }
      .disabled(!canMoveMonth(by: -1))

      Button {
        moveMonth(by: 1)
      } label: {
        Image(symbol: .chevronRight)
          .typography(usesCompactStyle ? theme.typography.label.medium : theme.typography.title.small)
          .frame(width: 44, height: 44)
      }
      .disabled(!canMoveMonth(by: 1))
    }
    .foregroundStyle(foregroundColor)
  }

  private var calendarGrid: some View {
    TimelineView(.everyMinute) { context in
      VStack(spacing: calendarSpacing) {
        HStack(spacing: .zero) {
          ForEach(0..<7) { index in
            Text(calendar.veryShortStandaloneWeekdaySymbols[(calendar.firstWeekday - 1 + index) % 7])
              .typography(theme.typography.label.medium)
              .lineLimit(1)
              .minimumScaleFactor(0.5)
              .foregroundStyle(theme.color.foreground.secondary)
              .frame(maxWidth: .infinity)
          }
        }
        .frame(minHeight: weekdayHeight)

        ScrollView(.horizontal) {
          LazyHStack(alignment: .top, spacing: .zero) {
            ForEach(monthPages, id: \.self) { page in
              monthGrid(page, today: context.date)
                .containerRelativeFrame(.horizontal)
                .id(page)
            }
          }
          .scrollTargetLayout()
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $scrollMonth)
        .scrollDisabled(!isEnabled)
        .onScrollPhaseChange { _, phase in
          if phase == .idle {
            extendMonthPages(near: visibleMonth)
          }
        }
        .frame(height: gridHeight)
      }
    }
  }

  private func monthGrid(_ page: Date, today: Date) -> some View {
    let cells = dateCalendar.dayCells(in: page)

    return LazyVGrid(
      columns: Array(repeating: GridItem(.flexible(), spacing: .zero), count: 7),
      spacing: daySpacing
    ) {
      ForEach(cells.indices, id: \.self) { index in
        if let date = cells[index] {
          dayButton(date, today: today)
        } else {
          Color.clear
            .frame(height: dayHeight)
        }
      }
    }
  }

  private func dayButton(_ date: Date, today: Date) -> some View {
    let selected = calendar.isDate(date, inSameDayAs: displayedSelection)
    let isToday = calendar.isDate(date, inSameDayAs: today)
    let enabled = isDayEnabled(date)

    return Button {
      selectDay(date)
    } label: {
      Text(calendar.component(.day, from: date), format: .number.locale(locale))
        .typography(usesCompactStyle ? theme.typography.body.medium : theme.typography.title.medium)
        .fontWeight(selected || isToday ? .semibold : .regular)
        .lineLimit(1)
        .minimumScaleFactor(0.5)
        .padding(.horizontal, theme.spacing.xSmall)
        .frame(maxWidth: .infinity)
        .frame(height: dayHeight)
        .foregroundStyle(dayForegroundColor(selected: selected, today: isToday, enabled: enabled))
        .background {
          Circle()
            .fill(dayBackgroundColor(selected: selected, today: isToday))
        }
        .overlay {
          if isToday {
            Circle()
              .strokeBorder(
                selected ? theme.color.border.strong : theme.color.border.base,
                lineWidth: selected ? 2 : 1
              )
              .allowsHitTesting(false)
          }
        }
        .contentShape(Rectangle())
    }
    .disabled(!enabled)
  }

  private var calendar: Calendar {
    var value = environmentCalendar
    value.timeZone = timeZone
    value.locale = locale
    return value
  }

  private var dateCalendar: BrianDatePickerCalendar {
    .init(calendar: calendar, lowerBound: lowerBound, upperBound: upperBound)
  }

  private var displayedSelection: Date {
    dateCalendar.clamped(selection)
  }

  private var monthHeadingDate: Date {
    guard
      let interval = calendar.dateInterval(of: .month, for: visibleMonth),
      displayedSelection >= interval.start,
      displayedSelection < interval.end
    else {
      return visibleMonth
    }
    return displayedSelection
  }

  private var foregroundColor: Color {
    isEnabled ? theme.color.foreground.primary : theme.color.foreground.disabled
  }

  private var gridHeight: CGFloat {
    dayHeight * 6 + daySpacing * 5
  }

  private var calendarHeight: CGFloat {
    weekdayHeight + calendarSpacing + gridHeight
  }

  private func dayForegroundColor(selected: Bool, today: Bool, enabled: Bool) -> Color {
    guard isEnabled && enabled else {
      return theme.color.foreground.disabled
    }
    return selected && !today ? theme.color.foreground.inverse : theme.color.foreground.primary
  }

  private func dayBackgroundColor(selected: Bool, today: Bool) -> Color {
    if today {
      return theme.color.background.neutral.weak.normal
    }
    return selected ? theme.color.background.neutral.solid.normal : .clear
  }

  private func monthHeadingTapped() {
    guard isEnabled else {
      return
    }

    // Browsing is separate from selection. Wheels always open at the bound date.
    if activePanel != .month {
      revealMonth(containing: displayedSelection)
    }

    withAnimation(.easeInOut(duration: 0.2)) {
      activePanel = activePanel == .month ? .calendar : .month
    }
  }

  private func timeHeadingTapped() {
    guard isEnabled else {
      return
    }

    withAnimation(.easeInOut(duration: 0.2)) {
      activePanel = activePanel == .time ? .calendar : .time
    }
  }

  private func monthPicked(_ month: Date) {
    guard isEnabled else {
      return
    }

    guard let date = BrianDatePickerMonthSelection.date(
      in: month,
      preserving: displayedSelection,
      calendar: calendar,
      lowerBound: lowerBound,
      upperBound: upperBound
    ) else {
      return
    }

    revealMonth(containing: date)
    selection = date
  }

  private func isDayEnabled(_ date: Date) -> Bool {
    guard let interval = calendar.dateInterval(of: .day, for: date) else {
      return false
    }
    return dateCalendar.contains(interval)
  }

  private func selectDay(_ date: Date) {
    let time = calendar.dateComponents([.hour, .minute, .second], from: displayedSelection)
    guard let value = calendar.date(
      bySettingHour: time.hour ?? 0,
      minute: time.minute ?? 0,
      second: time.second ?? 0,
      of: date
    ) else {
      return
    }
    selection = dateCalendar.clamped(value)
  }

  private func canMoveMonth(by offset: Int) -> Bool {
    dateCalendar.adjacentMonth(to: visibleMonth, by: offset) != nil
  }

  private func moveMonth(by offset: Int) {
    guard isEnabled, let date = dateCalendar.adjacentMonth(to: visibleMonth, by: offset) else {
      return
    }

    extendMonthPages(near: date)
    withAnimation(.easeInOut(duration: 0.28)) {
      scrollMonth = date
      visibleMonth = date
    }
  }

  private func synchronizeCalendar() {
    let value = displayedSelection
    if selection != value {
      selection = value
    }

    monthPages = dateCalendar.window(of: .month, around: value, radius: 12)
    visibleMonth = dateCalendar.month(containing: value)
    scrollMonth = visibleMonth
  }

  private func selectionChanged(from oldValue: Date, to value: Date) {
    let valid = dateCalendar.clamped(value)
    if value != valid {
      selection = valid
    }

    // Time changes preserve the currently browsed calendar month.
    guard !calendar.isDate(oldValue, inSameDayAs: valid) else {
      return
    }
    revealMonth(containing: valid)
  }

  private func revealMonth(containing date: Date) {
    let month = dateCalendar.month(containing: date)
    if !monthPages.contains(month) {
      monthPages = dateCalendar.window(of: .month, around: date, radius: 12)
    } else {
      extendMonthPages(near: month)
    }
    visibleMonth = month
    scrollMonth = month
  }

  private func extendMonthPages(near date: Date) {
    monthPages = dateCalendar.extending(monthPages, of: .month, near: date, radius: 12)
  }

  private func formatted(_ date: Date, template: String) -> String {
    let formatter = DateFormatter()
    formatter.locale = locale
    formatter.calendar = calendar
    formatter.timeZone = timeZone
    formatter.setLocalizedDateFormatFromTemplate(template)
    return formatter.string(from: date)
  }
}

extension BrianDatePicker where Label == Text {
  /// Creates a selector with no date bounds and a localized text label.
  ///
  /// - Parameters:
  ///   - title: The text identifying the control.
  ///   - selection: The caller-owned date to display and update.
  ///   - displayedComponents: The controls to show. Defaults to both date and time.
  public init(
    _ title: LocalizedStringKey,
    selection: Binding<Date>,
    displayedComponents: DatePickerComponents = [.date, .hourAndMinute]
  ) {
    self.init(selection: selection, displayedComponents: displayedComponents) {
      Text(title)
    }
  }

  /// Creates a selector with no date bounds and a plain text label.
  ///
  /// - Parameters:
  ///   - title: The text identifying the control.
  ///   - selection: The caller-owned date to display and update.
  ///   - displayedComponents: The controls to show. Defaults to both date and time.
  public init<S: StringProtocol>(
    _ title: S,
    selection: Binding<Date>,
    displayedComponents: DatePickerComponents = [.date, .hourAndMinute]
  ) {
    self.init(selection: selection, displayedComponents: displayedComponents) {
      Text(title)
    }
  }

  /// Creates a selector with inclusive lower and upper date bounds and a localized text label.
  ///
  /// - Parameters:
  ///   - title: The text identifying the control.
  ///   - selection: The caller-owned date to display and update.
  ///   - range: Allowed instants. Out-of-range selection is clamped on appearance and updates.
  ///   - displayedComponents: The controls to show. Defaults to both date and time.
  public init(
    _ title: LocalizedStringKey,
    selection: Binding<Date>,
    in range: ClosedRange<Date>,
    displayedComponents: DatePickerComponents = [.date, .hourAndMinute]
  ) {
    self.init(selection: selection, in: range, displayedComponents: displayedComponents) {
      Text(title)
    }
  }

  /// Creates a selector with inclusive lower and upper date bounds and a plain text label.
  ///
  /// - Parameters:
  ///   - title: The text identifying the control.
  ///   - selection: The caller-owned date to display and update.
  ///   - range: Allowed instants. Out-of-range selection is clamped on appearance and updates.
  ///   - displayedComponents: The controls to show. Defaults to both date and time.
  public init<S: StringProtocol>(
    _ title: S,
    selection: Binding<Date>,
    in range: ClosedRange<Date>,
    displayedComponents: DatePickerComponents = [.date, .hourAndMinute]
  ) {
    self.init(selection: selection, in: range, displayedComponents: displayedComponents) {
      Text(title)
    }
  }

  /// Creates a selector with an inclusive earliest date and a localized text label.
  ///
  /// - Parameters:
  ///   - title: The text identifying the control.
  ///   - selection: The caller-owned date to display and update.
  ///   - range: Allowed instants. Out-of-range selection is clamped on appearance and updates.
  ///   - displayedComponents: The controls to show. Defaults to both date and time.
  public init(
    _ title: LocalizedStringKey,
    selection: Binding<Date>,
    in range: PartialRangeFrom<Date>,
    displayedComponents: DatePickerComponents = [.date, .hourAndMinute]
  ) {
    self.init(selection: selection, in: range, displayedComponents: displayedComponents) {
      Text(title)
    }
  }

  /// Creates a selector with an inclusive earliest date and a plain text label.
  ///
  /// - Parameters:
  ///   - title: The text identifying the control.
  ///   - selection: The caller-owned date to display and update.
  ///   - range: Allowed instants. Out-of-range selection is clamped on appearance and updates.
  ///   - displayedComponents: The controls to show. Defaults to both date and time.
  public init<S: StringProtocol>(
    _ title: S,
    selection: Binding<Date>,
    in range: PartialRangeFrom<Date>,
    displayedComponents: DatePickerComponents = [.date, .hourAndMinute]
  ) {
    self.init(selection: selection, in: range, displayedComponents: displayedComponents) {
      Text(title)
    }
  }

  /// Creates a selector with an inclusive latest date and a localized text label.
  ///
  /// - Parameters:
  ///   - title: The text identifying the control.
  ///   - selection: The caller-owned date to display and update.
  ///   - range: Allowed instants. Out-of-range selection is clamped on appearance and updates.
  ///   - displayedComponents: The controls to show. Defaults to both date and time.
  public init(
    _ title: LocalizedStringKey,
    selection: Binding<Date>,
    in range: PartialRangeThrough<Date>,
    displayedComponents: DatePickerComponents = [.date, .hourAndMinute]
  ) {
    self.init(selection: selection, in: range, displayedComponents: displayedComponents) {
      Text(title)
    }
  }

  /// Creates a selector with an inclusive latest date and a plain text label.
  ///
  /// - Parameters:
  ///   - title: The text identifying the control.
  ///   - selection: The caller-owned date to display and update.
  ///   - range: Allowed instants. Out-of-range selection is clamped on appearance and updates.
  ///   - displayedComponents: The controls to show. Defaults to both date and time.
  public init<S: StringProtocol>(
    _ title: S,
    selection: Binding<Date>,
    in range: PartialRangeThrough<Date>,
    displayedComponents: DatePickerComponents = [.date, .hourAndMinute]
  ) {
    self.init(selection: selection, in: range, displayedComponents: displayedComponents) {
      Text(title)
    }
  }
}

private struct BrianDatePickerButtonStyle: ButtonStyle {
  @Environment(\.theme) private var theme
  @Environment(\.isEnabled) private var isEnabled

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .background {
        Circle()
          .fill(configuration.isPressed && isEnabled ? theme.color.background.transparent.pressed : .clear)
      }
      .scaleEffect(configuration.isPressed && isEnabled ? 0.92 : 1)
      .foregroundStyle(isEnabled ? theme.color.foreground.primary : theme.color.foreground.disabled)
      .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
  }
}
