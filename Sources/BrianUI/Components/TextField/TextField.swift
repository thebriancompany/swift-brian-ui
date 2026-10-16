import SwiftUI

public struct BrianTextField<HeaderTrailing: View, Leading: View, Trailing: View>: View {
  @Environment(\.theme) private var theme
  @Environment(\.isEnabled) private var isEnabled
  @Environment(\.textFieldProperty) private var property
  @Environment(\.textFieldIsReadOnly) private var isReadOnly
  @Environment(\.textFieldShowsClearButton) private var showsClearButton
  @FocusState private var isFocused: Bool
  @Binding private var text: String

  private let title: String
  private let placeholder: String
  private var helperText: String?
  private var errorMessage: String?
  private var requirement: BrianTextFieldRequirement = .none
  private var maximumLength: Int?
  private var focus: FocusState<Bool>.Binding?
  private let headerTrailing: HeaderTrailing
  private let leading: Leading
  private let trailing: Trailing

  public init(
    title: String,
    text: Binding<String>,
    placeholder: String = "",
    @ViewBuilder headerTrailing: () -> HeaderTrailing = { EmptyView() },
    @ViewBuilder leading: () -> Leading = { EmptyView() },
    @ViewBuilder trailing: () -> Trailing = { EmptyView() }
  ) {
    self.title = title
    self._text = text
    self.placeholder = placeholder
    self.headerTrailing = headerTrailing()
    self.leading = leading()
    self.trailing = trailing()
  }

  public func helperText(_ text: String?) -> Self {
    var field = self
    field.helperText = text
    return field
  }

  public func errorMessage(_ message: String?) -> Self {
    var field = self
    field.errorMessage = message
    return field
  }

  public func requirement(_ requirement: BrianTextFieldRequirement) -> Self {
    var field = self
    field.requirement = requirement
    return field
  }

  public func maximumLength(_ length: Int?) -> Self {
    var field = self
    field.maximumLength = length.map { max(0, $0) }
    return field
  }

