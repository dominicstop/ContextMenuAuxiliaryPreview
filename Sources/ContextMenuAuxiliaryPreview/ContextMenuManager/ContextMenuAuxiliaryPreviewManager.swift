//
//  ContextMenuMetadata.swift
//  
//
//  Created by Dominic Go on 10/9/23.
//

import UIKit

/// This class contains the logic for attaching the "context menu aux. preview"
/// to the aux. preview
public struct ContextMenuAuxiliaryPreviewManager {

  /// amount to add to width - fix for layout bug
  ///
  /// if you use the actual width, it triggers a bug w/ autolayout where the
  /// aux. preview snaps to the top of the screen...
  ///
  static let auxiliaryViewExtraWidth = 0.5;

  // MARK: - Embedded Types
  // ----------------------
  
  public enum Position: String {
    case top;
    case bottom;
  };

  // MARK: - Properties
  // ------------------
  
  let auxiliaryPreviewViewHeight: CGFloat;
  let auxiliaryPreviewViewWidth: CGFloat;
  
  /// distance of aux. preview from the context menu preview
  let marginInner: CGFloat;
  
  /// distance of the aux. preview from the edges of the screen
  let marginOuter: CGFloat;
  
  /// does the context menu have menu items?
  let contextMenuHasMenuItems: Bool;
  
  /// if the context menu has "menu items", where is it located in relation to
  ///  the "menu preview"?
  let menuItemsPlacement: Position?;
  
  /// in which vertical half does the "context menu preview" fall into?
  let morphingPlatterViewPlacement: Position;
  
   /// whether to attach the `auxiliaryView` on the top or bottom of the
   /// context menu
  let shouldAttachAuxPreviewToTop: Bool;
  
  /// the amount to nudge the context menu
  let contextMenuOffsetY: CGFloat;
  
  // MARK: - Properties - References
  // -------------------------------

  var contextMenuContainerViewWrapper: ContextMenuContainerViewWrapper;
  var contextMenuPlatterTransitionViewWrapper: ContextMenuPlatterTransitionViewWrapper;
  var morphingPlatterViewWrapper: MorphingPlatterViewWrapper;
  
  /// where should the aux. preview be attached to?
  weak var auxPreviewTargetView: UIView?;
  
  // MARK: - Properties - Computed
  // -----------------------------
  
  var auxiliaryPreviewViewSize: CGSize {
    .init(
      width : self.auxiliaryPreviewViewWidth + Self.auxiliaryViewExtraWidth,
      height: self.auxiliaryPreviewViewHeight
    );
  };
  
  // MARK: - Init
  // ------------
  
