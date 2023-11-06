//
//  ContextMenuInteractionWrapper.swift
//  
//
//  Created by Dominic Go on 11/6/23.
//

import UIKit
import DGSwiftUtilities


public class ContextMenuInteractionWrapper: ObjectWrapper<
  UIContextMenuInteraction,
  ContextMenuInteractionWrapper.EncodedString
> {
  
  public enum EncodedString: String, HashedStringDecodable {
    case presentMenuAtLocation;
    
    public var encodedString: String {
      switch self {
        case .presentMenuAtLocation:
          // _presentMenuAtLocation
          return "X3ByZXNlbnRNZW51QXRMb2NhdGlvbg==";
      };
    };
  };
  
  public func presentMenuAtLocation(point: CGPoint) throws {
    try self.performSelector(
      usingEncodedString: .presentMenuAtLocation,
      withArg1: point
    )
  };
};