  public func textFieldFocused(_ focus: FocusState<Bool>.Binding?) -> Self {
    var field = self
    field.focus = focus
    return field
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: theme.spacing.small) {
      if !title.isEmpty || HeaderTrailing.self != EmptyView.self {
        header
      }

      input

      if displayedError != nil || nonempty(helperText) != nil || maximumLength != nil {
        footer
      }
    }
    .onChange(of: canEdit) { _, canEdit in
      if !canEdit {
        inputFocus.wrappedValue = false
      }
    }
  }

  private var header: some View {
    HStack(alignment: .firstTextBaseline, spacing: theme.spacing.small) {
      if !title.isEmpty {
        HStack(alignment: .firstTextBaseline, spacing: theme.spacing.xSmall) {
          Text(title)
            .fontWeight(property.weight == .bold ? .bold : .medium)
            .fixedSize(horizontal: false, vertical: true)

          switch requirement {
          case .none:
            EmptyView()

          case .required:
            Text("*")
              .foregroundStyle(
                isEnabled ? theme.color.foreground.critical.normal : theme.color.foreground.disabled
              )

          case let .optional(text):
            Text(text)
              .typography(theme.typography.body.small)
              .foregroundStyle(secondaryColor)
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      }

      headerTrailing
    }
    .typography(theme.typography.body.medium)
    .foregroundStyle(foregroundColor)
  }

  private var input: some View {
    HStack(spacing: theme.spacing.small) {
      leading
        .foregroundStyle(secondaryColor)

      Group {
        if isReadOnly {
          Text(text.isEmpty ? placeholder : text)
            .foregroundStyle(text.isEmpty ? placeholderColor : foregroundColor)
            .lineLimit(1)
            .textSelection(.enabled)
        } else {
          TextField(
            title,
            text: $text,
            prompt: Text(placeholder).foregroundStyle(placeholderColor)
          )
          .textFieldStyle(.plain)
          .foregroundStyle(foregroundColor)
          .focused(inputFocus)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      if showsClearButton && canEdit && inputFocus.wrappedValue && !text.isEmpty {
        Button(action: clearButtonTapped) {
          Image(systemName: "xmark.circle.fill")
            .foregroundStyle(theme.color.foreground.tertiary)
        }
        .buttonStyle(.plain)
      }

      trailing
        .foregroundStyle(secondaryColor)
    }
    .typography(inputTypography)
    .padding(.horizontal, property.style == .outline ? horizontalPadding : .zero)
    .padding(.vertical, verticalPadding)
    .background(backgroundColor, in: inputShape)
    .overlay {
      if property.style == .outline {
        inputShape.strokeBorder(borderColor, lineWidth: borderWidth)
          .allowsHitTesting(false)
      }
    }
    .overlay(alignment: .bottom) {
      if property.style == .underline {
        Rectangle()
          .fill(borderColor)
          .frame(height: borderWidth)
          .allowsHitTesting(false)
      }
    }
  }

  private var footer: some View {
    HStack(alignment: .top, spacing: theme.spacing.small) {
      if let message = displayedError ?? nonempty(helperText) {
        Text(message)
          .foregroundStyle(displayedError != nil ? errorColor : secondaryColor)
          .fixedSize(horizontal: false, vertical: true)
          .frame(maxWidth: .infinity, alignment: .leading)
      }

      if let maximumLength {
        HStack(spacing: .zero) {
          Text(text.count.formatted())
            .foregroundStyle(
              isInvalid ? errorColor : text.isEmpty ? secondaryColor : foregroundColor
            )

          Text(" / \(maximumLength.formatted())")
            .foregroundStyle(isInvalid ? errorColor : secondaryColor)
        }
        .fixedSize()
        .frame(
          maxWidth: displayedError == nil && nonempty(helperText) == nil ? .infinity : nil,
          alignment: .trailing)
      }
    }
    .typography(theme.typography.body.small)
  }

  private var inputFocus: FocusState<Bool>.Binding { focus ?? $isFocused }
  private var canEdit: Bool { isEnabled && !isReadOnly }
  private var displayedError: String? { nonempty(errorMessage) }
  private var isInvalid: Bool {
    displayedError != nil || maximumLength.map { text.count > $0 } == true
  }

  private var inputTypography: Typography {
    switch (property.style, property.size) {
    case (.outline, .medium): theme.typography.body.medium
    case (.outline, .large), (.underline, .medium): theme.typography.body.large
    case (.underline, .large): theme.typography.title.small
    }
  }

  private var horizontalPadding: CGFloat {
    property.size == .large ? theme.spacing.large : theme.spacing.medium
  }

  private var verticalPadding: CGFloat {
    property.size == .large ? theme.spacing.medium : theme.spacing.small
  }

  private var inputShape: RoundedRectangle {
    .rect(cornerRadius: property.size == .large ? theme.radius.large : theme.radius.medium)
  }

  private var foregroundColor: Color {
    isEnabled ? theme.color.foreground.primary : theme.color.foreground.disabled
  }

  private var secondaryColor: Color {
    isEnabled ? theme.color.foreground.secondary : theme.color.foreground.disabled
  }

  private var placeholderColor: Color {
    isEnabled ? theme.color.foreground.placeholder : theme.color.foreground.disabled
  }

  private var errorColor: Color {
    isEnabled ? theme.color.foreground.critical.normal : theme.color.foreground.disabled
  }

  private var backgroundColor: Color {
    guard property.style == .outline else {
      return theme.color.background.transparent.normal
    }
    return canEdit ? theme.color.background.base : theme.color.background.disabled
  }

  private var borderColor: Color {
    if !isEnabled {
      return theme.color.border.disabled
    }
    if isInvalid {
      return theme.color.border.critical.solid
    }
    if canEdit && inputFocus.wrappedValue {
      return theme.color.border.focus
    }
    return theme.color.border.base
  }

  private var borderWidth: CGFloat {
    isEnabled && (isInvalid || (canEdit && inputFocus.wrappedValue)) ? 2 : 1
  }

  private func nonempty(_ value: String?) -> String? {
    value.flatMap { $0.isEmpty ? nil : $0 }
  }

  private func clearButtonTapped() {
    text = ""
    inputFocus.wrappedValue = true
  }
}
