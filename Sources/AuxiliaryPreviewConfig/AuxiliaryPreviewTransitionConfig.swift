//
//  AuxiliaryPreviewTransitionConfig.swift
//  
//
//  Created by Dominic Go on 10/23/23.
//

import Foundation


public struct AuxiliaryPreviewTransitionConfig {

  public var transitionType: AuxiliaryPreviewTransitionType;
  
  public init(transitionType: AuxiliaryPreviewTransitionType) {
    self.transitionType = transitionType;
  };

  // MARK: - Functions
  // -----------------
  
  public func getKeyframes() -> (
    keyframeStart: AuxiliaryPreviewTransitionKeyframe,
    keyframeEnd: AuxiliaryPreviewTransitionKeyframe
  ) {
  
    let transitionKeyframeConfig = self.transitionType.transitionKeyframeConfig;
  
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
