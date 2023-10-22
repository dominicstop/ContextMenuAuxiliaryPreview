//
//  AuxiliaryPreviewTransitionKeyframe.swift
//  
//
//  Created by Dominic Go on 10/23/23.
//

import UIKit


struct AuxiliaryPreviewTransitionKeyframe {
  var opacity: CGFloat;
  
  init(
    keyframeCurrent: AuxiliaryPreviewTransitionKeyframeConfig,
    keyframePrevious keyframePrev: Self? = nil
  ) {
    self.opacity = keyframeCurrent.opacity
      ?? keyframePrev?.opacity
      ?? 1;
  };
};
