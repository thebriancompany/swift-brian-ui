#if os(iOS)
  import SwiftUI
  import UIKit

  final class BrianAlertUIKitCoordinator: NSObject, UIViewControllerTransitioningDelegate
  {
    weak var anchor: BrianModalUIKitAnchor?

    private var binding: Binding<Bool> = .constant(false)
    private var onDismiss: (() -> Void)?
    private var content = AnyView(EmptyView())
    private var environment = EnvironmentValues()
    private var dialog: BrianAlertUIKitController?
    private var presenter: UIViewController?
    private var updateScheduled = false
    private var previousFocus: Any?

    lazy var presentation = BrianModalPresentation(
      present: { [weak self] in
        self?.present() ?? false
      },
      dismiss: { [weak self] in
        self?.dismiss()
      }
    )

    func update(
      binding: Binding<Bool>,
      onDismiss: (() -> Void)?,
      content: AnyView?,
      environment: EnvironmentValues
    ) {
      self.binding = binding
      self.onDismiss = onDismiss
      if let content {
        self.content = content
      }
      self.environment = environment
      if let dialog {
        dialog.rootView = hostedContent
        dialog.overrideUserInterfaceStyle = environment.colorScheme == .dark ? .dark : .light
        if let controller = dialog.presentationController
          as? BrianAlertUIKitPresentationController
        {
          controller.update(environment: environment)
        }
      }
      scheduleUpdate()
    }

    func scheduleUpdate() {
      guard !updateScheduled else {
        return
      }
      updateScheduled = true
      DispatchQueue.main.async { [weak self] in
        guard let self else {
          return
        }
        self.updateScheduled = false
        let isReady = self.anchor?.viewIfLoaded?.window != nil
        self.presentation.update(
          isPresented: self.binding,
          onDismiss: self.onDismiss,
          isReady: isReady
        )
        if !isReady {
          self.presentation.requestDismissal()
        }
      }
    }

    private var hostedContent: AnyView {
      AnyView(
        BrianAlertHostedContent(
          content: content,
          environment: environment,
          presentation: presentation
        )
      )
    }

    private func present() -> Bool {
      guard let anchor, anchor.viewIfLoaded?.window != nil else {
        return false
      }
      var controller: UIViewController = anchor
      while let parent = controller.parent {
        controller = parent
      }
      while let presented = controller.presentedViewController {
        controller = presented
      }
      if controller.isBeingPresented || controller.isBeingDismissed {
        controller.transitionCoordinator?.animate(alongsideTransition: nil) { [weak self] _ in
          self?.scheduleUpdate()
        }
        return false
      }
      previousFocus = UIAccessibility.focusedElement(using: .notificationVoiceOver)
      let dialog = BrianAlertUIKitController(rootView: hostedContent)
      dialog.owner = self
      dialog.modalPresentationStyle = .custom
      dialog.transitioningDelegate = self
      dialog.isModalInPresentation = true
      dialog.overrideUserInterfaceStyle = environment.colorScheme == .dark ? .dark : .light
      dialog.view.backgroundColor = .clear
      dialog.view.accessibilityViewIsModal = true
      self.dialog = dialog
      self.presenter = controller
      controller.present(dialog, animated: true) { [weak self, weak dialog] in
        guard let self, let dialog, self.dialog === dialog else {
          return
        }
        self.presentation.presentationDidFinish()
      }
      return true
    }

    private func dismiss() {
      guard let dialog, dialog.presentingViewController != nil else {
        dismissalDidFinish()
        return
      }
      dialog.view.isUserInteractionEnabled = false
      dialog.dismiss(animated: true) { [self] in
        guard self.dialog === dialog else {
          return
        }
        dismissalDidFinish()
      }
    }

    func dismissalDidFinish() {
      guard dialog != nil else {
        return
      }
      dialog?.owner = nil
      dialog = nil
      presenter = nil
      UIAccessibility.post(notification: .screenChanged, argument: previousFocus)
      previousFocus = nil
      presentation.dismissalDidFinish()
    }

    func presentationController(
      forPresented presented: UIViewController,
      presenting: UIViewController?,
      source: UIViewController
    ) -> UIPresentationController? {
      BrianAlertUIKitPresentationController(
        presentedViewController: presented,
        presenting: presenting,
        environment: environment
      )
    }

    func animationController(
      forPresented presented: UIViewController,
      presenting: UIViewController,
      source: UIViewController
    ) -> (any UIViewControllerAnimatedTransitioning)? {
      BrianAlertUIKitAnimator(
        isPresenting: true,
        reduceMotion: environment.accessibilityReduceMotion
      )
    }

    func animationController(
      forDismissed dismissed: UIViewController
    ) -> (any UIViewControllerAnimatedTransitioning)? {
      BrianAlertUIKitAnimator(
        isPresenting: false,
        reduceMotion: environment.accessibilityReduceMotion
      )
    }
  }

  private final class BrianAlertUIKitController: UIHostingController<AnyView> {
    var owner: BrianAlertUIKitCoordinator?

    override var canBecomeFirstResponder: Bool { true }
    override var keyCommands: [UIKeyCommand]? {
      [
        UIKeyCommand(
          input: UIKeyCommand.inputEscape,
          modifierFlags: [],
          action: #selector(escapePressed)
        )
      ]
    }

    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      becomeFirstResponder()
      UIAccessibility.post(
        notification: .screenChanged,
        argument: view
      )
    }

    override func viewDidDisappear(_ animated: Bool) {
      super.viewDidDisappear(animated)
      if owner?.presentation.phase != .dismissing, presentingViewController == nil {
        owner?.presentation.presentationDidFinish()
        owner?.presentation.requestDismissal()
      }
    }

    override func accessibilityPerformEscape() -> Bool {
      owner?.presentation.requestDismissal() ?? false
    }

    @objc private func escapePressed() {
      owner?.presentation.requestDismissal()
    }
  }

  private final class BrianAlertUIKitPresentationController: UIPresentationController {
    private let dimmer = UIView()
    private var environment: EnvironmentValues

    init(
      presentedViewController: UIViewController,
      presenting: UIViewController?,
      environment: EnvironmentValues
    ) {
      self.environment = environment
      super.init(presentedViewController: presentedViewController, presenting: presenting)
      dimmer.isAccessibilityElement = false
      update(environment: environment)
    }

    func update(environment: EnvironmentValues) {
      self.environment = environment
      dimmer.backgroundColor = .init(environment.theme.color.background.overlay)
      dimmer.overrideUserInterfaceStyle = environment.colorScheme == .dark ? .dark : .light
      containerView?.setNeedsLayout()
    }

    override var frameOfPresentedViewInContainerView: CGRect {
      guard
        let containerView,
        let host = presentedViewController as? BrianAlertUIKitController
      else {
        return .zero
      }
      return BrianAlertGeometry.cardFrame(
        in: containerView.safeAreaLayoutGuide.layoutFrame
      ) {
        host.sizeThatFits(in: $0)
      }
    }

    override func containerViewWillLayoutSubviews() {
      super.containerViewWillLayoutSubviews()
      dimmer.frame = containerView?.bounds ?? .zero
      presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override func presentationTransitionWillBegin() {
      guard let containerView else {
        return
      }
      dimmer.frame = containerView.bounds
      dimmer.alpha = 0
      containerView.insertSubview(dimmer, at: 0)
      UIView.animate(
        withDuration: environment.accessibilityReduceMotion ? 0.15 : 0.2
      ) {
        self.dimmer.alpha = 1
      }
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
      if !completed {
        dimmer.removeFromSuperview()
      }
    }

    override func dismissalTransitionWillBegin() {
      UIView.animate(
        withDuration: environment.accessibilityReduceMotion ? 0.15 : 0.2
      ) {
        self.dimmer.alpha = 0
      }
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
      if completed {
        dimmer.removeFromSuperview()
      }
    }

    override func adaptivePresentationStyle(
      for traitCollection: UITraitCollection
    ) -> UIModalPresentationStyle {
      .none
    }
  }

  private final class BrianAlertUIKitAnimator: NSObject,
    UIViewControllerAnimatedTransitioning
  {
    let isPresenting: Bool
    let reduceMotion: Bool

    init(isPresenting: Bool, reduceMotion: Bool) {
      self.isPresenting = isPresenting
      self.reduceMotion = reduceMotion
    }

    func transitionDuration(
      using transitionContext: (any UIViewControllerContextTransitioning)?
    ) -> TimeInterval {
      reduceMotion ? 0.15 : (isPresenting ? 0.3 : 0.2)
    }

    func animateTransition(
      using context: any UIViewControllerContextTransitioning
    ) {
      let key: UITransitionContextViewControllerKey = isPresenting ? .to : .from
      guard
        let controller = context.viewController(forKey: key),
        let view = context.view(forKey: isPresenting ? .to : .from)
      else {
        context.completeTransition(false)
        return
      }
      let offset = CGAffineTransform(
        translationX: 0, y: reduceMotion ? 0 : BrianAlertGeometry.travel)
      if isPresenting {
        view.frame = context.finalFrame(for: controller)
        context.containerView.addSubview(view)
        view.alpha = 0
        view.transform = offset
      }
      UIView.animate(
        withDuration: transitionDuration(using: context),
        delay: 0,
        options: [isPresenting ? .curveEaseOut : .curveEaseIn, .beginFromCurrentState]
      ) {
        view.alpha = self.isPresenting ? 1 : 0
        view.transform = self.isPresenting ? .identity : offset
      } completion: { _ in
        let completed = !context.transitionWasCancelled
        if !self.isPresenting, completed {
          view.removeFromSuperview()
        }
        view.transform = .identity
        context.completeTransition(completed)
      }
    }
  }
#endif
