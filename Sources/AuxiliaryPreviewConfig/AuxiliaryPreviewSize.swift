//
//  AuxiliaryPreviewSize.swift
//  
//
//  Created by Dominic Go on 10/25/23.
//

import Foundation


public enum AuxiliaryPreviewSize {
  case constant(CGFloat);
  case percentRelativeToWindow(CGFloat);
  case percentRelativeToPreview(CGFloat);
};
