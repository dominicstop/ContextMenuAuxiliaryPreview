//
//  AuxiliaryPreviewTransitionConfig.swift
//  
//
//  Created by Dominic Go on 10/23/23.
//

import Foundation


struct AuxiliaryPreviewTransitionConfig {

  var keyframeStart: AuxiliaryPreviewTransitionKeyframeConfig;
  var keyframeEnd: AuxiliaryPreviewTransitionKeyframeConfig;
  
  func getKeyframes() -> (
    keyframeStart: AuxiliaryPreviewTransitionKeyframe,
    keyframeEnd  : AuxiliaryPreviewTransitionKeyframe
  ){
  
    var keyframeStart = AuxiliaryPreviewTransitionKeyframe(
      keyframeCurrent: self.keyframeStart
    );
    
    var keyframeEnd = AuxiliaryPreviewTransitionKeyframe(
      keyframeCurrent: self.keyframeEnd,
      keyframePrevious: keyframeStart
    );
    
    keyframeStart = AuxiliaryPreviewTransitionKeyframe(
      keyframeCurrent: self.keyframeStart,
      keyframePrevious: keyframeEnd
    );
    
    return (keyframeStart, keyframeStart);
  };
};
