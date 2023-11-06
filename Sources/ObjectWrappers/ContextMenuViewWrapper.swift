//
//  ContextMenuViewWrapper.swift
//  
//
//  Created by Dominic Go on 10/9/23.
//

import UIKit
import DGSwiftUtilities


/// Wrapper for: `_UIContextMenuView`
/// Root container for the context menu items
class ContextMenuViewWrapper:
  PrivateObjectWrapper<UIView, ContextMenuViewWrapper.EncodedString> {
  
  enum EncodedString: String, PrivateObjectWrappingEncodedString {
    case className;
    
    var encodedString: String {
      switch self {
        case .className:
          // _UIContextMenuView
          return "X1VJQ29udGV4dE1lbnVWaWV3";
      };
    };
  };
};

