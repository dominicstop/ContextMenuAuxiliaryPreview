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
            targetView.snapshotView(afterScreenUpdates: true)
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
    
    NSLayoutConstraint.activate([
      modalVC.view.widthAnchor.constraint(
        equalToConstant: 100
      ),
      modalVC.view.heightAnchor.constraint(
        equalToConstant: 100
      ),
      
      modalVC.view.bottomAnchor.constraint(
        equalTo: targetViewSnapshot.topAnchor,
        constant: -10
      ),
      
      modalVC.view.centerXAnchor.constraint(
        equalTo: targetViewSnapshot.centerXAnchor
      ),
    ]);
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
