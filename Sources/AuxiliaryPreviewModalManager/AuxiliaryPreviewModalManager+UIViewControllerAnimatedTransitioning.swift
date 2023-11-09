//
//  AuxiliaryPreviewModalManager+UIViewControllerAnimatedTransitioning.swift
//  experiment-message-tap-back
//
//  Created by Dominic Go on 11/7/23.
//

import Foundation
import UIKit


extension AuxiliaryPreviewModalManager: UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 1;
  };
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let presentationState = self.presentationState,
          let fromVC = transitionContext.viewController(forKey: .from)
    else { return };
    
    switch presentationState {
      case .presenting:
        let containerView = transitionContext.containerView;
        self.modalRootView = containerView;
        
        self.setupViews();
        
        self.showModal() {
          transitionContext.completeTransition(true);
        };
        
      case .dismissing:
        self.hideModal() {
          transitionContext.completeTransition(true);
        };
        
        break;
    };
  };
};


