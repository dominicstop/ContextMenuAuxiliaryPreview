//
//  ObjectWrapping.swift
//  
//
//  Created by Dominic Go on 9/18/23.
//

import Foundation


class ObjectWrapperBase<WrapperType, EncodedString: ObjectWrappingEncodedString> {
  var objectWrapper: ObjectWrapper<WrapperType>;
  
  var wrappedObject: WrapperType? {
    self.objectWrapper.object;
  }; 
  
  init?(
    objectToWrap sourceObject: AnyObject?,
    shouldRetainObject: Bool = false
  ){
    
    guard let sourceObject = sourceObject as? NSObject,
          let className = EncodedString.className.decodedString,
          sourceObject.className == className
    else { return nil };
  
    self.objectWrapper = .init(
      objectToWrap: sourceObject,
      shouldRetainObject: shouldRetainObject
    );
  };
  
  func debugPrintWrappedObject(){
    #if DEBUG
    print(self.wrappedObject.debugDescription);
    #endif
  };
};




