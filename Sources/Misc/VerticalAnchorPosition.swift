//
//  VerticalAnchorPosition.swift
//  
//
//  Created by Dominic Go on 11/9/23.
//

import UIKit

// TODO: Move to `DGSwiftUtilities`
public enum VerticalAnchorPosition: String {

  case top, bottom;
  
  // MARK: - Functions
  // -----------------
  
  public func createVerticalConstraints(
    forView view: UIView,
    attachingTo targetView: UIView,
    margin: CGFloat
  ) -> NSLayoutConstraint {
  
    switch self {
      case .top:
        return view.bottomAnchor.constraint(
         equalTo: targetView.topAnchor,
         constant: -margin
        );
        
      case .bottom:
        return view.topAnchor.constraint(
          equalTo: targetView.bottomAnchor,
          constant: margin
        );
    };
  };
};
