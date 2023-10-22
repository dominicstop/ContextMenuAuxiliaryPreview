//
//  StaticAlias.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 6/21/23.
//

import UIKit

extension CACornerMask {

  public static let uniqueElements: [Self] = [
    .layerMinXMinYCorner,
    .layerMaxXMinYCorner,
    .layerMinXMaxYCorner,
    .layerMaxXMaxYCorner,
  ];

  public static let allCorners: Self = [
    .layerMinXMinYCorner,
    .layerMaxXMinYCorner,
    .layerMinXMaxYCorner,
    .layerMaxXMaxYCorner,
  ];

  public static let topCorners: Self = [
    .layerMinXMinYCorner,
    .layerMaxXMinYCorner,
  ];
  
  public static let bottomCorners: Self = [
    .layerMinXMaxYCorner,
    .layerMaxXMaxYCorner,
  ];
  
  public static let leftCorners: Self = [
    .layerMinXMinYCorner,
    .layerMinXMaxYCorner,
  ];
  
  public static let rightCorners: Self = [
    .layerMaxXMinYCorner,
    .layerMaxXMaxYCorner,
  ];
  
  public var isMaskingTopCorners: Bool {
       self.contains(.layerMinXMinYCorner)
    || self.contains(.layerMaxXMinYCorner);
  };
       
    
  public var isMaskingLeftCorners: Bool {
       self.contains(.layerMinXMinYCorner)
    || self.contains(.layerMinXMaxYCorner);
  };
       
    
  public var isMaskingBottomCorners: Bool {
       self.contains(.layerMinXMaxYCorner)
    || self.contains(.layerMaxXMaxYCorner);
  };
       
    
  public var isMaskingRightCorners: Bool {
       self.contains(.layerMaxXMinYCorner)
    || self.contains(.layerMaxXMaxYCorner);
  };
  
  public var count: Int {
    var count = 0;
  
    Self.uniqueElements.forEach {
      guard self.contains($0) else { return };
      count += 1;
    };
    
    return count;
  };
};
