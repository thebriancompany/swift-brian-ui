#if os(iOS)
import SwiftUI
import UIKit

struct BrianBottomSheetPresenter<Content: View>: UIViewControllerRepresentable {
  @Binding var isPresented: Bool
  let content: (BrianBottomSheetPresentation) -> Content

  func makeCoordinator() -> BrianBottomSheetUIKitCoordinator<Content> {
    BrianBottomSheetUIKitCoordinator()
  }

  func makeUIViewController(context: Context) -> BrianModalUIKitAnchor {
    let anchor = BrianModalUIKitAnchor()
    context.coordinator.anchor = anchor
    anchor.attachmentChanged = { [weak coordinator = context.coordinator] in
      coordinator?.scheduleUpdate()
    }
    return anchor
  }

  func updateUIViewController(_ controller: BrianModalUIKitAnchor, context: Context) {
    context.coordinator.update(
      binding: $isPresented,
      content: isPresented ? content(context.coordinator.presentation) : nil,
      environment: context.environment
    )
  }

  static func dismantleUIViewController(
    _ controller: BrianModalUIKitAnchor,
    coordinator: BrianBottomSheetUIKitCoordinator<Content>
  ) {
    controller.attachmentChanged = nil
    DispatchQueue.main.async { coordinator.presentation.lifecycle.invalidate() }
  }
}

@MainActor
final class BrianBottomSheetUIKitCoordinator<Content: View> {
  weak var anchor: BrianModalUIKitAnchor?

  private var binding: Binding<Bool> = .constant(false)
  private var content: Content?
  private var environment = EnvironmentValues()
  private var host: BrianBottomSheetUIKitController<Content>?
  private var updateScheduled = false

  lazy var presentation = BrianBottomSheetPresentation(
    present: { [weak self] in self?.present() ?? false },
    remove: { [weak self] completion in
      guard let self else {
        completion()
        return
      }
      self.remove(completion: completion)
    }
  )

  func update(
    binding: Binding<Bool>,
    content: Content?,
    environment: EnvironmentValues
  ) {
    self.binding = binding
    if let content {
      self.content = content
    }
    self.environment = environment
    if let hostedContent {
      host?.rootView = hostedContent
    }
    host?.overrideUserInterfaceStyle = environment.colorScheme == .dark ? .dark : .light
    scheduleUpdate()
  }

  func scheduleUpdate() {
    guard !updateScheduled else { return }
    updateScheduled = true
    DispatchQueue.main.async { [weak self] in
      guard let self else {
        return
      }
      self.updateScheduled = false
      let ready = self.anchor?.viewIfLoaded?.window != nil
      self.presentation.lifecycle.update(
        isPresented: self.binding, onDismiss: nil, isReady: ready
      )
      if !ready {
        self.presentation.lifecycle.requestDismissal()
      }
    }
  }

  private var hostedContent: BrianBottomSheetHostedContent<Content>? {
    content.map {
      BrianBottomSheetHostedContent(
        content: $0,
        environment: environment
      )
    }
  }

  private func present() -> Bool {
    guard let hostedContent, let window = anchor?.viewIfLoaded?.window, var presenter = window.rootViewController else {
      return false
    }
    while let presented = presenter.presentedViewController {
      presenter = presented
    }

    if presenter.isBeingPresented || presenter.isBeingDismissed {
      presenter.transitionCoordinator?.animate(alongsideTransition: nil) { [weak self] _ in
        self?.scheduleUpdate()
      }
      return false
    }
    let host = BrianBottomSheetUIKitController(rootView: hostedContent)
    host.owner = self
    host.modalPresentationStyle = .overFullScreen
    host.isModalInPresentation = true
    host.overrideUserInterfaceStyle = environment.colorScheme == .dark ? .dark : .light
    host.view.backgroundColor = .clear
    self.host = host
    presenter.present(host, animated: false)
    return true
  }

  private func remove(completion: @escaping () -> Void) {
    guard let host else {
      completion()
      return
    }
    host.owner = nil
    guard host.presentingViewController != nil else {
      self.host = nil
      completion()
      return
    }
    host.dismiss(animated: false) { [self] in
      self.host = nil
      completion()
    }
  }
}

private final class BrianBottomSheetUIKitController<Content: View>:
  UIHostingController<BrianBottomSheetHostedContent<Content>>
{
  var owner: BrianBottomSheetUIKitCoordinator<Content>?

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    if presentingViewController == nil {
      owner?.presentation.lifecycle.presentationDidFinish()
      owner?.presentation.lifecycle.requestDismissal()
    }
  }
}
#endif
