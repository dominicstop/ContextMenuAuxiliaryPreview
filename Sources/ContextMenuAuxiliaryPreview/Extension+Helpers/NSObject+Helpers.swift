//
//  NSObject+Helpers.swift
//  
//
//  Created by Dominic Go on 10/7/23.
//

import Foundation


extension NSObject {
  var className: String {
    return NSStringFromClass(type(of: self));
  };
};
