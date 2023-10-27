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

};
