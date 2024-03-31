//
//  ContextMenuContainerView.swift.swift
//  
//
//  Created by Dominic Go on 10/8/23.
//

import UIKit
import DGSwiftUtilities


/// Wrapper for: _UIContextMenuContainerView
/// This is the "root view" that contains the context menu
///
/// **Note**: This `UIView` instance  only exists whenever there's a
/// context menu interaction.
///
@available(iOS 13, *)
public class ContextMenuContainerViewWrapper:
  PrivateObjectWrapper<UIView, ContextMenuContainerViewWrapper.EncodedString> {

  public enum EncodedString: String, PrivateObjectWrappingEncodedString {
    case className;
    
    public var encodedString: String {
      switch self {
        case .className:
          // _UIContextMenuContainerView
          return "X1VJQ29udGV4dE1lbnVDb250YWluZXJWaWV3";
      };
    };
  };

  // MARK: - Computed Properties
  // ---------------------------
  
  public var backgroundVisualEffectView: UIVisualEffectView? {
    guard let view = self.wrappedObject else { return nil };
    
    return view.subviews.reduce(nil){
      $0 ?? ($1 as? UIVisualEffectView)
    };
  };
  
  /// Returns the "object wrapper" for the view contains the
  ///  "context menu items" + "context menu preview".
  @available(iOS 16.0, *)
  public var contextMenuPlatterTransitionViewWrapper: ContextMenuPlatterTransitionViewWrapper? {
    guard let view = self.wrappedObject else { return nil };
    
    return view.subviews.reduce(nil) {
      $0 ?? .init(objectToWrap: $1)
    };
  };
  
  @available(iOS 15, *)
  public var morphingPlatterViewWrapper: MorphingPlatterViewWrapper? {
    guard let view = self.wrappedObject else { return nil };
    
    let targetView = view.subviews.first {
      $0.subviews.count > 1 && !($0 is UIVisualEffectView);
    };
    
    guard let targetView = targetView else { return nil };
    return targetView.subviews.reduce(nil) {
      $0 ?? .init(objectToWrap: $1)
    };
  };
};
