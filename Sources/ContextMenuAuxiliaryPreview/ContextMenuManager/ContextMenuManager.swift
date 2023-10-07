//
//  ContextMenuManager.swift
//  
//
//  Created by Dominic Go on 10/7/23.
//

import UIKit

class AuxiliaryRootView: UIView {

};

public class ContextMenuManager {
  
  /// A reference to the view that contains the context menu interaction
  public weak var targetView: UIView?;
  
  /// A reference to the `UIContextMenuInteraction` interaction config that
  /// the `targetView` is using
  public weak var contextMenuInteraction: UIContextMenuInteraction?;
  
  public var isContextMenuVisible = false;
  
  var displayLink: CADisplayLink?;
  var displayLinkStartTimestamp: CFTimeInterval?;
  
  
  // MARK: - Computed Properties
  // ---------------------------
  
  /// Gets the `_UIContextMenuContainerView` that's holding the context menu
  /// controls.
  ///
  /// **Note**: This `UIView` instance  only exists whenever there's a
  /// context menu interaction.
  ///
  var contextMenuContainerView: UIView? {
    guard let targetView = self.targetView,
          let window = targetView.window
    else { return nil };
    
    
    return window.subviews.first {
      ($0.gestureRecognizers?.count ?? 0) > 0
    };
  };
  
  // MARK: - Init
  // ------------
  
  public init(
    contextMenuInteraction: UIContextMenuInteraction,
    targetView: UIView
  ) {
    self.contextMenuInteraction = contextMenuInteraction;
    self.targetView = targetView;
  };
    // MARK: - Functions
  // -----------------
  
  // context menu display begins
  public func notifyOnContextMenuInteraction(
    _ interaction: UIContextMenuInteraction,
    willDisplayMenuFor configuration: UIContextMenuConfiguration,
    animator: UIContextMenuInteractionAnimating?
  ) {
  
    animator?.addAnimations {
      guard let contextMenuContainerView = self.contextMenuContainerView
      else { return };
    
    };
    
    if let animator = animator {
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
  
  // MARK: - Functions - DisplayLink-Related
  // ---------------------------------------
    
  func startDisplayLink(shouldAutoEndDisplayLink: Bool) {
    let displayLink = CADisplayLink(
      target: self,
      selector: #selector(self.onDisplayLinkTick(displayLink:))
    );
    
    self.displayLink = displayLink;
    
    if #available(iOS 15.0, *) {
      displayLink.preferredFrameRateRange =
        CAFrameRateRange(minimum: 60, maximum: 120);
      
    } else {
      displayLink.preferredFramesPerSecond = 60;
    };
    
    displayLink.add(to: .current, forMode: .common);
  };
  
  func endDisplayLink() {
    self.displayLink?.invalidate();
  };
  
  @objc private func onDisplayLinkTick(displayLink: CADisplayLink) {
    var shouldEndDisplayLink = false;
    
    defer {
      if shouldEndDisplayLink {
        self.endDisplayLink();
      };
    };
    
    if self.displayLinkStartTimestamp == nil {
      self.displayLinkStartTimestamp = displayLink.timestamp;
    };
  };
};
