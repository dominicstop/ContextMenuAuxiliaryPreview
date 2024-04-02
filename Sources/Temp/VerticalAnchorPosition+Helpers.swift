//
//  VerticalAnchorPosition+Helpers.swift
//  ContextMenuAuxiliaryPreview
//
//  Created by Dominic Go on 4/2/24.
//

import Foundation
import DGSwiftUtilities

public extension VerticalAnchorPosition {
  
  var opposite: Self {
    switch self {
      case .top:
        return .bottom;
        
      case .bottom:
        return .top;
    };
  };
};
