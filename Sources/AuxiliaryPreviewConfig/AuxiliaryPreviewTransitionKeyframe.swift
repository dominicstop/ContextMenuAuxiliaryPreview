//
//  AuxiliaryPreviewTransitionKeyframe.swift
//  
//
//  Created by Dominic Go on 10/23/23.
//

import UIKit
import DGSwiftUtilities


/// Derived from: `AuxiliaryPreviewTransitionKeyframeConfig`
public struct AuxiliaryPreviewTransitionKeyframe {

  public var opacity: CGFloat;
  public var transform: Transform3D;
  
  public init(
    keyframeCurrent: AuxiliaryPreviewTransitionKeyframeConfig,
    keyframePrevious keyframePrev: Self? = nil
  ) {
    self.opacity = keyframeCurrent.opacity
      ?? keyframePrev?.opacity
      ?? 1;
      
    self.transform = {
      let prevTransform = keyframePrev?.transform ?? .default;
    
      guard var nextTransform = keyframeCurrent.transform else {
        return prevTransform;
      };
      
      nextTransform.setNonNilValues(with: prevTransform);
      return nextTransform;
    }();
  };
  
  public func apply(
    auxiliaryPreviewView: UIView,
    auxiliaryPreviewMetadata: AuxiliaryPreviewMetadata
  ){
    auxiliaryPreviewView.alpha = self.opacity;
    
    auxiliaryPreviewView.layer.transform = {
      var transform = self.transform;
      
      switch auxiliaryPreviewMetadata.verticalAnchorPosition {
        case .top:
          transform.translateY = -transform.translateY;
          
        case .bottom:
          transform.rotateX = .degrees(-transform.rotateX.degrees);
      };
      
      return transform.transform;
    }();
  };
};
