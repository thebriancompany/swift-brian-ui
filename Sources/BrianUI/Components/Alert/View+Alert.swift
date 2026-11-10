import SwiftUI

extension View {
  /// Presents an alert while `item` is non-nil.
  ///
  /// Dismissing the alert sets `item` to `nil`, and `onDismiss` runs after the
  /// dismissal animation. Updates with the same ID preserve content state;
  /// a different ID replaces the content and resets its state.
  /// The last content remains visible during the dismissal animation.
  public func alert<Item: Identifiable, Content: View>(
    item: Binding<Item?>,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: @escaping (Item) -> Content
  ) -> some View {
    let presentedItem = item.wrappedValue
    return alert(
      isPresented: item[brianIsPresented: presentedItem?.id],
      onDismiss: onDismiss
    ) {
      if let presentedItem {
        content(presentedItem)
          .id(presentedItem.id)
      }
    }
  }

  public func alert<Content: View>(
    isPresented: Binding<Bool>,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: @escaping () -> Content
  ) -> some View {
    background {
      BrianAlertPresenter(
        isPresented: isPresented,
        onDismiss: onDismiss,
        content: content
      )
      .frame(width: 0, height: 0)
      .accessibilityHidden(true)
    }
  }

  public func alert<Actions: View>(
    isPresented: Binding<Bool>,
    title: String,
    description: String,
    onDismiss: (() -> Void)? = nil,
    @BrianAlertFooter actions: @escaping () -> Actions
  ) -> some View {
    alert(isPresented: isPresented, onDismiss: onDismiss) {
      BrianAlert(
        title,
        description: description,
        footer: actions
      )
    }
  }

  public func alert<Actions: View>(
    isPresented: Binding<Bool>,
    description: String,
    onDismiss: (() -> Void)? = nil,
    @BrianAlertFooter actions: @escaping () -> Actions
  ) -> some View {
    alert(isPresented: isPresented, onDismiss: onDismiss) {
      BrianAlert(
        description: description,
        footer: actions
      )
    }
  }
}
