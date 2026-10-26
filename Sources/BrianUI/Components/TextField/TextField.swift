import SwiftUI

/// 제목, 도움말 및 오류 상태를 표시하는 한 줄 텍스트 입력입니다.
///
/// 텍스트는 호출자가 소유한 `Binding<String>`으로 전달합니다.
/// 필수 여부와 최대 길이는 표시 및 오류 상태를 위한 설정이며,
/// 입력 차단이나 제출 검증은 호출자가 구현합니다.
///
/// 컴포넌트 고유 메서드는 일반 `View` 수정자보다 먼저 호출하세요.
/// 사용 예제는 <doc:Forms>를 참고하세요.
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

  /// 한 줄 텍스트 입력을 만듭니다.
  ///
  /// - Parameters:
  ///   - title: 입력 위에 표시할 제목입니다. 빈 문자열이면 제목을 숨깁니다.
  ///   - text: 입력값을 읽고 쓰는 바인딩입니다.
  ///   - placeholder: 입력값이 비어 있을 때 표시할 안내입니다.
  ///   - headerTrailing: 제목 뒤에 배치할 뷰입니다.
  ///   - leading: 입력 영역 앞에 배치할 뷰입니다.
  ///   - trailing: 입력 영역 뒤에 배치할 뷰입니다.
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

  /// 입력 아래에 표시할 도움말을 설정합니다.
  ///
  /// - Parameter text: 도움말입니다. `nil` 또는 빈 문자열이면 숨깁니다. 오류 메시지가 우선합니다.
  /// - Returns: 도움말이 설정된 입력 컴포넌트입니다.
  public func helperText(_ text: String?) -> Self {
    var field = self
    field.helperText = text
    return field
  }

  /// 오류 메시지와 오류 스타일을 설정합니다.
  ///
  /// - Parameter message: 오류 메시지입니다. `nil` 또는 빈 문자열이면 메시지로 인한 오류 상태를 해제합니다.
  /// - Returns: 오류 메시지가 설정된 입력 컴포넌트입니다.
  public func errorMessage(_ message: String?) -> Self {
    var field = self
    field.errorMessage = message
    return field
  }

  /// 제목에 필수 또는 선택 표시를 추가합니다. 입력값을 검증하지 않습니다.
  ///
  /// - Parameter requirement: 표시할 필수 여부입니다.
  /// - Returns: 필수 여부가 설정된 입력 컴포넌트입니다.
  public func requirement(_ requirement: BrianTextFieldRequirement) -> Self {
    var field = self
    field.requirement = requirement
    return field
  }

  /// 글자 수와 최대 길이를 표시하고, 길이를 초과하면 오류 스타일을 적용합니다.
  ///
  /// 입력값을 자르거나 입력을 차단하지 않습니다. 글자 수는 `String.count`로 계산합니다.
  ///
  /// - Parameter length: 최대 길이입니다. `nil`이면 제한 표시를 제거하고, 음수는 0으로 취급합니다.
  /// - Returns: 최대 길이가 설정된 입력 컴포넌트입니다.
  public func maximumLength(_ length: Int?) -> Self {
    var field = self
    field.maximumLength = length.map { max(0, $0) }
    return field
  }

  /// 외부 포커스 상태를 입력에 연결합니다.
  ///
  /// - Parameter focus: 호출자의 `@FocusState` 바인딩입니다. `nil`이면 내부 포커스 상태를 사용합니다.
  /// - Returns: 포커스 바인딩이 설정된 입력 컴포넌트입니다.
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
