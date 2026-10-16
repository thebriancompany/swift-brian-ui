import SwiftUI

extension EnvironmentValues {
  @Entry var badgeProperty = BrianBadgeProperty()
}

extension View {
  public func badgeProperty(_ property: BrianBadgeProperty) -> some View {
    environment(\.badgeProperty, property)
  }

  public func badgeSize(_ size: BrianBadgeProperty.Size) -> some View {
    transformEnvironment(\.badgeProperty) { $0.size = size }
  }

  public func badgeTone(_ tone: BrianBadgeProperty.Tone) -> some View {
    transformEnvironment(\.badgeProperty) { $0.tone = tone }
  }

  public func badgeVariant(_ variant: BrianBadgeProperty.Variant) -> some View {
    transformEnvironment(\.badgeProperty) { $0.variant = variant }
  }
}
