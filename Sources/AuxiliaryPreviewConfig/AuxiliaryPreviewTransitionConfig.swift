//
//  AuxiliaryPreviewTransitionConfig.swift
//  
//
//  Created by Dominic Go on 10/23/23.
//

import Foundation


public enum AuxiliaryPreviewTransitionConfig {
  
  // TBA: slide, zoom, zoomAndSlide, custom
  
  case none;
  case fade;
  
  public var transitionKeyframeConfig: (
    keyframeStart: AuxiliaryPreviewTransitionKeyframeConfig,
    keyframeEnd  : AuxiliaryPreviewTransitionKeyframeConfig
  ) {
    switch self {
      case .none:
        return (
          keyframeStart: .init(
            opacity: 1
          ),
          keyframeEnd: .init(
            opacity: 1
          )
        );
        
      case .fade:
        return (
          keyframeStart: .init(
            opacity: 0
          ),
          keyframeEnd: .init(
            opacity: 1
          )
        );
    };
  };
  
  public func getKeyframes() -> (
    keyframeStart: AuxiliaryPreviewTransitionKeyframe,
    keyframeEnd  : AuxiliaryPreviewTransitionKeyframe
  ) {
  
    let transitionKeyframeConfig = self.transitionKeyframeConfig;
  
    var keyframeStart = AuxiliaryPreviewTransitionKeyframe(
      keyframeCurrent: transitionKeyframeConfig.keyframeStart
    );
    
    let keyframeEnd = AuxiliaryPreviewTransitionKeyframe(
      keyframeCurrent: transitionKeyframeConfig.keyframeEnd,
      keyframePrevious: keyframeStart
    );
    
    keyframeStart = AuxiliaryPreviewTransitionKeyframe(
      keyframeCurrent: transitionKeyframeConfig.keyframeStart,
      keyframePrevious: keyframeEnd
    );
    
    return (keyframeStart, keyframeEnd);
  };
};
