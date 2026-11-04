import BrianSymbols
import SwiftUI

/// A capsule-shaped control for a selection, suggestion action, or removable input value.
///
/// The caller owns selection state. `Binding<Bool>` initializers toggle the value on tap,
/// while `action:` initializers only run the supplied action. `.disabled(true)` blocks all interaction.
/// Do not place buttons or other interactive controls inside a custom `label`.
public struct BrianChip<Label: View>: View {
  @Environment(\.theme) private var theme
  @Environment(\.chipProperty) private var property
  @Binding private var isSelected: Bool

  private let label: Label
  private let interaction: Interaction

  private enum Interaction {
    case action(() -> Void)
    case removable(onRemove: () -> Void)
  }

  /// Creates a chip that toggles its selection binding on tap.
  public init(
    isSelected: Binding<Bool>,
    @ViewBuilder label: () -> Label
  ) {
    self._isSelected = isSelected
    self.label = label()
    self.interaction = .action { isSelected.wrappedValue.toggle() }
  }

  /// Creates a chip that displays selection state and runs an action on tap.
  ///
  /// `isSelected` defaults to `false` and does not change automatically when the action runs.
  /// In a single-selection list, update the selected item's ID inside the action.
  public init(
    isSelected: Bool = false,
    action: @escaping () -> Void,
    @ViewBuilder label: () -> Label
  ) {
    self._isSelected = .constant(isSelected)
    self.label = label()
    self.interaction = .action(action)
  }

  /// Creates an input chip whose only interactive element is the trailing remove button.
  ///
  /// - Parameters:
  ///   - label: The content displaying the input value.
  ///   - onRemove: A removal request. The caller is responsible for removing the actual data and chip.
  public init(
    @ViewBuilder removable label: () -> Label,
    onRemove: @escaping () -> Void
  ) {
    self._isSelected = .constant(false)
    self.label = label()
    self.interaction = .removable(onRemove: onRemove)
  }

  public var body: some View {
    switch interaction {
    case let .action(action):
      Button(action: action) {
        label
      }
      .buttonStyle(BrianChipButtonStyle(isSelected: isSelected))

    case let .removable(onRemove):
      HStack(spacing: .zero) {
        label

        Button(action: onRemove) {
          Image(symbol: .xmark)
            .font(.system(size: property.size.suffixIconSize, weight: .medium))
            .frame(width: property.size.suffixIconSize)
            .padding(.horizontal, theme.spacing.medium / 2)
            .frame(minHeight: property.size.minimumHeight - theme.spacing.xSmall * 2)
        }
        .buttonStyle(BrianChipRemoveButtonStyle())
      }
      .modifier(BrianChipAppearance(isSelected: false, isPressed: false))
    }
  }
}

extension BrianChip where Label == BrianChipLabel {
  /// Creates a chip with text and optional decorations that toggles its selection binding.
  public init(
    _ title: String,
    isSelected: Binding<Bool>,
    prefix: BrianChipLabel.Prefix? = nil,
    suffixSystemImage: String? = nil
  ) {
    self.init(isSelected: isSelected) {
      BrianChipLabel(title, prefix: prefix, suffixSystemImage: suffixSystemImage)
    }
  }

  /// Creates a chip with text and optional decorations that runs an action.
  ///
  /// `isSelected` is display-only; handle state changes in the action.
  public init(
    _ title: String,
    isSelected: Bool = false,
    prefix: BrianChipLabel.Prefix? = nil,
    suffixSystemImage: String? = nil,
    action: @escaping () -> Void
  ) {
    self.init(isSelected: isSelected, action: action) {
      BrianChipLabel(title, prefix: prefix, suffixSystemImage: suffixSystemImage)
    }
  }

  /// Creates a chip with a trailing BrianSymbols icon that toggles its selection binding.
  ///
  /// Hides the trailing icon when `suffixSymbol` is `nil`.
  public init(
    _ title: String,
    isSelected: Binding<Bool>,
    prefix: BrianChipLabel.Prefix? = nil,
    suffixSymbol: BrianSymbol?
  ) {
    self.init(isSelected: isSelected) {
      BrianChipLabel(title, prefix: prefix, suffixSymbol: suffixSymbol)
    }
  }

  /// Creates a chip with a trailing BrianSymbols icon that runs an action.
  ///
  /// `isSelected` is display-only, and `nil` for `suffixSymbol` hides the icon.
  public init(
    _ title: String,
    isSelected: Bool = false,
    prefix: BrianChipLabel.Prefix? = nil,
    suffixSymbol: BrianSymbol?,
    action: @escaping () -> Void
  ) {
    self.init(isSelected: isSelected, action: action) {
      BrianChipLabel(title, prefix: prefix, suffixSymbol: suffixSymbol)
    }
  }

  /// Creates an input chip with text and a trailing remove button.
  ///
  /// The text area does not run an action; remove the actual data in `onRemove`.
  /// The `removable:` label distinguishes this from a standard action initializer.
  public init(
    removable title: String,
    prefix: BrianChipLabel.Prefix? = nil,
    onRemove: @escaping () -> Void
  ) {
    self.init(removable: {
      BrianChipLabel(title, prefix: prefix)
    }, onRemove: onRemove)
  }
}
