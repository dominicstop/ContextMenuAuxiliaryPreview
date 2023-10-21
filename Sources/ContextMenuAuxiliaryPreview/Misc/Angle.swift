//
//  File.swift
//  
//
//  Created by Dominic Go on 8/7/23.
//

import Foundation


public enum Angle<T: FloatingPoint>: Equatable {

  case zero;
  case radians(T);
  case degrees(T);
  
  public var radians: T {
    switch self {
      case .zero:
        return 0;
      
      case let .degrees(value):
        let pi = type(of: value).pi;
        return value * (pi / 180);
        
      case let .radians(value):
        return value;
    };
  };
  
  public var degrees: T {
    switch self {
      case .zero:
        return 0;
    
      case let .degrees(value):
        return value;
        
      case let .radians(value):
        let pi = type(of: value).pi;
        return value * (180 / pi);
    };
  };
};
