import SwiftUI

public struct BrianCallout: View {
  @Environment(\.theme) private var theme
  @Environment(\.isEnabled) private var isEnabled
  @Environment(\.calloutProperty) private var property

  private let description: String
  private let title: String?
  private let systemImage: String?
  private let link: Link?
  private let interaction: Interaction

  public struct Link: Hashable, Sendable {
    public var title: String
    public var destination: URL

    public init(title: String, destination: URL) {
      self.title = title
      self.destination = destination
    }
  }

  private enum Interaction {
    case display
    case actionable(() -> Void)
    case dismissible(() -> Void)
  }

  public init(
    _ description: String,
    title: String? = nil,
    systemImage: String? = nil,
    link: Link? = nil
  ) {
    self.description = description
    self.title = title
    self.systemImage = systemImage
    self.link = link
    self.interaction = .display
  }

  public init(
    _ description: String,
    title: String? = nil,
    systemImage: String? = nil,
    action: @escaping () -> Void
  ) {
    self.description = description
    self.title = title
    self.systemImage = systemImage
    self.link = nil
    self.interaction = .actionable(action)
  }

  public init(
    _ description: String,
    title: String? = nil,
    systemImage: String? = nil,
    link: Link? = nil,
    onDismiss: @escaping () -> Void
  ) {
    self.description = description
    self.title = title
    self.systemImage = systemImage
    self.link = link
    self.interaction = .dismissible(onDismiss)
  }

  public var body: some View {
    Group {
      switch interaction {
      case let .actionable(action):
        Button(action: action) {
          content
        }
        .buttonStyle(
          CalloutButtonStyle(
            background: background,
            radius: theme.radius.medium
          )
        )

      case .display, .dismissible:
        content
          .background(
            background.normal,
            in: .rect(cornerRadius: theme.radius.medium)
          )
      }
    }
    .typography(theme.typography.body.small)
    .foregroundStyle(foreground)
    .tint(foreground)
  }

  private var content: some View {
    HStack(alignment: .firstTextBaseline, spacing: theme.spacing.small) {
      if let systemImage {
        Image(systemName: systemImage)
          .symbolVariant(.fill)
      }

      Text(message)
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: .infinity, alignment: .leading)

      switch interaction {
      case .display:
        Spacer()
          .frame(width: theme.spacing.large)

      case let .actionable(action):
        Button(action: action) {
          Image(systemName: "chevron.right")
        }
        .buttonStyle(CalloutInteractionButtonStyle())

      case let .dismissible(onDismiss):
        Button(action: onDismiss) {
          Image(systemName: "xmark")
        }
        .buttonStyle(CalloutInteractionButtonStyle())
      }
    }
    .padding(.vertical, theme.spacing.large)
    .padding(.leading, theme.spacing.large)
    .contentShape(.rect)
  }

  private var message: AttributedString {
    var result = AttributedString()
    if let title, !title.isEmpty {
      var heading = AttributedString(title)
      heading.font = theme.typography.body.small.font.bold()
      result += heading + AttributedString("  ")
    }
    result += AttributedString(description)

    if let link {
      var text = AttributedString(link.title)
      text.link = isEnabled ? link.destination : nil
      text.underlineStyle = .single
      result += AttributedString("  ") + text
    }
    return result
  }

  private var background: ColorToken.State {
    let background = theme.color.background
    switch property.tone {
    case .neutral: return background.neutral.weak
    case .informative: return background.informative.weak
    case .warning: return background.warning.weak
    case .critical: return background.critical.weak
    case .positive: return background.positive.weak
    }
  }

  private var foreground: Color {
    let foreground = theme.color.foreground
    guard isEnabled else { return foreground.disabled }
    switch property.tone {
    case .neutral: return foreground.secondary
    case .informative: return foreground.informative.strong
    case .warning: return foreground.warning.strong
    case .critical: return foreground.critical.strong
    case .positive: return foreground.positive.strong
    }
  }
}
