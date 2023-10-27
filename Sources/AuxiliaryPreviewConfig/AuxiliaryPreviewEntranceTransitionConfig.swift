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
  
  case customDelay(
    delay: TimeInterval,
    animatorConfig: AnimationConfig,
    transition: AuxiliaryPreviewTransitionConfig
  );
  
  case afterMenuEntranceTransition(
    delay: TimeInterval,
    animatorConfig: AnimationConfig,
    transition: AuxiliaryPreviewTransitionConfig
  );
  
  // MARK: - Computed Properties
  // ---------------------------
  
  var delay: TimeInterval? {
    switch self {
      case let .customDelay(delay, _, _):
        return delay;
        
      case let .afterMenuEntranceTransition(delay, _, _):
        return delay;
        
      default:
        return nil;
    };
  };
  
  var animatorConfig: AnimationConfig? {
    switch self {
      case let .customDelay(_, animatorConfig, _):
        return animatorConfig;
        
      case let .afterMenuEntranceTransition(_, animatorConfig, _):
        return animatorConfig;
        
      default:
        return nil;
    };
  };
  
  var transition: AuxiliaryPreviewTransitionConfig? {
    switch self {
      case let .customDelay(_, _, transition):
        return transition;
        
      case let .afterMenuEntranceTransition(_, _, transition):
        return transition;
        
      default:
        return nil;
    };
  };
};
