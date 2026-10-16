import SwiftUI

public struct BrianMenuItem: View {
  @Environment(\.theme) private var theme
  @Environment(\.isEnabled) private var isEnabled
  @Environment(\.menuProperty) private var property
  @Environment(\.dismissMenu) private var dismissMenu

  private let title: String
  private let description: String?
  private let systemImage: String?
  private let badge: String?
  private let isSelected: Bool
  private let role: ButtonRole?
  private let action: () -> Void

  public init(
    title: String,
    description: String? = nil,
    systemImage: String? = nil,
    badge: String? = nil,
    isSelected: Bool = false,
    role: ButtonRole? = nil,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.description = description
    self.systemImage = systemImage
    self.badge = badge
    self.isSelected = isSelected
    self.role = role
    self.action = action
  }

  public var body: some View {
    Button(role: role, action: itemTapped) {
      HStack(spacing: theme.spacing.xSmall) {
        if let systemImage {
          Image(systemName: systemImage)
            .frame(width: theme.spacing.xLarge)
        }

        VStack(alignment: .leading, spacing: theme.spacing.xSmall) {
          Text(title)
            .fixedSize(horizontal: false, vertical: true)

          if let description {
            Text(description)
              .typography(theme.typography.label.medium)
              .foregroundStyle(
                isEnabled ? theme.color.foreground.secondary : theme.color.foreground.disabled
              )
              .fixedSize(horizontal: false, vertical: true)
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)

        if let badge {
          BrianBadge(title: badge)
        }

        if isSelected {
          Image(systemName: "checkmark")
        }
      }
      .typography(
        property.size == .small ? theme.typography.body.small : theme.typography.body.medium
      )
      .foregroundStyle(foregroundColor)
    }
    .buttonStyle(BrianMenuItemStyle())
  }

  private var foregroundColor: Color {
    guard isEnabled else {
      return theme.color.foreground.disabled
    }
    return role == .destructive ? theme.color.foreground.critical.normal : theme.color.foreground.primary
  }

  private func itemTapped() {
    dismissMenu()
    action()
  }
}

private struct BrianMenuItemStyle: ButtonStyle {
  @Environment(\.theme) private var theme
  @Environment(\.isEnabled) private var isEnabled
  @Environment(\.menuProperty) private var property
  @State private var isHovered = false

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(.horizontal, theme.spacing.small)
      .padding(.vertical, property.size == .small ? theme.spacing.small : theme.spacing.medium)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(
        isEnabled && (configuration.isPressed || isHovered)
          ? theme.color.background.transparent.pressed
          : theme.color.background.transparent.normal,
        in: .rect(cornerRadius: theme.radius.small)
      )
      .contentShape(.rect)
      .padding(.horizontal, theme.spacing.small)
      .onHover { isHovered = $0 }
  }
}
