import SwiftUI

/// Two independent wheels that report a selected month when scrolling settles.
struct BrianDatePickerMonthPicker: View {
  @Environment(\.theme) private var theme
  @State private var years: [Date]

  let selectedMonth: Date
  let dateCalendar: BrianDatePickerCalendar
  let locale: Locale
  let onSelect: (Date) -> Void

  init(
    selectedMonth: Date,
    dateCalendar: BrianDatePickerCalendar,
    locale: Locale,
    onSelect: @escaping (Date) -> Void
  ) {
    self.selectedMonth = selectedMonth
    self.dateCalendar = dateCalendar
    self.locale = locale
    self.onSelect = onSelect
    self._years = State(initialValue: dateCalendar.window(of: .year, around: selectedMonth, radius: 100))
  }

  var body: some View {
    let months = dateCalendar.months(inYearContaining: selectedMonth)
    let yearFormatter = formatter(template: yearTemplate)
    let monthFormatter = formatter(template: "MMMM")
    let labels = Dictionary(uniqueKeysWithValues: months.map {
      (Month($0, calendar: calendar), monthFormatter.string(from: $0))
    })

    HStack(spacing: theme.spacing.large) {
      BrianDatePickerWheel(
        values: years,
        selection: selectedYear,
        text: { yearFormatter.string(from: $0) },
        onSelect: yearPicked
      )

      BrianDatePickerWheel(
        values: months.map { Month($0, calendar: calendar) },
        selection: Month(selectedMonth, calendar: calendar),
        text: { labels[$0] ?? "" },
        onSelect: monthPicked
      )
    }
    .onChange(of: selectedYear) { _, year in
      years = dateCalendar.extending(years, of: .year, near: year, radius: 100)
    }
    .onChange(of: dateCalendar) { _, _ in
      years = dateCalendar.window(of: .year, around: selectedMonth, radius: 100)
    }
  }

  private var calendar: Calendar {
    dateCalendar.calendar
  }

  private var selectedYear: Date {
    dateCalendar.representative(of: .year, containing: selectedMonth) ?? selectedMonth
  }

  private var yearTemplate: String {
    let era = calendar.component(.era, from: selectedMonth)
    let includesOtherEras = years.contains { calendar.component(.era, from: $0) != era }
    return includesOtherEras ? "Gy" : "y"
  }

  private func monthPicked(_ month: Month) {
    let months = dateCalendar.months(inYearContaining: selectedMonth)
    if let date = months.first(where: { Month($0, calendar: calendar) == month }) {
      onSelect(date)
    }
  }

  private func yearPicked(_ year: Date) {
    let candidates = dateCalendar.months(inYearContaining: year)
    let current = Month(selectedMonth, calendar: calendar)
    let match = candidates.first { Month($0, calendar: calendar) == current }
    let nearest = candidates.min {
      abs(calendar.component(.month, from: $0) - current.number)
        < abs(calendar.component(.month, from: $1) - current.number)
    }
    if let month = match ?? nearest {
      onSelect(month)
    }
  }

  private func formatter(template: String) -> DateFormatter {
    let formatter = DateFormatter()
    formatter.locale = locale
    formatter.calendar = calendar
    formatter.timeZone = calendar.timeZone
    formatter.setLocalizedDateFormatFromTemplate(template)
    return formatter
  }

  // A month's identity survives year changes so its wheel keeps its scroll view.
  private struct Month: Hashable {
    let number: Int
    let isLeap: Bool

    init(_ date: Date, calendar: Calendar) {
      number = calendar.component(.month, from: date)
      isLeap = calendar.dateComponents([.isLeapMonth], from: date).isLeapMonth ?? false
    }
  }
}
