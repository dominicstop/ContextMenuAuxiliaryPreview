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

  // MARK: - Static Members
  // ----------------------

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
  
  weak var contextMenuManager: ContextMenuManager?;
  weak var contextMenuAnimator: UIContextMenuInteractionAnimating?;
  
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
  
    self.contextMenuManager = manager;
    self.contextMenuAnimator = animator;
  
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
      ? contextMenuContainerView
      : morphingPlatterView;
    
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
  
  // MARK: - Functions
  // -----------------
  
  func attachAuxiliaryPreview(){
    guard let manager = self.contextMenuManager,
          let menuAuxPreviewConfig = manager.menuAuxPreviewConfig,
          
          /// get the wrapper for the root view that hold the context menu
          let menuAuxiliaryPreviewView = manager.menuAuxiliaryPreviewView,
          let auxPreviewTargetView = self.auxPreviewTargetView,
          
          let morphingPlatterView = self.morphingPlatterViewWrapper.wrappedObject,
          let contextMenuContainerView = self.contextMenuContainerViewWrapper.wrappedObject
    else { return };
  
    // Bugfix: Stop bubbling touch events from propagating to parent
    menuAuxiliaryPreviewView.addGestureRecognizer(
      UITapGestureRecognizer(target: nil, action: nil)
    );
    
    /// manually set size of aux. preview
    menuAuxiliaryPreviewView.bounds = .init(
      origin: .zero,
      size: self.auxiliaryPreviewViewSize
    );

    /// enable auto layout
    menuAuxiliaryPreviewView.translatesAutoresizingMaskIntoConstraints = false;
    
    /// attach `auxiliaryView` to context menu preview
    auxPreviewTargetView.addSubview(menuAuxiliaryPreviewView);
    
    // get layout constraints based on config
    let constraints: [NSLayoutConstraint] = {
      // set initial constraints
      var constraints: Array<NSLayoutConstraint> = [
      
        // set aux preview height
        menuAuxiliaryPreviewView.heightAnchor.constraint(
          equalToConstant: self.auxiliaryPreviewViewHeight
        ),
      ];
      
      // set vertical alignment constraint - i.e. either...
      constraints.append({
        if self.shouldAttachAuxPreviewToTop {
          // A - pin to top or...
          return menuAuxiliaryPreviewView.bottomAnchor.constraint(
           equalTo: morphingPlatterView.topAnchor,
           constant: -self.marginInner
          );
        };
        
        // B - pin to bottom.
        return menuAuxiliaryPreviewView.topAnchor.constraint(
          equalTo: morphingPlatterView.bottomAnchor,
          constant: self.marginInner
        );
      }());
      
      // set horizontal alignment constraints based on config...
      constraints += {
        switch menuAuxPreviewConfig.alignmentHorizontal {
          // A - pin to left
          case .previewLeading: return [
            menuAuxiliaryPreviewView.leadingAnchor.constraint(
              equalTo: morphingPlatterView.leadingAnchor
            ),
            
            menuAuxiliaryPreviewView.widthAnchor.constraint(
              equalToConstant: self.auxiliaryPreviewViewWidth
            ),
          ];
            
          // B - pin to right
          case .previewTrailing: return [
            menuAuxiliaryPreviewView.rightAnchor.constraint(
              equalTo: morphingPlatterView.rightAnchor
            ),
            
            menuAuxiliaryPreviewView.widthAnchor.constraint(
              equalToConstant: self.auxiliaryPreviewViewWidth
            ),
          ];
            
          // C - pin to center
          case .previewCenter: return [
            menuAuxiliaryPreviewView.centerXAnchor.constraint(
              equalTo: morphingPlatterView.centerXAnchor
            ),
            
            menuAuxiliaryPreviewView.widthAnchor.constraint(
              equalToConstant: self.auxiliaryPreviewViewWidth
            ),
          ];
            
          // D - match preview size
          case .stretchPreview: return [
            menuAuxiliaryPreviewView.leadingAnchor.constraint(
              equalTo: morphingPlatterView.leadingAnchor
            ),
            
            menuAuxiliaryPreviewView.trailingAnchor.constraint(
              equalTo: morphingPlatterView.trailingAnchor
            ),
          ];
          
          // E - stretch to edges of screen
          case .stretchScreen: return [
            menuAuxiliaryPreviewView.leadingAnchor.constraint(
              equalTo: contextMenuContainerView.leadingAnchor
            ),
            
            menuAuxiliaryPreviewView.trailingAnchor.constraint(
              equalTo: contextMenuContainerView.trailingAnchor
            ),
          ];
        };
      }();
      
      return constraints;
    }();
    
    NSLayoutConstraint.activate(constraints);
    
    // Bugfix: fix aux-preview touch event on screen edge
    let shouldSwizzle = self.contextMenuOffsetY != 0;
    
    if shouldSwizzle {
      UIView.auxPreview = menuAuxiliaryPreviewView;
      UIView.swizzlePoint();
    };
  };
  
  func createAuxiliaryPreviewTransitionInBlock() -> (
    setTransitionStart: () -> (),
    setTransitionEnd  : () -> ()
  )? {
    guard let manager = self.contextMenuManager,
          let menuAuxPreviewConfig = manager.menuAuxPreviewConfig,
          
          /// get the wrapper for the root view that hold the context menu
          let menuAuxiliaryPreviewView = manager.menuAuxiliaryPreviewView
    else { return nil };
   
    let (keyframeStart, keyframeEnd) =
      menuAuxPreviewConfig.transitionConfigEntrance.getKeyframes();
    
    
    let transitionStartBlock = {
      keyframeStart.apply(toView: menuAuxiliaryPreviewView);
    };
    
    let transitionEnd = {
      keyframeEnd.apply(toView: menuAuxiliaryPreviewView);
    };
    
    return (transitionStartBlock, transitionEnd);
  };
  
  public func createAuxiliaryPreviewTransitionOutBlock() -> (() -> ())? {
    guard let manager = self.contextMenuManager,
    
          /// get the wrapper for the root view that hold the context menu
          let menuAuxiliaryPreviewView = manager.menuAuxiliaryPreviewView
    else { return nil };
    
    var transform = menuAuxiliaryPreviewView.transform;
    
    return {
      // transition - fade out
      menuAuxiliaryPreviewView.alpha = 0;
      
      // transition - zoom out
      transform = transform.scaledBy(x: 0.7, y: 0.7);
      
      // transition - slide out
      switch self.morphingPlatterViewPlacement {
        case .top:
          transform = transform.translatedBy(x: 0, y: 50);
          
        case .bottom:
          transform = transform.translatedBy(x: 0, y: -50);
      };
      
      // transition - apply transform
      menuAuxiliaryPreviewView.transform = transform;
    };
  };
  
  // MARK: - Public Functions
  // ------------------------
  
  public func attachAndAnimateInAuxiliaryPreview() {
    guard let contextMenuContainerView =
            self.contextMenuContainerViewWrapper.wrappedObject,
            
          let animationBlocks = self.createAuxiliaryPreviewTransitionInBlock()
    else { return };
    
    self.attachAuxiliaryPreview();
    animationBlocks.setTransitionStart();
    
    UIView.addKeyframe(withRelativeStartTime: 1, relativeDuration: 1) {
      // transition in - set end values
      animationBlocks.setTransitionEnd();
      
      // offset from anchor
      contextMenuContainerView.frame = contextMenuContainerView.frame.offsetBy(
        dx: 0,
        dy: self.contextMenuOffsetY
      );
    };
  };
  
  public func detachAndAnimateOutAuxiliaryPreview() {
    guard let animator = self.contextMenuAnimator,
          
          let manager = self.contextMenuManager,
          let menuAuxiliaryPreviewView = manager.menuAuxiliaryPreviewView,
    
          let auxPreviewTransitionOutBlock =
            self.createAuxiliaryPreviewTransitionOutBlock()
            
    else { return };
    
    auxPreviewTransitionOutBlock();
    
    animator.addCompletion {
      menuAuxiliaryPreviewView.removeFromSuperview();
      
      // Bugfix - Aux-preview touch event on screen edge
      if UIView.isSwizzlingApplied {
        // undo swizzling
        UIView.swizzlePoint();
        UIView.auxPreview = nil;
      };
    };
  };
  
};

// Bugfix: Fix for aux-preview not receiving touch event when appearing
// on screen edge
fileprivate extension UIView {
  static weak var auxPreview: UIView? = nil;
  
  static var isSwizzlingApplied = false
  
  @objc dynamic func _point(
    inside point: CGPoint,
    with event: UIEvent?
  ) -> Bool {
    guard let auxPreview = Self.auxPreview,
          self.subviews.contains(where: { $0 === auxPreview })
    else {
      // call original impl.
      return self._point(inside: point, with: event);
    };
    
    return true;
  };
  
  static func swizzlePoint(){
    let selectorOriginal = #selector( point(inside: with:));
    let selectorSwizzled = #selector(_point(inside: with:));
    
    guard let methodOriginal = class_getInstanceMethod(UIView.self, selectorOriginal),
          let methodSwizzled = class_getInstanceMethod(UIView.self, selectorSwizzled)
    else { return };
    
    Self.isSwizzlingApplied.toggle();
    method_exchangeImplementations(methodOriginal, methodSwizzled);
  };
};
