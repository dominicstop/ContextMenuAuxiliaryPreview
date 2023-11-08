//
//  ContextMenuMetadata.swift
//  
//
//  Created by Dominic Go on 10/27/23.
//

import UIKit


public struct ContextMenuMetadata {

  // MARK: - Embedded Types
  // ----------------------

  public enum Position: String {
    case top;
    case bottom;
  };
  
  // MARK: - Properties
  // ------------------
  
  var rootContainerFrame: CGRect;
  var menuPreviewFrame: CGRect;
  var menuFrame: CGRect?;
  
  /// in which vertical half does the "context menu preview" fall into?
  var menuPreviewPosition: Position;
  
  /// if the context menu has "menu items", where is it located in relation to
  /// the "menu preview"?
  var menuPosition: Position?;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  /// does the context menu have menu items?
  var hasMenuItems: Bool {
    self.menuFrame != nil;
  };
};
