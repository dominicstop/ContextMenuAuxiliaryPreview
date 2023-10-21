//
//  Optional+OptionalUnwrappable.swift
//  
//
//  Created by Dominic Go on 8/7/23.
//

import Foundation


protocol OptionalUnwrappable {
  func isSome() -> Bool;
  func unwrap() -> Any;
}

extension Optional: OptionalUnwrappable {

  func isSome() -> Bool {
    switch self {
      case .none: return false;
      case .some: return true;
    };
  };

  func unwrap() -> Any {
    switch self {
      case .none:
        preconditionFailure("trying to unwrap nil");
        
      case let .some(value):
        return value;
    };
  };
};
