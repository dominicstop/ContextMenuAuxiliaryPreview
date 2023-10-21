//
//  ContextMenuManager.swift
//  
//
//  Created by Dominic Go on 10/7/23.
//

import UIKit



struct AuxiliaryPreviewTransitionKeyframe {
  var opacity: CGFloat;
};

struct AuxiliaryPreviewTransitionConfig {
  var keyframeStart: AuxiliaryPreviewTransitionKeyframe;
  var keyframeEnd: AuxiliaryPreviewTransitionKeyframe;
};


class AuxiliaryRootView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame);
    
    self.backgroundColor = .red;
  };
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  };
};


public class ContextMenuManager {

  static weak var auxPreview: AuxiliaryRootView?;
  
  // MARK: - Properties
  // ------------------
  
  public var menuAuxPreviewConfig: ContextMenuAuxiliaryPreviewConfig?;
  var auxPreviewManager: ContextMenuAuxiliaryPreviewManager?;
  
  public var isAuxiliaryPreviewEnabled = false;
  
  public var isContextMenuVisible = false;
  public var isAuxPreviewVisible = false;
  
  // temp
  lazy var menuAuxiliaryPreviewView: AuxiliaryRootView? = {
    let view = AuxiliaryRootView(frame: .init(
      origin: .zero,
      size: .init(
        width: 100,
        height: 100
      )
    ));
    
    return view;
  }();
  
  // MARK: - Properties - References
  // -------------------------------
  
  /// A reference to the view that contains the context menu interaction
  public weak var menuTargetView: UIView?;
  
  /// A reference to the `UIContextMenuInteraction` interaction config that
  /// the `targetView` is using
  public weak var contextMenuInteraction: UIContextMenuInteraction?;
  
  /// A reference to the view controller that contains the custom context menu
  /// preview that will be used when the menu is shown
  public weak var menuCustomPreviewController: UIViewController?;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  /// Gets the `_UIContextMenuContainerView` that's holding the context menu
  /// controls.
  ///
  /// **Note**: This `UIView` instance  only exists whenever there's a
  /// context menu interaction.
  ///
  var contextMenuContainerViewWrapper: ContextMenuContainerViewWrapper? {
    guard let targetView = self.menuTargetView,
          let window = targetView.window
    else { return nil };
    
    return window.subviews.reduce(nil) { (prev, subview) in
      prev ?? ContextMenuContainerViewWrapper(objectToWrap: subview);
    };
  };
  
  var isUsingCustomMenuPreview: Bool {
    self.menuCustomPreviewController != nil
  };
  
  // MARK: - Init
  // ------------
  
  public init(
    contextMenuInteraction: UIContextMenuInteraction,
    menuTargetView: UIView
  ) {
    self.contextMenuInteraction = contextMenuInteraction;
    self.menuTargetView = menuTargetView;
  };
  
  // MARK: - Internal Functions
  // --------------------------
  
  // MARK: Experimental - "Auxiliary Context Menu Preview"-Related
  func attachContextMenuAuxiliaryPreviewIfAny(
    _ animator: UIContextMenuInteractionAnimating!
  ) {
  
    let auxPreviewManager = ContextMenuAuxiliaryPreviewManager(
      usingContextMenuManager: self,
      contextMenuAnimator: animator
    );
  
    guard let auxPreviewManager = auxPreviewManager else { return };
    self.auxPreviewManager = auxPreviewManager;

    auxPreviewManager.attachAndAnimateInAuxiliaryPreview();
    self.isAuxPreviewVisible = true;
  };
  
  // MARK: Experimental - "Auxiliary Context Menu Preview"-Related
  func detachContextMenuAuxiliaryPreviewIfAny(
    _ animator: UIContextMenuInteractionAnimating?
  ){
    
    guard self.isAuxiliaryPreviewEnabled,
          self.isAuxPreviewVisible,
          
          let animator = animator,
          let menuAuxiliaryPreviewView = self.menuAuxiliaryPreviewView,
          let auxPreviewManager = self.auxPreviewManager
    else { return };
    
    /// Bug:
    /// * "Could not locate shadow view with tag #, this is probably caused by a temporary inconsistency
    ///   between native views and shadow views."
    /// * Triggered when the menu is about to be hidden, iOS removes the context menu along with the
    ///   `previewAuxiliaryViewContainer`
    ///
    
    // reset flag
    self.isAuxPreviewVisible = false;
    
    // Add exit transition
    animator.addAnimations {
      var transform = menuAuxiliaryPreviewView.transform;
      
      // transition - fade out
      menuAuxiliaryPreviewView.alpha = 0;
      
      // transition - zoom out
      transform = transform.scaledBy(x: 0.7, y: 0.7);
      
      // transition - slide out
      switch auxPreviewManager.morphingPlatterViewPlacement {
        case .top:
          transform = transform.translatedBy(x: 0, y: 50);
          
        case .bottom:
          transform = transform.translatedBy(x: 0, y: -50);
      };
      
      // transition - apply transform
      menuAuxiliaryPreviewView.transform = transform;
    };
    
    animator.addCompletion { [unowned self] in
      menuAuxiliaryPreviewView.removeFromSuperview();
      
      // clear value
      self.auxPreviewManager = nil;
      
      // MARK: Bugfix - Aux-Preview Touch Event on Screen Edge
      if UIView.isSwizzlingApplied {
        // undo swizzling
        UIView.swizzlePoint();
        Self.auxPreview = nil;
      };
    };
  };
  
  // MARK: - Public Functions
  // ------------------------
  
  // context menu display begins
  public func notifyOnContextMenuInteraction(
    _ interaction: UIContextMenuInteraction,
    willDisplayMenuFor configuration: UIContextMenuConfiguration,
    animator: UIContextMenuInteractionAnimating?
  ) {
  
    if let animator = animator {
      animator.addAnimations {
        self.attachContextMenuAuxiliaryPreviewIfAny(animator);
      };
    
      animator.addCompletion {
        self.isContextMenuVisible = true;
      };
      
    } else {
      self.isContextMenuVisible = true;
    };
  };
  
  public func notifyOnContextMenuInteraction(
    _ interaction: UIContextMenuInteraction,
    willEndFor configuration: UIContextMenuConfiguration,
    animator: UIContextMenuInteractionAnimating?
  ) {
  
    if let animator = animator {
      animator.addCompletion {
        self.isContextMenuVisible = false;
      };
      
    } else {
      self.isContextMenuVisible = false;
    };
  };
};
