//
//  AuxiliaryPreviewMenuMetadata.swift
//  
//
//  Created by Dominic Go on 10/27/23.
//

import UIKit


public struct AuxiliaryPreviewMetadata {
  
  /// whether to attach the `auxiliaryView` on the top or bottom
  var verticalAnchorPosition: VerticalAnchorPosition;
  
  var computedHeight: CGFloat;
  var computedWidth: CGFloat;
  
  var offsetY: CGFloat;
  
  // MARK: - Init
  // ------------
  
  init(
    verticalAnchorPosition: VerticalAnchorPosition,
    computedHeight: CGFloat,
    computedWidth: CGFloat,
    offsetY: CGFloat
  ) {
  
    self.verticalAnchorPosition = verticalAnchorPosition;
    self.computedHeight = computedHeight;
    self.computedWidth = computedWidth;
    self.offsetY = offsetY;
  };
};
