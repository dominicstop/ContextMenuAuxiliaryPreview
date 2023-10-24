//
//  AuxiliaryPreviewTransitionKeyframe.swift
//  
//
//  Created by Dominic Go on 10/23/23.
//

import UIKit


/// Derived from: `AuxiliaryPreviewTransitionKeyframeConfig`
public struct AuxiliaryPreviewTransitionKeyframe {
  public var opacity: CGFloat;
  
  public init(
    keyframeCurrent: AuxiliaryPreviewTransitionKeyframeConfig,
    keyframePrevious keyframePrev: Self? = nil
  ) {
    self.opacity = keyframeCurrent.opacity
      ?? keyframePrev?.opacity
      ?? 1;
  };
  
  public func apply(toView view: UIView){
    view.alpha = self.opacity;
  };
};
