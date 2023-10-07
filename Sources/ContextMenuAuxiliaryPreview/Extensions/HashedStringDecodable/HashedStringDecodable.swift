//
//  HashedStringDecodable.swift
//  
//
//  Created by Dominic Go on 10/8/23.
//

import Foundation

protocol HashedStringDecodable: RawRepresentable where RawValue == String  {

  var encodedString: String { get };
  
  var decodedString: String? { get };
};
