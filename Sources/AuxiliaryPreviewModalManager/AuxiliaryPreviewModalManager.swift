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

  weak var presentingVC: UIViewController?;
  weak var targetView: UIView?;
  
  var modalRootView: UIView?;
  var dimmingView: UIView?;
  
  var modalWrapperVC: AuxiliaryPreviewModalWrapperViewController?;
  var presentedVC: UIViewController?;
  
  var presentationState: PresentationState?;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  var isPresenting: Bool {
    guard let modalWrapperVC = self.modalWrapperVC else { return false };
    let presentingVC = modalWrapperVC.presentingViewController;
    
    let isPresentingModalWrapperVC =
      presentingVC?.presentedViewController === modalWrapperVC;
      
    return modalWrapperVC.isBeingPresented || isPresentingModalWrapperVC;
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
    guard let modalRootView = self.modalRootView,
          let modalWrapperVC = self.modalWrapperVC,
          let modalVC = self.presentedVC,
          let targetView = self.targetView,
          
          let targetViewSnapshot =
            targetView.snapshotView(afterScreenUpdates: true),

          let auxiliaryPreviewMetadata = self.auxiliaryPreviewMetadata
    else { return };
    
    let auxiliaryPreviewConfig = self.auxiliaryPreviewConfig;
    
    modalWrapperVC.view.translatesAutoresizingMaskIntoConstraints = false;
    modalRootView.addSubview(modalWrapperVC.view)
    
    NSLayoutConstraint.activate([
      modalWrapperVC.view.leadingAnchor.constraint(
        equalTo: modalRootView.leadingAnchor
      ),
      modalWrapperVC.view.trailingAnchor.constraint(
        equalTo: modalRootView.trailingAnchor
      ),
      modalWrapperVC.view.topAnchor.constraint(
        equalTo: modalRootView.topAnchor
      ),
      modalWrapperVC.view.bottomAnchor.constraint(
        equalTo: modalRootView.bottomAnchor
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
    modalWrapperVC.view.addSubview(dimmingView)
    
    NSLayoutConstraint.activate([
      dimmingView.leadingAnchor.constraint(
        equalTo: modalWrapperVC.view.leadingAnchor
      ),
      dimmingView.trailingAnchor.constraint(
        equalTo: modalWrapperVC.view.trailingAnchor
      ),
      dimmingView.topAnchor.constraint(
        equalTo: modalWrapperVC.view.topAnchor
      ),
      dimmingView.bottomAnchor.constraint(
        equalTo: modalWrapperVC.view.bottomAnchor
      ),
    ]);
    
    targetViewSnapshot.frame = targetView.globalFrame ?? targetView.frame;
    modalWrapperVC.view.addSubview(targetViewSnapshot);
    
    modalVC.view.translatesAutoresizingMaskIntoConstraints = false;
    modalWrapperVC.view.addSubview(modalVC.view);
    
    let constraints: [NSLayoutConstraint] = {
      var constraints: [NSLayoutConstraint] = [];
      
      constraints.append(
        modalVC.view.heightAnchor.constraint(
          equalToConstant: auxiliaryPreviewMetadata.computedHeight
        )
      );
      
      constraints.append(
        auxiliaryPreviewMetadata.verticalAnchorPosition.createVerticalConstraints(
          forView: modalVC.view,
          attachingTo: targetViewSnapshot,
          margin: auxiliaryPreviewConfig.marginInner
        )
      );
      
      constraints += self.auxiliaryPreviewConfig.alignmentHorizontal.createHorizontalConstraints(
        forView: modalVC.view,
        attachingTo: targetViewSnapshot,
        enclosingView: modalWrapperVC.view,
        preferredWidth: auxiliaryPreviewMetadata.computedWidth
      );
    
      return constraints;
    }();
    
    NSLayoutConstraint.activate(constraints);
  };
  
  func showModal(completion: (() -> Void)? = nil){
    guard let modalVC = self.presentedVC,
          let targetView = self.targetView,
          
          let auxiliaryPreviewMetadata = self.auxiliaryPreviewMetadata
    else { return };
    
    let transitionConfigEntrance = self.auxiliaryPreviewConfig.transitionConfigEntrance;
    let transitionAnimationConfig = transitionConfigEntrance.transitionAnimationConfig ?? .default;
    
    let keyframes = transitionAnimationConfig.transition.getKeyframes();
    let animator = transitionAnimationConfig.animatorConfig.createAnimator(gestureInitialVelocity: .zero);
    
    keyframes.keyframeStart.apply(
      toView: modalVC.view,
      auxPreviewVerticalAnchorPosition:
        auxiliaryPreviewMetadata.verticalAnchorPosition
    );
    
    animator.addAnimations {
      self.dimmingView?.isHidden = false;
    
      keyframes.keyframeEnd.apply(
        toView: modalVC.view,
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
          let rootModalContainerView = self.modalWrapperVC?.view,
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
    self.modalWrapperVC?.dismiss(animated: true);
  };
  
  // MARK: - Functions
  // -----------------
  
  func present(
    viewControllerToPresent presentedVC: UIViewController,
    presentingViewController presentingVC: UIViewController,
    targetView: UIView
  ) {
    
    self.presentedVC = presentedVC;
    self.presentingVC = presentingVC;
    self.targetView = targetView;
    
    let modalWrapperVC = AuxiliaryPreviewModalWrapperViewController();
    self.modalWrapperVC = modalWrapperVC;
    
    modalWrapperVC.addChild(presentedVC);
    modalWrapperVC.didMove(toParent: presentedVC);
    
    modalWrapperVC.modalPresentationStyle = .custom;
    modalWrapperVC.transitioningDelegate = self;
    
    self.prepareForPresentation();
    self.presentationState = .presenting;
    
    presentingVC.present(modalWrapperVC, animated: true);
  };
};
