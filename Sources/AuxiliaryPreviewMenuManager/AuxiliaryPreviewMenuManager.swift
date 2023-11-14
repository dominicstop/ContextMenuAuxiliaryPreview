//
//  AuxiliaryPreviewMenuManager.swift
//  
//
//  Created by Dominic Go on 10/9/23.
//

import UIKit
import DGSwiftUtilities


/// This class contains the logic for attaching the "context menu aux. preview"
/// to the context menu
///
public class AuxiliaryPreviewMenuManager {

  // MARK: - Properties
  // ------------------

  var contextMenuMetadata: ContextMenuMetadata;
  var customAnimator: UIViewPropertyAnimator?;
  
  var isAuxiliaryPreviewVisible = false;
  
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
  weak var auxiliaryPreviewParentView: UIView?;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  lazy var auxiliaryPreviewMetadata: AuxiliaryPreviewMetadata? = .init(
    auxiliaryPreviewMenuManager: self
  );
  
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
    self.auxiliaryPreviewParentView = isUsingCustomPreview
      ? contextMenuContainerView
      : morphingPlatterView;
    
    // MARK: Prep - Determine Size and Position
    // ----------------------------------------
    
    let menuItemsPlacement: VerticalAnchorPosition? = {
      guard contextMenuHasMenuItems,
            let contextMenuView = contextMenuView
      else { return nil };
      
      let previewFrame = morphingPlatterView.frame;
      let menuItemsFrame = contextMenuView.frame;
      
      return (menuItemsFrame.midY < previewFrame.midY) ? .bottom : .top;
    }();
    
    let morphingPlatterViewPlacement: VerticalAnchorPosition = {
      let previewFrame = morphingPlatterView.frame;
      let screenBounds = UIScreen.main.bounds;

      return (previewFrame.midY < screenBounds.midY) ? .top : .bottom;
    }();
    
