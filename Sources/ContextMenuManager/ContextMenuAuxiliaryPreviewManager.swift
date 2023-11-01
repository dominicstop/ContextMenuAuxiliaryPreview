//
//  ContextMenuMetadata.swift
//  
//
//  Created by Dominic Go on 10/9/23.
//

import UIKit


/// This class contains the logic for attaching the "context menu aux. preview"
/// to the aux. preview
///
public class ContextMenuAuxiliaryPreviewManager {

  // MARK: - Properties
  // ------------------

  var contextMenuMetadata: ContextMenuMetadata;
  var customAnimator: UIViewPropertyAnimator?;
  
  // MARK: - Properties - References
  // -------------------------------
  
  weak var window: UIWindow?;
  
  weak var contextMenuManager: ContextMenuManager?;
  weak var contextMenuAnimator: UIContextMenuInteractionAnimating?;
  
  var contextMenuContainerViewWrapper: ContextMenuContainerViewWrapper;
  var contextMenuPlatterTransitionViewWrapper: ContextMenuPlatterTransitionViewWrapper;
  var morphingPlatterViewWrapper: MorphingPlatterViewWrapper;
  var contextMenuViewWrapper: ContextMenuViewWrapper?;
  
  /// where should the aux. preview be attached to?
  weak var auxPreviewTargetView: UIView?;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  var auxiliaryPreviewMetadata: AuxiliaryPreviewMetadata? {
    guard let contextMenuManager = self.contextMenuManager,
          let menuAuxPreviewConfig = contextMenuManager.menuAuxPreviewConfig
    else { return nil };
  
    return .init(
      contextMenuMetadata: contextMenuMetadata,
      contextMenuManager: contextMenuManager,
      auxiliaryPreviewConfig: menuAuxPreviewConfig,
      auxiliaryPreviewManager: self
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
          
    /// get wrapper for the "root view" that contains the context menu
    guard let contextMenuContainerViewWrapper =
            manager.contextMenuContainerViewWrapper,
          
          let contextMenuContainerView =
            contextMenuContainerViewWrapper.wrappedObject
    else { return nil };
    
    self.contextMenuContainerViewWrapper = contextMenuContainerViewWrapper;
    self.window = contextMenuContainerView.window;
          
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
    
    self.morphingPlatterViewWrapper = morphingPlatterViewWrapper;
    
    /// get the wrapper for the root view that holds the "context menu items".
    ///
    /// note: if you configure the "context menu" to not have any menu items,
    /// then this will be `nil`
    ///
    let contextMenuViewWrapper = contextMenuPlatterTransitionViewWrapper.contextMenuViewWrapper;
    self.contextMenuViewWrapper = contextMenuViewWrapper;
    
    /// a ref. to the view that contains the "context menu items".
    ///
    /// note: if you configure the "context menu" to not have any menu items,
    /// then this will be `nil`
    ///
    let contextMenuView = contextMenuViewWrapper?.wrappedObject;
  
    let contextMenuHasMenuItems = contextMenuView != nil;
    
    // MARK: Prep - Set Constants
    // --------------------------
    
    let isUsingCustomPreview = animator.previewViewController != nil;

    // where should the aux. preview be attached to?
    self.auxPreviewTargetView = isUsingCustomPreview
      ? contextMenuContainerView
      : morphingPlatterView;
    
    // MARK: Prep - Determine Size and Position
    // ----------------------------------------
    
    let menuItemsPlacement: ContextMenuMetadata.Position? = {
      guard contextMenuHasMenuItems,
            let contextMenuView = contextMenuView
      else { return nil };
      
      let previewFrame = morphingPlatterView.frame;
      let menuItemsFrame = contextMenuView.frame;
      
      return (menuItemsFrame.midY < previewFrame.midY) ? .bottom : .top;
    }();
    
    let morphingPlatterViewPlacement: ContextMenuMetadata.Position = {
      let previewFrame = morphingPlatterView.frame;
      let screenBounds = UIScreen.main.bounds;

      return (previewFrame.midY < screenBounds.midY) ? .top : .bottom;
    }();
    
    let contextMenuMetadata = ContextMenuMetadata(
      rootContainerFrame: contextMenuContainerView.frame,
      menuPreviewFrame: morphingPlatterView.frame,
      menuFrame: contextMenuView?.frame,
      menuPreviewPosition: morphingPlatterViewPlacement,
      menuPosition: menuItemsPlacement
    );
    
    self.contextMenuMetadata = contextMenuMetadata;
  };
  
  // MARK: - Functions
  // -----------------
  
  func attachAuxiliaryPreview(){
    guard let manager = self.contextMenuManager,
          let menuAuxPreviewConfig = manager.menuAuxPreviewConfig,
          let auxiliaryPreviewMetadata = self.auxiliaryPreviewMetadata,
          
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
        
    let auxiliaryPreviewViewHeight =
         auxiliaryPreviewMetadata.auxiliaryPreviewViewHeight
      ?? menuAuxiliaryPreviewView.bounds.height;
    
    let auxiliaryPreviewViewWidth =
         auxiliaryPreviewMetadata.auxiliaryPreviewViewWidthAdjusted
      ?? menuAuxiliaryPreviewView.bounds.width;
      
    let auxiliaryPreviewViewSize = CGSize(
      width: auxiliaryPreviewViewWidth,
      height: auxiliaryPreviewViewHeight
    );
    
    switch menuAuxPreviewConfig.transitionConfigEntrance {
      case .afterMenuEntranceTransition, .customDelay:
        /// Set the initial height/width of the aux. preview
        menuAuxiliaryPreviewView.frame = .init(
          origin: .zero,
          size: auxiliaryPreviewViewSize
        );
      
      default:
        break;
    };
    
    /// enable auto layout
    menuAuxiliaryPreviewView.translatesAutoresizingMaskIntoConstraints = false;
    
    /// attach `auxiliaryView` to context menu preview
    auxPreviewTargetView.addSubview(menuAuxiliaryPreviewView);
    
    // get layout constraints based on config
    let constraints: [NSLayoutConstraint] = {
      var constraints: [NSLayoutConstraint] = [];
    
      // set aux preview height
      constraints.append(
        menuAuxiliaryPreviewView.heightAnchor.constraint(
          equalToConstant: auxiliaryPreviewViewHeight
        )
      );
      
      // set vertical alignment constraint - i.e. either...
      constraints.append({
        switch auxiliaryPreviewMetadata.auxPreviewPosition {
          case .top:
            return menuAuxiliaryPreviewView.bottomAnchor.constraint(
             equalTo: morphingPlatterView.topAnchor,
             constant: -menuAuxPreviewConfig.auxiliaryPreviewMarginInner
            );
            
          case .bottom:
            return menuAuxiliaryPreviewView.topAnchor.constraint(
              equalTo: morphingPlatterView.bottomAnchor,
              constant: menuAuxPreviewConfig.auxiliaryPreviewMarginInner
            );
        };
      }());
      
      // set horizontal alignment constraints based on config...
      constraints += {
        let widthAnchor = menuAuxiliaryPreviewView.widthAnchor.constraint(
          equalToConstant: auxiliaryPreviewViewWidth
        );
      
        switch menuAuxPreviewConfig.alignmentHorizontal {
          // A - pin to left
          case .previewLeading: return [
            widthAnchor,
            menuAuxiliaryPreviewView.leadingAnchor.constraint(
              equalTo: morphingPlatterView.leadingAnchor
            ),
          ];
            
          // B - pin to right
          case .previewTrailing: return [
            widthAnchor,
            menuAuxiliaryPreviewView.rightAnchor.constraint(
              equalTo: morphingPlatterView.rightAnchor
            ),
          ];
            
          // C - pin to center
          case .previewCenter: return [
            widthAnchor,
            menuAuxiliaryPreviewView.centerXAnchor.constraint(
              equalTo: morphingPlatterView.centerXAnchor
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
          case .stretch: return [
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
    
    // // Bugfix: fix aux-preview touch event on screen edge
    // let shouldSwizzle = self.contextMenuOffsetY != 0;
    
    // if shouldSwizzle {
    //   UIView.auxPreview = menuAuxiliaryPreviewView;
    //   UIView.swizzlePoint();
    // };
  };
  
  func nudgeContextMenuIfNeeded(){
    guard let auxiliaryPreviewMetadata = self.auxiliaryPreviewMetadata,
          auxiliaryPreviewMetadata.menuOffset != 0,
    
          let contextMenuPlatterTransitionView =
            self.contextMenuPlatterTransitionViewWrapper.wrappedObject
    else { return };
    
    contextMenuPlatterTransitionView.frame = {
      let initFrame = contextMenuPlatterTransitionView.frame;
      
      return initFrame.offsetBy(
        dx: 0,
        dy: auxiliaryPreviewMetadata.menuOffset
      );
    }();
  };
  
  // TODO: WIP - TEMP
  func swizzleViews(){
    guard !UIView.isSwizzlingApplied,
          let manager = self.contextMenuManager,
          let menuAuxiliaryPreviewView = manager.menuAuxiliaryPreviewView
    else { return };
  
    UIView.auxPreview = menuAuxiliaryPreviewView;
    UIView.swizzlePoint();
  };
  
  // TODO: WIP - TEMP
  func unSwizzleViews(){
    guard UIView.isSwizzlingApplied,
          let manager = self.contextMenuManager,
          let menuAuxiliaryPreviewView = manager.menuAuxiliaryPreviewView
    else { return };
  
    menuAuxiliaryPreviewView.removeFromSuperview();

    // undo swizzling
    UIView.swizzlePoint();
    UIView.auxPreview = nil;
  };
  
  // TODO: WIP
  func createAuxiliaryPreviewTransitionOutBlock() -> (() -> ())? {
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
      switch self.contextMenuMetadata.menuPreviewPosition {
        case .top:
          transform = transform.translatedBy(x: 0, y: 50);
          
        case .bottom:
          transform = transform.translatedBy(x: 0, y: -50);
      };
      
      // transition - apply transform
      menuAuxiliaryPreviewView.transform = transform;
    };
  };
  
  func debugPrintValues(){
    guard let contextMenuContainerView = self.contextMenuContainerViewWrapper.wrappedObject,
          let contextMenuPlatterTransitionView = self.contextMenuPlatterTransitionViewWrapper.wrappedObject,
          let morphingPlatterView = self.morphingPlatterViewWrapper.wrappedObject
    else { return };
    
    let contextMenuView = self.contextMenuViewWrapper?.wrappedObject;
  
    print(
      "debugPrintValues:",
      "\n- contextMenuContainerView.frame:", contextMenuContainerView.frame,
      "\n- contextMenuPlatterTransitionView.frame:", contextMenuPlatterTransitionView.frame,
      "\n- morphingPlatterView.frame:", morphingPlatterView.frame,
      "\n- contextMenuView.frame:", contextMenuView?.frame ?? .zero,
      "\n- menuPreviewPosition:", self.contextMenuMetadata.menuPreviewPosition.rawValue,
      "\n- menuPosition:", self.contextMenuMetadata.menuPosition?.rawValue ?? "N/A",
      "\n"
    );
  };
  
  // MARK: - Public Functions
  // ------------------------
  
  public func attachAndAnimateInAuxiliaryPreviewTogetherWithContextMenu() {
    guard let manager = self.contextMenuManager,
          let menuAuxPreviewConfig = manager.menuAuxPreviewConfig,
          let auxiliaryPreviewMetadata = self.auxiliaryPreviewMetadata,
          
          let contextMenuPlatterTransitionView =
            self.contextMenuPlatterTransitionViewWrapper.wrappedObject,
            
          let contextMenuAnimator = self.contextMenuAnimator
    else { return };
    
    contextMenuAnimator.addCompletion { [unowned self] in
      self.swizzleViews();
    };
    
    let transitionConfigEntrance =
      menuAuxPreviewConfig.transitionConfigEntrance;
    
    switch transitionConfigEntrance {
      case .syncedToMenuEntranceTransition:
        
        self.attachAuxiliaryPreview();
        
        contextMenuPlatterTransitionView.frame = {
          let initFrame = contextMenuPlatterTransitionView.frame;
          
          return initFrame.offsetBy(
            dx: 0,
            dy: auxiliaryPreviewMetadata.menuOffset
          );
        }();
        
      default:
        break;
    };
  };
  
  public func attachAndAnimateInAuxiliaryPreviewUsingCustomAnimator() {
    guard let manager = self.contextMenuManager,
          let menuAuxPreviewConfig = manager.menuAuxPreviewConfig,
          
          /// get the wrapper for the root view that hold the context menu
          let menuAuxiliaryPreviewView = manager.menuAuxiliaryPreviewView
    else { return };
    
    let transitionConfigEntrance =
      menuAuxPreviewConfig.transitionConfigEntrance;
    
    guard let delay = transitionConfigEntrance.delay,
          let animatorConfig = transitionConfigEntrance.animatorConfig,
          let transition = transitionConfigEntrance.transition
    else { return };
    
    self.attachAuxiliaryPreview();
    menuAuxiliaryPreviewView.layoutIfNeeded();
    
    let animator = animatorConfig.createAnimator(gestureInitialVelocity: .zero);
    self.customAnimator = animator;
    
    let keyframes = transition.getKeyframes();
    
    keyframes.keyframeStart.apply(toView: menuAuxiliaryPreviewView);
    
    animator.addAnimations {
      keyframes.keyframeEnd.apply(toView: menuAuxiliaryPreviewView);
    };
    
    animator.addCompletion { [unowned self] _ in
      self.swizzleViews();
    };
    
    switch menuAuxPreviewConfig.transitionConfigEntrance {
      case .customDelay:
        animator.startAnimation(afterDelay: delay);
        
      case .afterMenuEntranceTransition:
        guard let contextMenuAnimator = self.contextMenuAnimator else { return };
        
        contextMenuAnimator.addCompletion {
          animator.startAnimation(afterDelay: delay);
        };
        
      default:
        break;
    };
  };
  
  public func detachAndAnimateOutAuxiliaryPreview() {
    guard let animator = self.contextMenuAnimator,
          
          let auxPreviewTransitionOutBlock =
            self.createAuxiliaryPreviewTransitionOutBlock()
    else { return };
    
    if let customAnimator = self.customAnimator {
      customAnimator.stopAnimation(true);
    };
    
    auxPreviewTransitionOutBlock();
    
    animator.addCompletion { [unowned self] in
      self.unSwizzleViews();
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
