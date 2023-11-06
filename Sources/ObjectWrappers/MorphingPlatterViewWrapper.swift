//
//  MorphingPlatterViewWrapper.swift
//  
//
//  Created by Dominic Go on 10/9/23.
//

import UIKit
import DGSwiftUtilities


/// Wrapper for: `_UIMorphingPlatterView`
/// Root container for the context menu preview
class MorphingPlatterViewWrapper:
  PrivateObjectWrapper<UIView, MorphingPlatterViewWrapper.EncodedString> {
  
  enum EncodedString: String, PrivateObjectWrappingEncodedString {
    case className;
    
    var encodedString: String {
      switch self {
        case .className:
          // _UIMorphingPlatterView
          return "X1VJTW9ycGhpbmdQbGF0dGVyVmlldw==";
      };
    };
  };
};
