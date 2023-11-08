//
//  HorizontalAnchorPosition.swift
//  
//
//  Created by Dominic Go on 10/25/23.
//

import UIKit


public enum HorizontalAnchorPosition {
  case stretch;
  case stretchTarget;
  
  case targetLeading;
  case targetTrailing;
  case targetCenter;
  
  // MARK: - Functions
  // -----------------
  
  public func createHorizontalConstraints(
    forView view: UIView,
    attachingTo targetView: UIView,
    enclosingView: UIView,
    preferredWidth: CGFloat,
    marginLeading: CGFloat = 0,
    marginTrailing: CGFloat = 100
  ) -> [NSLayoutConstraint] {
  
    let widthAnchor = view.widthAnchor.constraint(
      equalToConstant: preferredWidth
    );
  
    switch self {
      // A - pin to left
      case .targetLeading: return [
        widthAnchor,
        view.leadingAnchor.constraint(
          equalTo: targetView.leadingAnchor,
          constant: marginLeading
        ),
      ];
      
      // B - pin to right
      case .targetTrailing: return [
        widthAnchor,
        view.trailingAnchor.constraint(
          equalTo: targetView.trailingAnchor,
          constant: -marginTrailing
        ),
      ];
      
      // C - pin to center
      case .targetCenter: return [
        widthAnchor,
        view.centerXAnchor.constraint(
          equalTo: targetView.centerXAnchor
        ),
      ];
      
      // D - match preview size
      case .stretchTarget: return [
        view.leadingAnchor.constraint(
          equalTo: targetView.leadingAnchor,
          constant: marginLeading
        ),
        
        view.trailingAnchor.constraint(
          equalTo: targetView.trailingAnchor,
          constant: marginTrailing
        ),
      ];
      
      // E - stretch to edges of screen
      case .stretch: return [
        view.leadingAnchor.constraint(
          equalTo: enclosingView.leadingAnchor,
          constant: marginLeading
        ),
        
        view.trailingAnchor.constraint(
          equalTo: enclosingView.trailingAnchor,
          constant: marginTrailing
        ),
      ];
    };
  };
};
