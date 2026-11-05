import Foundation

/// Valid local times for one day, including partial hours at range boundaries.
struct BrianDatePickerTimeOptions {
  private var dates: [Int: [Int: Date]] = [:]

  let selection: Date

  init(selection: Date, calendar: Calendar, lowerBound: Date?, upperBound: Date?) {
    let selection = BrianDatePickerCalendar(calendar: calendar, lowerBound: lowerBound, upperBound: upperBound)
      .clamped(selection)
    self.selection = selection
    guard let day = calendar.dateInterval(of: .day, for: selection) else {
      return
    }

    let lower = max(day.start, lowerBound ?? day.start)
    let upper = min(day.end, upperBound ?? day.end)
    guard lower <= upper else {
      return
    }

    // Walk actual minutes so skipped/repeated hours follow the calendar's time zone.
    var start = day.start
    while start < day.end {
      let end = start.addingTimeInterval(60)
      let date = max(start, lower)
      if date < end, date < day.end, date <= upper {
        let parts = calendar.dateComponents([.hour, .minute], from: start)
        if let hour = parts.hour, let minute = parts.minute {
          // When a local time occurs twice, prefer the occurrence nearest selection.
          if let existing = dates[hour]?[minute] {
            if abs(date.timeIntervalSince(selection)) < abs(existing.timeIntervalSince(selection)) {
              dates[hour, default: [:]][minute] = date
            }
          } else {
            dates[hour, default: [:]][minute] = date
          }
        }
      }
      start = end
    }
  }

  var hours: [Int] {
    dates.keys.sorted()
  }

  func minutes(in hour: Int) -> [Int] {
    dates[hour]?.keys.sorted() ?? []
  }

  func date(in hour: Int, preferring minute: Int) -> Date? {
    let available = minutes(in: hour)
    guard let closest = available.min(by: { abs($0 - minute) < abs($1 - minute) }) else {
      return nil
    }
    return dates[hour]?[closest]
  }
}
