//
//  UIView+Helpers.swift
//  
//
//  Created by Dominic Go on 11/14/23.
//

import UIKit

// TODO: Move to `DGSwiftUtilites`
extension UIView {
  
  public var heightConstraint: NSLayoutConstraint? {
    self.constraints.first {
      $0.firstAttribute == .height
    };
  };
  
  public var widthConstraint: NSLayoutConstraint? {
    self.constraints.first {
      $0.firstAttribute == .height
    };
  };
};