    self.contextMenuMetadata = .init(
      rootContainerFrame: contextMenuContainerView.frame,
      menuPreviewFrame: morphingPlatterView.frame,
      menuFrame: contextMenuView?.frame,
      menuPreviewPosition: morphingPlatterViewPlacement,
      menuPosition: menuItemsPlacement
    );
  };
  
  // MARK: - Functions
  // -----------------
  
  func attachAuxiliaryPreview(){
    guard let manager = self.contextMenuManager,
          let auxiliaryPreviewConfig = manager.auxiliaryPreviewConfig,
          let auxiliaryPreviewMetadata = self.auxiliaryPreviewMetadata,
          
          /// get the wrapper for the root view that hold the context menu
          let auxiliaryPreviewView = manager.auxiliaryPreviewView,
          let auxiliaryPreviewParentView = self.auxiliaryPreviewParentView,
          
          let morphingPlatterView = self.morphingPlatterViewWrapper.wrappedObject,
          let contextMenuContainerView = self.contextMenuContainerViewWrapper.wrappedObject
    else { return };

    // Bugfix: Stop bubbling touch events from propagating to parent
    auxiliaryPreviewView.addGestureRecognizer(
      UITapGestureRecognizer(target: nil, action: nil)
    );
        
    let auxiliaryPreviewViewHeight =
      auxiliaryPreviewMetadata.computedHeight;
    
    let auxiliaryPreviewViewWidth =
         auxiliaryPreviewMetadata.computedWidthAdjusted
      ?? auxiliaryPreviewView.bounds.width;
    
    /// enable auto layout
    auxiliaryPreviewView.translatesAutoresizingMaskIntoConstraints = false;
    
    /// attach `auxiliaryView` to context menu preview
    auxiliaryPreviewParentView.addSubview(auxiliaryPreviewView);
    
    // get layout constraints based on config
    let constraints: [NSLayoutConstraint] = {
      var constraints: [NSLayoutConstraint] = [];
    
      // set aux preview height
      constraints.append(
        auxiliaryPreviewView.heightAnchor.constraint(
          equalToConstant: auxiliaryPreviewViewHeight
        )
      );
      
      // set vertical alignment constraint - i.e. either...
      constraints.append(
        auxiliaryPreviewMetadata.verticalAnchorPosition.createVerticalConstraints(
          forView: auxiliaryPreviewView,
          attachingTo: morphingPlatterView,
          margin: auxiliaryPreviewConfig.marginInner
        )
      );
      
      // set horizontal alignment constraints based on config...
      constraints += auxiliaryPreviewConfig.alignmentHorizontal.createHorizontalConstraints(
        forView: auxiliaryPreviewView,
        attachingTo: morphingPlatterView,
        enclosingView: contextMenuContainerView,
        preferredWidth: auxiliaryPreviewViewWidth
      );
      
      return constraints;
    }();
    
    NSLayoutConstraint.activate(constraints);
    auxiliaryPreviewView.layoutIfNeeded();
    
    self.isAuxiliaryPreviewVisible = true;
  };
  
  func nudgeContextMenuIfNeeded(){
    guard let auxiliaryPreviewMetadata = self.auxiliaryPreviewMetadata,
          auxiliaryPreviewMetadata.offsetY != 0,
    
          let contextMenuPlatterTransitionView =
            self.contextMenuPlatterTransitionViewWrapper.wrappedObject
    else { return };
    
    contextMenuPlatterTransitionView.frame = {
      let initFrame = contextMenuPlatterTransitionView.frame;
      
      return initFrame.offsetBy(
        dx: 0,
        dy: auxiliaryPreviewMetadata.offsetY
      );
    }();
  };
  
  // TODO: WIP - TEMP
  func swizzleViews(){
    guard !UIView.isSwizzlingApplied,
          let manager = self.contextMenuManager,
          let auxiliaryPreviewView = manager.auxiliaryPreviewView
    else { return };
  
    UIView.auxPreview = auxiliaryPreviewView;
    UIView.swizzlePoint();
  };
  
  // TODO: WIP - TEMP
  func unSwizzleViews(){
    guard UIView.isSwizzlingApplied else { return };

    // undo swizzling
    UIView.swizzlePoint();
    UIView.auxPreview = nil;
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
  
  public func notifyOnMenuWillShow() {
    guard self.auxiliaryPreviewMetadata != nil else { return };
    self.swizzleViews();
  };
  
  public func notifyOnMenuWillHide(){
    guard self.auxiliaryPreviewMetadata != nil,
          self.isAuxiliaryPreviewVisible
    else { return };
    
    self.unSwizzleViews();
    self.isAuxiliaryPreviewVisible = false;
  };
  
  public func attachAndAnimateInAuxiliaryPreviewTogetherWithContextMenu() {
    guard let manager = self.contextMenuManager,
          let menuAuxPreviewConfig = manager.auxiliaryPreviewConfig,
          
          case .syncedToMenuEntranceTransition =
            menuAuxPreviewConfig.transitionConfigEntrance
    else { return };
    
    self.attachAuxiliaryPreview();
  };
  
  public func attachAndAnimateInAuxiliaryPreviewUsingCustomAnimator() {
    guard let auxiliaryPreviewMetadata = self.auxiliaryPreviewMetadata,
          let manager = self.contextMenuManager,
          
          let menuAuxPreviewConfig = manager.auxiliaryPreviewConfig,
          let auxiliaryPreviewView = manager.auxiliaryPreviewView
    else { return };
    
    let transitionConfigEntrance =
      menuAuxPreviewConfig.transitionConfigEntrance;
    
    guard let transitionAnimationConfig =
            transitionConfigEntrance.transitionAnimationConfig
    else { return };
    
    self.attachAuxiliaryPreview();
    auxiliaryPreviewView.layoutIfNeeded();
    
    let animator = transitionAnimationConfig.animatorConfig.createAnimator(
      gestureInitialVelocity: .zero
    );
    
    self.customAnimator = animator;
    let keyframes = transitionAnimationConfig.transition.getKeyframes();
    
    keyframes.keyframeStart.apply(
      auxiliaryPreviewView: auxiliaryPreviewView,
      auxiliaryPreviewMetadata: auxiliaryPreviewMetadata
    );
    
    animator.addAnimations {
      keyframes.keyframeEnd.apply(
        auxiliaryPreviewView: auxiliaryPreviewView,
        auxiliaryPreviewMetadata: auxiliaryPreviewMetadata
      );
    };
    
    switch menuAuxPreviewConfig.transitionConfigEntrance {
      case .customDelay:
        animator.startAnimation(
          afterDelay: transitionAnimationConfig.delay
        );
        
      case .afterMenuEntranceTransition:
        guard let contextMenuAnimator = self.contextMenuAnimator else { return };
        
        contextMenuAnimator.addCompletion {
          animator.startAnimation(
            afterDelay: transitionAnimationConfig.delay
          );
        };
        
      default:
        break;
    };
  };
  
  public func detachAndAnimateOutAuxiliaryPreview(
    animator: UIContextMenuInteractionAnimating
  ) {
    guard let auxiliaryPreviewMetadata = self.auxiliaryPreviewMetadata,
          let manager = self.contextMenuManager,
          
          let auxiliaryPreviewConfig = manager.auxiliaryPreviewConfig,
          let auxiliaryPreviewView = manager.auxiliaryPreviewView
    else { return };
    
    let (_, exitKeyframe) =
      auxiliaryPreviewConfig.transitionConfigExit.getKeyframes();
    
    if let customAnimator = self.customAnimator,
       customAnimator.isRunning {
       
      customAnimator.stopAnimation(true);
    };
    
    animator.addAnimations {
      exitKeyframe.apply(
        auxiliaryPreviewView: auxiliaryPreviewView,
        auxiliaryPreviewMetadata: auxiliaryPreviewMetadata
      );
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
    
  
    guard let auxPreview = Self.auxPreview else {
      // call original impl.
      return self._point(inside: point, with: event);
    };
    
    // TODO:
    let isPointInsideFrameOfAuxPreview: Bool = {
      guard let window = auxPreview.window else { return false };
    
      let auxPreviewFrameAdj = auxPreview.convert(auxPreview.bounds, to: window);
      let pointAdj = self.convert(point, to: window);
    
      return auxPreviewFrameAdj.contains(pointAdj);
    }();
    
    let isParentOfAuxPreview = self.subviews.contains {
      $0 === auxPreview;
    };
    
    print("isParentOfAuxPreview:", isParentOfAuxPreview);
    
    guard isParentOfAuxPreview else {
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
