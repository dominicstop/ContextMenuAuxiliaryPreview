//
//  ContextMenuContainerView.swift.swift
//  
//
//  Created by Dominic Go on 10/8/23.
//

import UIKit


/// Wrapper for: _UIContextMenuContainerView
/// This is the "root view" that contains the context menut
///
/// **Note**: This `UIView` instance  only exists whenever there's a
/// context menu interaction.
///
class ContextMenuContainerViewWrapper:
  ObjectWrapperBase<UIView, ContextMenuContainerViewWrapper.EncodedString> {

  enum EncodedString: String, ObjectWrappingEncodedString {
    case className;
    
    var encodedString: String {
      switch self {
        case .className:
          // _UIContextMenuContainerView
          return "X1VJQ29udGV4dE1lbnVDb250YWluZXJWaWV3";
      };
    };
};

  
  // MARK: - Computed Properties
  // ---------------------------
  
  var backgroundVisualEffectView: UIVisualEffectView? {
    guard let view = self.wrappedObject else { return nil };
    
    return view.subviews.reduce(nil){
      $0 ?? ($1 as? UIVisualEffectView)
    };
  };
  
  /// Returns the "object wrapper" for the view contains the
  ///  "context menu items" + "context menu preview".
  var contextMenuPlatterTransitionViewWrapper: ContextMenuPlatterTransitionViewWrapper? {
    guard let view = self.wrappedObject else { return nil };
    
    return view.subviews.reduce(nil) {
      $0 ?? .init(objectToWrap: $1)
    };
  };
};
