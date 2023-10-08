//
//  ContextMenuPlatterTransitionViewWrapper.swift
//  
//
//  Created by Dominic Go on 10/8/23.
//

import UIKit


/// Wrapper for: `_UIContextMenuPlatterTransitionView`
class ContextMenuPlatterTransitionViewWrapper:
  ObjectWrapperBase<UIView, ContextMenuPlatterTransitionViewWrapper.EncodedString> {

  enum EncodedString: String, ObjectWrappingEncodedString {
    case className;
    
    var encodedString: String {
      switch self {
        case .className:
          // _UIContextMenuPlatterTransitionView
          return "X1VJQ29udGV4dE1lbnVQbGF0dGVyVHJhbnNpdGlvblZpZXc=";
      };
    };
  };
  
  // MARK: - Computed Properties
  // ---------------------------
  
  var contextMenuViewWrapper: ContextMenuViewWrapper? {
    guard let view = self.wrappedObject else { return nil };
    
    return view.subviews.reduce(nil) {
      $0 ?? .init(objectToWrap: $1)
    };
  };
  
};

