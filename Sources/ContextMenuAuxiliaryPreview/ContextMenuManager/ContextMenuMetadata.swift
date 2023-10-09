//
//  ContextMenuMetadata.swift
//  
//
//  Created by Dominic Go on 10/9/23.
//

import UIKit


public struct ContextMenuMetadata {

  // amount to add to width - fix for layout bug
  //
  // if you use the actual width, it triggers a bug w/ autolayout where the
  // aux. preview snaps to the top of the screen...
  static let auxPreviewWidthAdj = 0.5;

  // MARK: - Embedded Types
  // ----------------------
  
  public enum Position: String {
    case top;
    case bottom;
  };
  
  // MARK: - Properties
  // ------------------
  
  var auxPreviewConfig: ContextMenuAuxiliaryPreviewConfig;
  
  /// Does the context menu have menu items?
  public var hasMenuItems: Bool;
  
  /// If the context menu has "menu items", where is it located in relation to
  /// the "menu preview"?
  public var menuItemsPlacement: Position?;
  
  /// in which vertical half does the "context menu preview" fall into?
  public var morphingPlatterViewPlacement: Position;
  
  /// Whether to attach the `auxiliaryView` on the top, or bottom of the
  /// context menu
  public var auxPreviewPlacement: Position;
  
  /// The amount to nudge the context menu
  public var auxPreviewOffsetY: CGFloat;
  
  public var auxPreviewHeight: CGFloat;
  public var auxPreviewWidth: CGFloat;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var auxPreviewSize: CGSize {
    .init(
      width: self.auxPreviewWidth + Self.auxPreviewWidthAdj,
      height: self.auxPreviewHeight
    );
  };
  
  // MARK: - Init
  // ------------
  
  init?(
    window: UIWindow,
    previewAuxiliaryView: UIView,
    auxPreviewConfig: ContextMenuAuxiliaryPreviewConfig,
    contextMenuContainerViewWrapper: ContextMenuContainerViewWrapper
  ) {

    guard let contextMenuContainerViewWrapper =
            contextMenuContainerViewWrapper.contextMenuPlatterTransitionViewWrapper,
            
          let contextMenuContainerView =
            contextMenuContainerViewWrapper.wrappedObject,
            
          let morphingPlatterViewWrapper =
            contextMenuContainerViewWrapper.morphingPlatterViewWrapper,
            
          let morphingPlatterView =
            morphingPlatterViewWrapper.wrappedObject
    else { return nil };
    
    self.auxPreviewConfig = auxPreviewConfig;
    
    let contextMenuViewWrapper =
      contextMenuContainerViewWrapper.contextMenuViewWrapper;
     
    let hasMenuItems = contextMenuViewWrapper != nil;
    self.hasMenuItems = hasMenuItems;
     
    let menuItemsPlacement: Position? = {
      guard hasMenuItems,
            let contextMenuView = contextMenuViewWrapper?.wrappedObject
      else { return nil };
      
      let previewFrame = morphingPlatterView.frame;
      let menuItemsFrame = contextMenuView.frame;
      
      return (menuItemsFrame.midY < previewFrame.midY)
        ? .bottom
        : .top;
    }();
    
    self.menuItemsPlacement = menuItemsPlacement;
    
    let morphingPlatterViewPlacement: Position = {
      let previewFrame = morphingPlatterView.frame;
      let screenBounds = UIScreen.main.bounds;
      
      return (previewFrame.midY < screenBounds.midY)
        ? .top
        : .bottom;
    }();
    
    self.morphingPlatterViewPlacement = morphingPlatterViewPlacement;
    
    self.auxPreviewPlacement = {
      switch auxPreviewConfig.anchorPosition {
        case .top   : return .top;
        case .bottom: return .bottom;
            
        case .automatic:
          break;
      };
      
      if let menuItemsPlacement = menuItemsPlacement {
        return menuItemsPlacement;
      };
      
      // the context menu does not have menu items, determine anchor position
      // of auxiliary view via the position of the preview in the screen
      return morphingPlatterViewPlacement;
    }();
    
    /// distance of aux. preview from the context menu preview
    let marginInner = auxPreviewConfig.marginPreview;
    
    /// distance of the aux. preview from the edges of the screen
    let marginOuter = auxPreviewConfig.marginAuxiliaryPreview;
    
    let auxPreviewHeight: CGFloat = {
      // A - Use height from config
      if let height = auxPreviewConfig.height {
        return height;
      };
      
      // B - Infer aux preview height from view
      return previewAuxiliaryView.frame.height;
    }();
    
    self.auxPreviewHeight = auxPreviewHeight;
    
    let auxPreviewWidth: CGFloat = {
      // Begin inferring the width of the aux. view...
      
      switch auxPreviewConfig.alignmentHorizontal {
        // A - Set aux preview width to window width
        case .stretchScreen:
          return contextMenuContainerView.frame.width;
        
        // B - Set aux preview width to preview width
        case .stretchPreview:
          return morphingPlatterView.frame.width;
        
        // C - Infer aux config or aux preview width from view...
        default:
          return auxPreviewConfig.width ?? previewAuxiliaryView.frame.width;
      };
    }();
    
    self.auxPreviewWidth = auxPreviewWidth;
    
    self.auxPreviewOffsetY = {
      let safeAreaInsets = window.safeAreaInsets;
      
      let previewFrame = morphingPlatterView.frame;
      let screenHeight = UIScreen.main.bounds.height;
      
      let marginBase = marginInner + marginOuter;
      
      switch morphingPlatterViewPlacement {
        case .top:
          let margin = marginBase + safeAreaInsets.top;
          
          let minEdgeY = auxPreviewHeight + safeAreaInsets.top + margin;
          let distanceToEdge = auxPreviewWidth - previewFrame.minY;
        
          return (previewFrame.minY <= minEdgeY)
            ? max((distanceToEdge + margin), 0)
            : 0;
          
        case .bottom:
          let margin = marginBase + safeAreaInsets.bottom;
          
          let tolerance = auxPreviewHeight + margin;
          let maxEdgeY = screenHeight - tolerance;
          let previewFrameMaxY = previewFrame.maxY + marginInner;
          
          let distanceToEdge = screenHeight - previewFrame.maxY;
          
          return (previewFrameMaxY > maxEdgeY)
            ? -(auxPreviewHeight - distanceToEdge + margin)
            : 0;
      };
  }();
  };
};
