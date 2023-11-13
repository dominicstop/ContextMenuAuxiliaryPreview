//
//  AuxiliaryPreviewTransitionConfig.swift
//  
//
//  Created by Dominic Go on 10/23/23.
//

import Foundation


public struct AuxiliaryPreviewTransitionConfig {

  public var keyframeConfigStart: AuxiliaryPreviewTransitionKeyframeConfig;
  public var keyframeConfigEnd: AuxiliaryPreviewTransitionKeyframeConfig;
  
  public init(
    transitionType: AuxiliaryPreviewTransitionType
  ) {
    (self.keyframeConfigStart, self.keyframeConfigEnd) =
      transitionType.transitionKeyframeConfig;
  };

  // MARK: - Functions
  // -----------------
  
  public func getKeyframes() -> (
    keyframeStart: AuxiliaryPreviewTransitionKeyframe,
    keyframeEnd: AuxiliaryPreviewTransitionKeyframe
  ) {
  
    var keyframeStart = AuxiliaryPreviewTransitionKeyframe(
      keyframeCurrent: self.keyframeConfigStart
    );
    
    let keyframeEnd = AuxiliaryPreviewTransitionKeyframe(
      keyframeCurrent: self.keyframeConfigEnd,
      keyframePrevious: keyframeStart
    );
    
    keyframeStart = AuxiliaryPreviewTransitionKeyframe(
      keyframeCurrent: self.keyframeConfigStart,
      keyframePrevious: keyframeEnd
    );
    
    return (keyframeStart, keyframeEnd);
  };
};
