import Foundation

/// Calendar arithmetic and range rules shared by the calendar and wheels.
struct BrianDatePickerCalendar: Equatable {
  var calendar: Calendar
  var lowerBound: Date?
  var upperBound: Date?

  func clamped(_ date: Date) -> Date {
    let value = lowerBound.map { max(date, $0) } ?? date
    return upperBound.map { min(value, $0) } ?? value
  }

  func contains(_ interval: DateInterval) -> Bool {
    (lowerBound.map { $0 < interval.end } ?? true)
      && (upperBound.map { $0 >= interval.start } ?? true)
  }

  func month(containing date: Date) -> Date {
    representative(of: .month, containing: date) ?? date
  }

  /// Period starts can resolve to the previous civil date in observational calendars.
  /// Noon is a stable ID for formatting, comparison, and arithmetic across those boundaries.
  func representative(of component: Calendar.Component, containing date: Date) -> Date? {
    let interval = component == .year
      ? intervalWithinEra(of: component, containing: date)
      : calendar.dateInterval(of: component, for: date)
    guard let interval else {
      return nil
    }
    return calendar.date(bySettingHour: 12, minute: 0, second: 0, of: interval.start)
  }

  func intervalWithinEra(of component: Calendar.Component, containing date: Date) -> DateInterval? {
    guard let interval = calendar.dateInterval(of: component, for: date) else {
      return nil
    }

    let era = calendar.dateInterval(of: .era, for: date)
    let start = max(interval.start, era?.start ?? interval.start)
    var end = interval.end

    // Foundation can report an era's end as an anniversary rather than the actual transition.
    // Walk backward through era starts to find the next transition within this period.
    while let nextEra = calendar.dateInterval(of: .era, for: end.addingTimeInterval(-1)) {
      guard nextEra.start > date, nextEra.start < end else {
        break
      }
      end = nextEra.start
    }
    return DateInterval(start: start, end: end)
  }

  func adjacentMonth(to date: Date, by offset: Int) -> Date? {
    guard
      let next = calendar.date(byAdding: .month, value: offset, to: month(containing: date)),
      let interval = calendar.dateInterval(of: .month, for: next),
      contains(interval)
    else {
      return nil
    }
    return month(containing: next)
  }

  /// Load a finite window without imposing a limit on the dates that can be reached.
  func window(of component: Calendar.Component, around date: Date, radius: Int) -> [Date] {
    guard let center = representative(of: component, containing: clamped(date)) else {
      return []
    }

    let dates = (-radius...radius).flatMap { offset -> [Date] in
      guard
        let value = calendar.date(byAdding: component, value: offset, to: center),
        let interval = calendar.dateInterval(of: component, for: value)
      else {
        return []
      }

      if component == .year {
        return years(in: interval)
      }

      guard contains(interval), let date = representative(of: component, containing: value) else {
        return []
      }
      return [date]
    }
    return Array(Set(dates)).sorted()
  }

  /// Preserve existing IDs and offsets; grow only when selection approaches an edge.
  func extending(
    _ dates: [Date],
    of component: Calendar.Component,
    near date: Date,
    radius: Int
  ) -> [Date] {
    let index = dates.firstIndex { calendar.isDate($0, equalTo: date, toGranularity: component) }
    if let index, index >= 3, index < dates.count - 3 {
      return dates
    }
    return Array(Set(dates + window(of: component, around: date, radius: radius))).sorted()
  }

  func months(inYearContaining date: Date) -> [Date] {
    guard
      let year = representative(of: .year, containing: date),
      let yearInterval = intervalWithinEra(of: .year, containing: date)
    else {
      return []
    }

    var result: [Date] = []
    var month = max(month(containing: year), year)

    while month < yearInterval.end {
      guard let interval = calendar.dateInterval(of: .month, for: month) else {
        break
      }

      let available = DateInterval(
        start: max(interval.start, yearInterval.start),
        end: min(interval.end, yearInterval.end)
      )
      if contains(available) {
        result.append(month)
      }

      guard let next = calendar.date(byAdding: .month, value: 1, to: month) else {
        break
      }
      let nextMonth = self.month(containing: next)
      guard nextMonth > month else {
        break
      }
      month = nextMonth
    }
    return result
  }

  /// Enumerate real days, leaving weekday gaps for dates skipped by time-zone changes.
  func dayCells(in month: Date) -> [Date?] {
    let start = self.month(containing: month)
    guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: start) else {
      return []
    }

    let end = self.month(containing: nextMonth)
    var cells: [Date?] = []
    var date = start

    while date < end {
      let weekday = (calendar.component(.weekday, from: date) - calendar.firstWeekday + 7) % 7
      while cells.count % 7 != weekday {
        cells.append(nil)
      }
      cells.append(date)

      guard let next = calendar.date(byAdding: .day, value: 1, to: date), next > date else {
        break
      }
      date = next
    }

    while cells.count < 42 {
      cells.append(nil)
    }
    return cells
  }

  /// An era change can divide one calendar year into two independently selectable years.
  private func years(in interval: DateInterval) -> [Date] {
    var result: [Date] = []
    var end = interval.end

    while end > interval.start {
      let date = end.addingTimeInterval(-1)
      let era = calendar.dateInterval(of: .era, for: date)
      let start = max(interval.start, era?.start ?? interval.start)
      guard start < end else {
        break
      }

      let available = DateInterval(start: start, end: end)
      if contains(available), let year = representative(of: .year, containing: date) {
        result.append(year)
      }
      end = start
    }
    return result
  }
}