  public init?(
    usingContextMenuManager manager: ContextMenuManager,
    contextMenuAnimator animator: UIContextMenuInteractionAnimating
  ) {
  
    guard let menuAuxPreviewConfig = manager.menuAuxPreviewConfig,
          let menuAuxiliaryPreviewView = manager.menuAuxiliaryPreviewView
    else { return nil };
          
    /// get wrapper for the "root view" that contains the context menu
    guard let contextMenuContainerViewWrapper =
            manager.contextMenuContainerViewWrapper,
          
          contextMenuContainerViewWrapper.wrappedObject != nil
    else { return nil };
    
    self.contextMenuContainerViewWrapper = contextMenuContainerViewWrapper;
          
    /// get wrapper for the "root view" that contains the "context menu items"
    /// + the "context menu preview"
    guard let contextMenuPlatterTransitionViewWrapper =
            contextMenuContainerViewWrapper.contextMenuPlatterTransitionViewWrapper,
          
          /// get the wrapper for the root view that holds the
          /// "context menu items" + "context menu preview"
          let contextMenuContainerView = contextMenuContainerViewWrapper.wrappedObject
    else { return nil };
    
    self.contextMenuPlatterTransitionViewWrapper =
      contextMenuPlatterTransitionViewWrapper;
          
          /// get the wrapper for the root view that holds the
          /// "context menu preview".
    guard let morphingPlatterViewWrapper =
            contextMenuPlatterTransitionViewWrapper.morphingPlatterViewWrapper,
          
          /// view that holds the "context menu preview".
          let morphingPlatterView = morphingPlatterViewWrapper.wrappedObject
    else { return nil };
    
    /// get the wrapper for the root view that holds the "context menu items".
    ///
    /// note: if you configure the "context menu" to not have any menu items,
    /// then this will be `nil`
    ///
    let contextMenuViewWrapper = contextMenuPlatterTransitionViewWrapper.contextMenuViewWrapper;
    self.morphingPlatterViewWrapper = morphingPlatterViewWrapper;
    
    /// a ref. to the view that contains the "context menu items".
    ///
    /// note: if you configure the "context menu" to not have any menu items,
    /// then this will be `nil`
    ///
    let contextMenuView = contextMenuViewWrapper?.wrappedObject;
  
    let contextMenuHasMenuItems = contextMenuView != nil;
    self.contextMenuHasMenuItems = contextMenuHasMenuItems;
    
    // MARK: Prep - Set Constants
    // --------------------------
    
    let isUsingCustomPreview = animator.previewViewController != nil;

    // where should the aux. preview be attached to?
    self.auxPreviewTargetView = isUsingCustomPreview
      ? morphingPlatterView
      : contextMenuContainerView;
    
    // get the height the "context menu aux. view"
    let auxiliaryPreviewViewHeight: CGFloat = {
      // A - Use height from config
      if let height = menuAuxPreviewConfig.height {
        return height;
      };
      
      // B - Use height from aux view
      return menuAuxiliaryPreviewView.frame.height;
    }();
    
    self.auxiliaryPreviewViewHeight = auxiliaryPreviewViewHeight;
    
    let auxiliaryPreviewViewWidth: CGFloat = {
      // Begin inferring the width of the aux. view...
      
      switch menuAuxPreviewConfig.alignmentHorizontal {
        // A - Set aux preview width to window width
        case .stretchScreen:
          return contextMenuContainerView.frame.width;
        
        // B - Set aux preview width to preview width
        case .stretchPreview:
          return morphingPlatterView.frame.width;
        
        // C - Infer aux config or aux preview width from view...
        default:
          return menuAuxPreviewConfig.width
            ?? menuAuxiliaryPreviewView.frame.width;
      };
    }();
    
    self.auxiliaryPreviewViewWidth  = auxiliaryPreviewViewWidth;
    
    /// distance of aux. preview from the context menu preview
    let marginInner = menuAuxPreviewConfig.marginPreview;
    self.marginInner = marginInner;
    
    /// distance of the aux. preview from the edges of the screen
    let marginOuter = menuAuxPreviewConfig.marginAuxiliaryPreview;
    self.marginOuter = marginOuter;
    
    // MARK: Prep - Determine Size and Position
    // ----------------------------------------
    
    let menuItemsPlacement: Position? = {
      guard contextMenuHasMenuItems,
            let contextMenuView = contextMenuView
      else { return nil };
      
      let previewFrame = morphingPlatterView.frame;
      let menuItemsFrame = contextMenuView.frame;
      
      return (menuItemsFrame.midY < previewFrame.midY) ? .bottom : .top;
    }();
    
    self.menuItemsPlacement = menuItemsPlacement;
    
    let morphingPlatterViewPlacement: Position = {
      let previewFrame = morphingPlatterView.frame;
      let screenBounds = UIScreen.main.bounds;

      return (previewFrame.midY < screenBounds.midY) ? .top : .bottom;
    }();
    
    self.morphingPlatterViewPlacement = morphingPlatterViewPlacement;
    
    self.shouldAttachAuxPreviewToTop = {
      switch menuAuxPreviewConfig.anchorPosition {
        case .top   : return true;
        case .bottom: return false;
          
        case .automatic: break;
      };
      
      switch menuItemsPlacement {
        case .top   : return true;
        case .bottom: return false;
          
        default:
          // the context menu does not have menu items, determine anchor position
          // of auxiliary view via the position of the preview in the screen
          return morphingPlatterViewPlacement == .bottom;
      };
    }();
    
    // MARK: Prep - Compute Offsets
    // ----------------------------
    
    self.contextMenuOffsetY = {
      let safeAreaInsets = UIApplication.shared.windows.first?.safeAreaInsets;
      
      let previewFrame = morphingPlatterView.frame;
      let screenHeight = UIScreen.main.bounds.height;
      
      let marginBase = marginInner + marginOuter;
      
      switch morphingPlatterViewPlacement {
        case .top:
          let topInsets = safeAreaInsets?.top ?? 0;
          let margin = marginBase + topInsets;
          
          let minEdgeY = auxiliaryPreviewViewHeight + topInsets + margin;
          let distanceToEdge = auxiliaryPreviewViewHeight - previewFrame.minY;
        
          return (previewFrame.minY <= minEdgeY)
            ? max((distanceToEdge + margin), 0)
            : 0;
          
        case .bottom:
          let bottomInsets = safeAreaInsets?.bottom ?? 0;
          let margin = marginBase + bottomInsets;
          
          let tolerance = auxiliaryPreviewViewHeight + margin;
          let maxEdgeY = screenHeight - tolerance;
          let previewFrameMaxY = previewFrame.maxY + marginInner;
          
          let distanceToEdge = screenHeight - previewFrame.maxY;
          
          return (previewFrameMaxY > maxEdgeY)
            ? -(auxiliaryPreviewViewHeight - distanceToEdge + margin)
            : 0;
      };
    }();
  };
};
