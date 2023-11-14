//
//  AuxiliaryPreviewModalManager.swift
//  experiment-message-tap-back
//
//  Created by Dominic Go on 11/7/23.
//

import UIKit
import DGSwiftUtilities

public class AuxiliaryPreviewModalManager: NSObject {

  // MARK: - Embedded Types
  // ----------------------
  
  enum PresentationState {
    case presenting;
    case dismissing;
  };
  
  // MARK: - Properties
  // ------------------
  
  var auxiliaryPreviewConfig: AuxiliaryPreviewConfig;
  var auxiliaryPreviewMetadata: AuxiliaryPreviewMetadata?;
  
  weak var delegate: AuxiliaryPreviewModalManagerDelegate?;

  var presentationState: PresentationState?;
  
  // MARK: - Layout Related
  // ----------------------
  
  /// A ref. to the view controller that presented `presentedController`
  weak var presentingController: UIViewController?;
  
  /// This is the view controller that was presented by `presentingController`
  /// Note: This is the parent controller of `auxiliaryPreviewController`/
  var presentedController: AuxiliaryPreviewModalWrapperViewController?;
  
  /// The view controller that holds the "auxiliary preview view".
  /// Note: This is a child controller of `presentedController`
  var auxiliaryPreviewController: UIViewController?;
  
  /// A ref. to the "original" view where the "auxiliary preview view" will be
  /// anchored/attached to
  weak var targetView: UIView?;
  
  /// The view where `presentedController` will be attached to
  var rootContainerView: UIView?;
  
  var dimmingView: UIView?;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  var auxiliaryPreviewView: UIView? {
    self.auxiliaryPreviewController?.view
  };
  
  var isPresenting: Bool {
    guard let presentedController = self.presentedController else { return false };
    let presentingController = presentedController.presentingViewController;
    
    let isPresentingModalWrapperVC =
      presentingController?.presentedViewController === presentedController;
      
    return presentedController.isBeingPresented || isPresentingModalWrapperVC;
  };
  
  // MARK: - Init
  // ------------
  
  init(auxiliaryPreviewConfig: AuxiliaryPreviewConfig) {
    self.auxiliaryPreviewConfig = auxiliaryPreviewConfig;
    super.init();
  };
  
  // MARK: - Functions - Setup
  // -------------------------
  
  func prepareForPresentation(){
  
    self.auxiliaryPreviewMetadata = .init(
      auxiliaryPreviewModalManager: self
    );
  };
  
  func setupViews(){
    guard let rootContainerView = self.rootContainerView,
          let presentedController = self.presentedController,
          let auxiliaryPreviewController = self.auxiliaryPreviewController,
          let targetView = self.targetView,
          
          let targetViewSnapshot =
            targetView.snapshotView(afterScreenUpdates: true),

          let auxiliaryPreviewMetadata = self.auxiliaryPreviewMetadata
    else { return };
    
    let auxiliaryPreviewConfig = self.auxiliaryPreviewConfig;
    
    presentedController.view.translatesAutoresizingMaskIntoConstraints = false;
    rootContainerView.addSubview(presentedController.view)
    
    NSLayoutConstraint.activate([
      presentedController.view.leadingAnchor.constraint(
        equalTo: rootContainerView.leadingAnchor
      ),
      presentedController.view.trailingAnchor.constraint(
        equalTo: rootContainerView.trailingAnchor
      ),
      presentedController.view.topAnchor.constraint(
        equalTo: rootContainerView.topAnchor
      ),
      presentedController.view.bottomAnchor.constraint(
        equalTo: rootContainerView.bottomAnchor
      ),
    ]);
    
    let dimmingView: UIView = {
      let view = UIView();
      view.backgroundColor = .black;
      view.alpha = 0.25;
      view.isHidden = true;
      
      let tapGesture = UITapGestureRecognizer(
        target: self,
        action: #selector(Self.handleOnTapDimmingView(_:))
      );
      
      tapGesture.isEnabled = true;
      view.addGestureRecognizer(tapGesture);
      
      return view;
    }();
    
    self.dimmingView = dimmingView;
    
    dimmingView.translatesAutoresizingMaskIntoConstraints = false;
    presentedController.view.addSubview(dimmingView)
    
    NSLayoutConstraint.activate([
      dimmingView.leadingAnchor.constraint(
        equalTo: presentedController.view.leadingAnchor
      ),
      dimmingView.trailingAnchor.constraint(
        equalTo: presentedController.view.trailingAnchor
      ),
      dimmingView.topAnchor.constraint(
        equalTo: presentedController.view.topAnchor
      ),
      dimmingView.bottomAnchor.constraint(
        equalTo: presentedController.view.bottomAnchor
      ),
    ]);
    
    targetViewSnapshot.frame = targetView.globalFrame ?? targetView.frame;
    presentedController.view.addSubview(targetViewSnapshot);
    
    auxiliaryPreviewController.view.translatesAutoresizingMaskIntoConstraints = false;
    presentedController.view.addSubview(auxiliaryPreviewController.view);
    
    let constraints: [NSLayoutConstraint] = {
      var constraints: [NSLayoutConstraint] = [];
      
      constraints.append(
        auxiliaryPreviewController.view.heightAnchor.constraint(
          equalToConstant: auxiliaryPreviewMetadata.computedHeight
        )
      );
      
      constraints.append(
        auxiliaryPreviewMetadata.verticalAnchorPosition.createVerticalConstraints(
          forView: auxiliaryPreviewController.view,
          attachingTo: targetViewSnapshot,
          margin: auxiliaryPreviewConfig.marginInner
        )
      );
      
      constraints += self.auxiliaryPreviewConfig.alignmentHorizontal.createHorizontalConstraints(
        forView: auxiliaryPreviewController.view,
        attachingTo: targetViewSnapshot,
        enclosingView: presentedController.view,
        preferredWidth: auxiliaryPreviewMetadata.computedWidth
      );
    
      return constraints;
    }();
    
    NSLayoutConstraint.activate(constraints);
  };
  
