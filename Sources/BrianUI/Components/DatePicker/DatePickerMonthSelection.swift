import Foundation

enum BrianDatePickerMonthSelection {
  /// Preserve the selected day and time, clamping to the new month and allowed range.
  static func date(
    in month: Date,
    preserving selection: Date,
    calendar: Calendar,
    lowerBound: Date?,
    upperBound: Date?
  ) -> Date? {
    let dateCalendar = BrianDatePickerCalendar(
      calendar: calendar,
      lowerBound: lowerBound,
      upperBound: upperBound
    )
    guard let days = calendar.range(of: .day, in: .month, for: month) else {
      return nil
    }

    var components = calendar.dateComponents([.era, .year, .month, .isLeapMonth], from: month)
    components.day = min(calendar.component(.day, from: selection), days.upperBound - 1)
    components.hour = 12

    // Setting the civil day avoids counting a skipped day into the following month.
    guard var targetDay = calendar.date(from: components) else {
      return nil
    }

    // The first or last month of an era may contain only part of the civil month.
    if calendar.component(.era, from: targetDay) != calendar.component(.era, from: month) {
      guard let interval = dateCalendar.intervalWithinEra(of: .month, containing: month) else {
        return nil
      }
      targetDay = min(max(targetDay, interval.start), interval.end.addingTimeInterval(-1))
    }

    guard calendar.isDate(targetDay, equalTo: month, toGranularity: .month) else {
      return nil
    }

    let time = calendar.dateComponents([.hour, .minute, .second], from: selection)
    guard let value = calendar.date(
      bySettingHour: time.hour ?? 0,
      minute: time.minute ?? 0,
      second: time.second ?? 0,
      of: targetDay
    ) else {
      return nil
    }
    return dateCalendar.clamped(value)
  }
}
