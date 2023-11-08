//
//  AuxiliaryPreviewTransitionKeyframeConfig.swift
//  
//
//  Created by Dominic Go on 10/23/23.
//

import UIKit
import DGSwiftUtilities


public struct AuxiliaryPreviewTransitionKeyframeConfig {
  public var opacity: CGFloat?;
  public var transform: Transform3D?;
  
  public init(
    opacity: CGFloat? = nil,
    transform: Transform3D? = nil
  ) {
  
    self.opacity = opacity;
    self.transform = transform;
  };
};