  func showModal(completion: (() -> Void)? = nil){
    guard let auxiliaryPreviewController = self.auxiliaryPreviewController,
          let targetView = self.targetView,
          
          let auxiliaryPreviewMetadata = self.auxiliaryPreviewMetadata
    else { return };
    
    let transitionConfigEntrance = self.auxiliaryPreviewConfig.transitionConfigEntrance;
    let transitionAnimationConfig = transitionConfigEntrance.transitionAnimationConfig ?? .default;
    
    let keyframes = transitionAnimationConfig.transition.getKeyframes();
    let animator = transitionAnimationConfig.animatorConfig.createAnimator(gestureInitialVelocity: .zero);
    
    keyframes.keyframeStart.apply(
      toView: auxiliaryPreviewController.view,
      auxPreviewVerticalAnchorPosition:
        auxiliaryPreviewMetadata.verticalAnchorPosition
    );
    
    animator.addAnimations {
      self.dimmingView?.isHidden = false;
    
      keyframes.keyframeEnd.apply(
        toView: auxiliaryPreviewController.view,
        auxPreviewVerticalAnchorPosition:
          auxiliaryPreviewMetadata.verticalAnchorPosition
      );
    };
    
    animator.addCompletion { _ in
      completion?();
    };
    
    targetView.alpha = 0;
    animator.startAnimation(afterDelay: transitionAnimationConfig.delay);
  };
  
  func hideModal(completion: (() -> Void)? = nil){
    guard let targetView = self.targetView,
          let rootModalContainerView = self.presentedController?.view,
          let auxiliaryPreviewMetadata = self.auxiliaryPreviewMetadata
    else { return };
    
    let animatorConfig: AnimationConfig =
      .presetCurve(duration: 0.3, curve: .easeOut);
    
    let animator =
      animatorConfig.createAnimator(gestureInitialVelocity: .zero);
    
    let transitionConfigExit = self.auxiliaryPreviewConfig.transitionConfigExit;
    let (exitKeyframe, _) = transitionConfigExit.getKeyframes();
    
    animator.addAnimations {
      exitKeyframe.apply(
        toView: rootModalContainerView,
        auxPreviewVerticalAnchorPosition:
          auxiliaryPreviewMetadata.verticalAnchorPosition
      );
      
      self.dimmingView?.alpha = 0;
    };
    
    animator.addCompletion() { _ in
      completion?();
    };
    
    targetView.alpha = 1;
    animator.startAnimation();
  };
  
  @objc func handleOnTapDimmingView(_ sender: UITapGestureRecognizer){
    self.presentedController?.dismiss(animated: true);
  };
  
  // MARK: - Functions
  // -----------------
  
  func present(
    viewControllerToPresent auxiliaryPreviewController: UIViewController,
    presentingViewController presentingController: UIViewController,
    targetView: UIView
  ) {
    
    self.auxiliaryPreviewController = auxiliaryPreviewController;
    self.presentingController = presentingController;
    self.targetView = targetView;
    
    let presentedController = AuxiliaryPreviewModalWrapperViewController();
    self.presentedController = presentedController;
    
    presentedController.addChild(auxiliaryPreviewController);
    presentedController.didMove(toParent: auxiliaryPreviewController);
    
    presentedController.modalPresentationStyle = .custom;
    presentedController.transitioningDelegate = self;
    
    self.prepareForPresentation();
    self.presentationState = .presenting;
    
    presentingController.present(presentedController, animated: true);
  };
};
