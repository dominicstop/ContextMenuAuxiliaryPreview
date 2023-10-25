//
//  AuxiliaryPreviewHorizontalAlignment.swift
//  
//
//  Created by Dominic Go on 10/25/23.
//

import Foundation


public enum AuxiliaryPreviewHorizontalAlignment {
  case stretchPreview;
  case stretchScreen;
  
  case previewLeading(width: CGFloat);
  case previewTrailing(width: CGFloat);
  case previewCenter(width: CGFloat);
};
