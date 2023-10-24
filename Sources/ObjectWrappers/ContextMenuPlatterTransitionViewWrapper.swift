//
//  ContextMenuPlatterTransitionViewWrapper.swift
//  
//
//  Created by Dominic Go on 10/8/23.
//

import UIKit
import DGSwiftUtilities

/// Wrapper for: `_UIContextMenuPlatterTransitionView`
///
/// This is a wrapper for the view that holds the "context menu items", and
/// the  "context menu preview".
/// 
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
  
  /// Root container for the context menu items
  /// i.e. holds the context menu items
  var contextMenuViewWrapper: ContextMenuViewWrapper? {
    guard let view = self.wrappedObject else { return nil };
    
    return view.subviews.reduce(nil) {
      $0 ?? .init(objectToWrap: $1)
    };
  };
  
  /// Root container for the context menu preview.
  /// i.e. holds the context menu preview.
  var morphingPlatterViewWrapper: MorphingPlatterViewWrapper? {
    guard let view = self.wrappedObject else { return nil };
    
    return view.subviews.reduce(nil) {
      $0 ?? .init(objectToWrap: $1)
    };
  };
};
