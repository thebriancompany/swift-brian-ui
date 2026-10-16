import SwiftUI

extension View {
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
