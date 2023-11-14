//
//  AuxiliaryPreviewEntranceTransitionConfig.swift
//  
//
//  Created by Dominic Go on 10/28/23.
//

import UIKit
import DGSwiftUtilities


public enum AuxiliaryPreviewEntranceTransitionConfig {

  case syncedToMenuEntranceTransition;
  
  case customDelay(AuxiliaryPreviewTransitionAnimationConfig);
  
  case afterMenuEntranceTransition(AuxiliaryPreviewTransitionAnimationConfig);
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var transitionAnimationConfig: AuxiliaryPreviewTransitionAnimationConfig? {
    switch self {
      case .syncedToMenuEntranceTransition:
        return nil;
        
      case var .customDelay(config):
        config.transition.reverseKeyframes();
        return config;
        
      case var .afterMenuEntranceTransition(config):
        config.transition.reverseKeyframes();
        return config
    };
  };
};
