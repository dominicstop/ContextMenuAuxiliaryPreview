//
//  UIView+Helpers.swift
//  ContextMenuAuxiliaryPreview
//
//  Created by Dominic Go on 4/1/24.
//

import UIKit


extension UIView {
  var recursivelyGetAllSuperviews: [UIView] {
    var parentViews: [UIView] = [];
    var currentView = self;
    
    while true {
      guard let superview = currentView.superview else { return parentViews };
      parentViews.append(superview);
      currentView = superview;
    };
  };
};

