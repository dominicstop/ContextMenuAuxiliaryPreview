//
//  AuxiliaryPreviewTransitionConfigPreset.swift
//  
//
//  Created by Dominic Go on 10/23/23.
//

import Foundation


enum AuxiliaryPreviewTransitionConfigPreset {

  case none;
  case fade;
  
  var transitionConfig: AuxiliaryPreviewTransitionConfig {
    switch self {
      case .none:
        return .init(
          keyframeStart: .init(
            opacity: 1
          ),
          keyframeEnd: .init(
            opacity: 1
          )
        );
        
      case .fade:
        return .init(
          keyframeStart: .init(
            opacity: 0
          ),
          keyframeEnd: .init(
            opacity: 1
          )
        );
    };
  };
};
