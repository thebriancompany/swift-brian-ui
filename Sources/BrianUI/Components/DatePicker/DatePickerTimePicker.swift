import SwiftUI

/// Independent 24-hour and minute wheels that preserve the selected calendar day.
struct BrianDatePickerTimePicker: View {
  @Environment(\.theme) private var theme
  @Binding var selection: Date

  let calendar: Calendar
  let locale: Locale
  let lowerBound: Date?
  let upperBound: Date?

  var body: some View {
    let options = BrianDatePickerTimeOptions(
      selection: selection,
      calendar: calendar,
      lowerBound: lowerBound,
      upperBound: upperBound
    )
    let hour = calendar.component(.hour, from: options.selection)
    let minute = calendar.component(.minute, from: options.selection)

    HStack(spacing: theme.spacing.large) {
      BrianDatePickerWheel(
        values: options.hours,
        selection: hour,
        text: formatted,
        onSelect: { hourPicked($0, options: options) }
      )

      Text(":")
        .typography(theme.typography.title.medium)

      BrianDatePickerWheel(
        values: options.minutes(in: hour),
        selection: minute,
        text: formatted,
        onSelect: { minutePicked($0, options: options) }
      )
    }
  }

  private func hourPicked(_ hour: Int, options: BrianDatePickerTimeOptions) {
    let minute = calendar.component(.minute, from: options.selection)
    if let date = options.date(in: hour, preferring: minute) {
      selection = date
    }
  }

  private func minutePicked(_ minute: Int, options: BrianDatePickerTimeOptions) {
    let hour = calendar.component(.hour, from: options.selection)
    if let date = options.date(in: hour, preferring: minute) {
      selection = date
    }
  }

  private func formatted(_ value: Int) -> String {
    value.formatted(.number.precision(.integerLength(2)).locale(locale))
  }
}
