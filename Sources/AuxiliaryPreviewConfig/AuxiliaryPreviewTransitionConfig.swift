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
  
  public init(transitionPreset: AuxiliaryPreviewTransitionPreset) {
    (self.keyframeConfigStart, self.keyframeConfigEnd) =
      transitionPreset.transitionKeyframeConfig;
  };

  // MARK: - Functions
  // -----------------
  
  public mutating func reverseKeyframes(){
    let tempCopy = self;
    
    self.keyframeConfigEnd = tempCopy.keyframeConfigStart;
    self.keyframeConfigStart = tempCopy.keyframeConfigStart;
  };
  
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
