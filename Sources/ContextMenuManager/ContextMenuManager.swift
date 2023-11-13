//
//  ContextMenuManager.swift
//  
//
//  Created by Dominic Go on 10/7/23.
//

import UIKit


public class ContextMenuManager {

  static weak var auxiliaryPreview: UIView?;
  
  // MARK: - Properties
  // ------------------
  
  public var auxiliaryPreviewConfig: AuxiliaryPreviewConfig?;
  
  var auxiliaryPreviewMenuManager: AuxiliaryPreviewMenuManager? {
    willSet {
      guard let newValue = newValue else { return };
      
      self.attachAndAnimateAuxiliaryPreviewUsingCustomAnimator(
        usingAuxiliaryPreviewMenuManager: newValue
      );
    }
  };
  
  public var isAuxiliaryPreviewEnabled = true;
  public var isContextMenuVisible = false;
  
  public var auxiliaryPreviewView: UIView?;
  
  var auxiliaryPreviewModalManager: AuxiliaryPreviewModalManager?;
  var auxiliaryPreviewModalVC: AuxiliaryPreviewModalViewController?;
  
  // MARK: - Properties - References
  // -------------------------------
  
  public weak var delegate: ContextMenuManagerDelegate?;
  
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
  
  public var isUsingCustomMenuPreview: Bool {
    self.menuCustomPreviewController != nil
  };

  public var isAuxiliaryPreviewMenuVisible: Bool {
    self.auxiliaryPreviewMenuManager?.isAuxiliaryPreviewVisible ?? false;
  };
  
  public var isAuxiliaryPreviewModalVisible: Bool {
    self.auxiliaryPreviewModalManager?.isPresenting ?? false;
  };
  
  public var isAuxiliaryPreviewVisible: Bool {
       self.isAuxiliaryPreviewMenuVisible
    || self.isAuxiliaryPreviewModalVisible;
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
  
  // MARK: - Functions
  // -----------------
  
  func attachAndAnimateAuxiliaryPreviewUsingCustomAnimator(
    usingAuxiliaryPreviewMenuManager manager: AuxiliaryPreviewMenuManager
  ){
    guard self.isAuxiliaryPreviewEnabled,
          self.auxiliaryPreviewView != nil,
          self.auxiliaryPreviewConfig != nil
    else { return };
    
    manager.attachAndAnimateInAuxiliaryPreviewUsingCustomAnimator();
  };
  
  // MARK: - Public Functions
  // ------------------------
  
  public func showAuxiliaryPreviewAsPopover(
    presentingViewController presentingVC: UIViewController
  ){
    guard !self.isAuxiliaryPreviewVisible,
    
          let auxiliaryPreviewConfig = self.auxiliaryPreviewConfig,
          let menuTargetView = self.menuTargetView,
          let delegate = self.delegate
    else { return };
    
    let auxPreviewView = delegate.onRequestMenuAuxiliaryPreview(sender: self);
    self.auxiliaryPreviewView = auxPreviewView;
    
    let modalVC = AuxiliaryPreviewModalViewController();
    modalVC.view = auxPreviewView;
    
    self.auxiliaryPreviewModalVC = modalVC;
    
    let modalManager = AuxiliaryPreviewModalManager(
      auxiliaryPreviewConfig: auxiliaryPreviewConfig
    );
    
    modalManager.delegate = self;
    self.auxiliaryPreviewModalManager = modalManager;
    
    modalManager.present(
      viewControllerToPresent: modalVC,
      presentingViewController: presentingVC,
      targetView: menuTargetView
    );
  };
  
  // MARK: - Public Functions - UIContextMenuInteraction
  // ---------------------------------------------------
  
  // context menu display begins
  public func notifyOnContextMenuInteraction(
    _ interaction: UIContextMenuInteraction,
    willDisplayMenuFor configuration: UIContextMenuConfiguration,
    animator: UIContextMenuInteractionAnimating?
  ) {
  
    self.isContextMenuVisible = true;
    
    guard self.isAuxiliaryPreviewEnabled,
          let auxiliaryPreviewConfig = self.auxiliaryPreviewConfig,
          let animator = animator,
          let delegate = self.delegate
    else { return };
    
    self.auxiliaryPreviewView =
      delegate.onRequestMenuAuxiliaryPreview(sender: self);
      
    animator.addAnimations {
      let auxPreviewManager = AuxiliaryPreviewMenuManager(
        usingContextMenuManager: self,
        contextMenuAnimator: animator
      );
      
      guard let auxPreviewManager = auxPreviewManager else { return };
      self.auxiliaryPreviewMenuManager = auxPreviewManager;
      
      auxPreviewManager.nudgeContextMenuIfNeeded();
      auxPreviewManager.notifyOnMenuWillShow();
      
      guard case .syncedToMenuEntranceTransition =
              auxiliaryPreviewConfig.transitionConfigEntrance
      else { return };
      
      print(
        "notifyOnContextMenuInteraction",
        "- addAnimations block"
      );
      
      auxPreviewManager.debugPrintValues();
      auxPreviewManager.attachAndAnimateInAuxiliaryPreviewTogetherWithContextMenu();
    };
    
    animator.addCompletion {
      print(
        "notifyOnContextMenuInteraction",
        "- addCompletion block"
      );
      
      self.auxiliaryPreviewMenuManager?.debugPrintValues();
    };
  };
  
  // context menu display ends
  public func notifyOnContextMenuInteraction(
    _ interaction: UIContextMenuInteraction,
    willEndFor configuration: UIContextMenuConfiguration,
    animator: UIContextMenuInteractionAnimating?
  ) {
  
    guard self.isAuxiliaryPreviewEnabled,
          let animator = animator,
          let auxPreviewManager = self.auxiliaryPreviewMenuManager
    else { return };
    
    auxPreviewManager.notifyOnMenuWillHide();
    
    animator.addAnimations {
      auxPreviewManager.detachAndAnimateOutAuxiliaryPreview();
    };
    
    animator.addCompletion {
      self.isContextMenuVisible = false;
      self.auxiliaryPreviewMenuManager = nil;
      self.auxiliaryPreviewView = nil;
    };
  };
};
