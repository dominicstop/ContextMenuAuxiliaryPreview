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
      
    self.transform = keyframeCurrent.transform
      ?? keyframePrev?.transform
      ?? .default;
  };
  
  public func apply(toView view: UIView){
    view.alpha = self.opacity;
    view.layer.transform = self.transform.transform;
  };
};
