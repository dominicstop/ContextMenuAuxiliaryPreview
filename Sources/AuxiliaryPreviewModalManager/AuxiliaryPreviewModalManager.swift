//
//  AuxiliaryPreviewModalManager.swift
//  experiment-message-tap-back
//
//  Created by Dominic Go on 11/7/23.
//

import UIKit


class AuxiliaryPreviewModalManager: NSObject {

  // MARK: - Embedded Types
  // ----------------------
  
  enum PresentationState {
    case presenting;
    case dismissing;
  };
  
  // MARK: - Properties
  // ------------------
  
  var menuAuxPreviewConfig: AuxiliaryPreviewConfig;
  var verticalAnchorPosition: VerticalAnchorPosition?;

  weak var presentingVC: UIViewController?;
  weak var targetView: UIView?;
  
  var modalRootView: UIView?;
  var dimmingView: UIView?;
  
  var modalWrapperVC: AuxiliaryPreviewModalWrapperViewController?;
  var presentedVC: UIViewController?;
  
  var presentationState: PresentationState?;

  init(menuAuxPreviewConfig: AuxiliaryPreviewConfig) {
    self.menuAuxPreviewConfig = menuAuxPreviewConfig;
    super.init();
  };
  
  // MARK: - Functions - Setup
  // -------------------------
  
  func setupViews(){
    guard let modalRootView = self.modalRootView,
          let modalWrapperVC = self.modalWrapperVC,
          let modalVC = self.presentedVC,
          let targetView = self.targetView,
          
          let targetViewSnapshot =
            targetView.snapshotView(afterScreenUpdates: true),
            
          let window = targetView.window
    else { return };
    
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
    
    targetViewSnapshot.frame = {
      guard let targetSuperview = targetView.superview
      else { return .zero };
      
      let globalPoint = targetSuperview.convert(
        targetView.frame.origin,
        to: nil
      );
      
      return .init(
        origin: globalPoint,
        size: targetView.frame.size
      );
    }();
    
    modalWrapperVC.view.addSubview(targetViewSnapshot);
    
    targetView.alpha = 0;
    
    modalVC.view.translatesAutoresizingMaskIntoConstraints = false;
    modalWrapperVC.view.addSubview(modalVC.view);
    
    let sizeValueContext = AuxiliaryPreviewSizeValue.Context(
      windowSize: window.bounds.size,
      previewFrame: targetView.frame
    );
    
    let auxiliaryPreviewViewWidth: CGFloat = {
      let computedWidth = self.menuAuxPreviewConfig.auxiliaryPreviewPreferredWidth?.compute(
        computingForSizeKey: \.width,
        usingContext: sizeValueContext
      );
      
      let fallbackWidth: CGFloat = {
        switch self.menuAuxPreviewConfig.alignmentHorizontal {
          case .stretch:
            return modalWrapperVC.view.frame.width;
        
          case .stretchTarget:
            return targetView.frame.size.width;
            
          default:
            return max(
              modalVC.preferredContentSize.width,
              modalVC.view.frame.size.width
            );
        };
      
      }();
      
      return computedWidth ?? fallbackWidth;
    }();
    
    let auxiliaryPreviewViewHeight: CGFloat = {
      let computedHeight = self.menuAuxPreviewConfig.auxiliaryPreviewPreferredHeight?.compute(
        computingForSizeKey: \.height,
        usingContext: sizeValueContext
      );
      
      let fallbackHeight = max(
        modalVC.preferredContentSize.height,
        modalVC.view.frame.size.height
      );
        
      return computedHeight ?? fallbackHeight;
    }();
    
    let verticalAnchorPosition: VerticalAnchorPosition = {
      switch self.menuAuxPreviewConfig.anchorPosition {
        case .top:
          return .top;
        
        case .bottom:
          return .bottom;
          
        case .automatic:
          let targetViewY = targetView.frame.midY;
          let rootViewY = modalWrapperVC.view.frame.midY;
          
          return targetViewY <= rootViewY ? .bottom : .top
      };
    }();
    
    self.verticalAnchorPosition = verticalAnchorPosition;
    
    let constraints: [NSLayoutConstraint] = {
      var constraints: [NSLayoutConstraint] = [];
      
      constraints.append(
        modalVC.view.heightAnchor.constraint(
          equalToConstant: auxiliaryPreviewViewHeight
        )
      );
      
      constraints.append(
        verticalAnchorPosition.createVerticalConstraints(
          forView: modalVC.view,
          attachingTo: targetViewSnapshot,
          margin: self.menuAuxPreviewConfig.auxiliaryPreviewMarginInner
        )
      );
      
      constraints += self.menuAuxPreviewConfig.alignmentHorizontal.createHorizontalConstraints(
        forView: modalVC.view,
        attachingTo: targetViewSnapshot,
        enclosingView: modalWrapperVC.view,
        preferredWidth: auxiliaryPreviewViewWidth
      );
    
      return constraints;
    }();
    
    NSLayoutConstraint.activate(constraints);
  };
  
  func showModal(completion: (() -> Void)? = nil){
    guard let modalRootView = self.modalRootView,
          let modalWrapperVC = self.modalWrapperVC,
          let modalVC = self.presentedVC,
          let targetView = self.targetView,
          let verticalAnchorPosition = self.verticalAnchorPosition,
        
          let window = targetView.window
    else { return };
    
    let transitionConfigEntrance = self.menuAuxPreviewConfig.transitionConfigEntrance;
    let transitionAnimationConfig = transitionConfigEntrance.transitionAnimationConfig ?? .default;
    
    let keyframes = transitionAnimationConfig.transition.getKeyframes();
    
    let animator = transitionAnimationConfig.animatorConfig.createAnimator(gestureInitialVelocity: .zero);
    
    keyframes.keyframeStart.apply(
      toView: modalVC.view,
      auxPreviewVerticalAnchorPosition: verticalAnchorPosition
    );
    
    animator.addAnimations {
      self.dimmingView?.isHidden = false;
    
      keyframes.keyframeEnd.apply(
        toView: modalVC.view,
        auxPreviewVerticalAnchorPosition: verticalAnchorPosition
      );
    };
    
    animator.addCompletion { _ in
      completion?();
    };
    
    animator.startAnimation(afterDelay: transitionAnimationConfig.delay);
  };
  
  func hideModal(completion: (() -> Void)? = nil){
    guard let modalRootView = self.modalRootView,
          let modalWrapperVC = self.modalWrapperVC,
          let modalVC = self.presentedVC,
          let targetView = self.targetView,
          
          let window = targetView.window
    else { return };
    
    targetView.alpha = 1;
    
    let animator = UIViewPropertyAnimator(duration: 0.3, curve: .linear);
    
    animator.addCompletion() { _ in
      completion?();
    };
    
    animator.addAnimations {
      self.modalWrapperVC?.view.alpha = 0;
      self.dimmingView?.isHidden = true;
    };
    
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
    
    self.presentationState = .presenting;
    
    presentingVC.present(modalWrapperVC, animated: true);
  };
};
