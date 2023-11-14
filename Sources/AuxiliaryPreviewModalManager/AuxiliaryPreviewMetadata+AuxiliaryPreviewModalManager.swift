//
//  AuxiliaryPreviewMenuMetadata+AuxiliaryPreviewModalManager.swift
//  
//
//  Created by Dominic Go on 11/10/23.
//

import Foundation

extension AuxiliaryPreviewMetadata {

  init?(auxiliaryPreviewModalManager manager: AuxiliaryPreviewModalManager) {
  
    guard let presentedController = manager.presentedController,
          let auxiliaryPreviewController = manager.auxiliaryPreviewController,
          let targetView = manager.targetView,
          let window = targetView.window
    else { return nil };
    
    let auxiliaryPreviewConfig = manager.auxiliaryPreviewConfig;
  
    let sizeValueContext = AuxiliaryPreviewSizeValue.Context(
      windowSize: window.bounds.size,
      previewFrame: targetView.frame
    );
    
    self.computedWidth = {
      let computedWidth = auxiliaryPreviewConfig.preferredWidth?.compute(
        computingForSizeKey: \.width,
        usingContext: sizeValueContext
      );
      
      let fallbackWidth: CGFloat = {
        switch auxiliaryPreviewConfig.alignmentHorizontal {
          case .stretch:
            return presentedController.view.frame.width;
        
          case .stretchTarget:
            return targetView.frame.size.width;
            
          default:
            return max(
              auxiliaryPreviewController.preferredContentSize.width,
              auxiliaryPreviewController.view.frame.size.width
            );
        };
      
      }();
      
      return computedWidth ?? fallbackWidth;
    }();
    
    self.computedHeight = {
      let computedHeight = auxiliaryPreviewConfig.preferredHeight?.compute(
        computingForSizeKey: \.height,
        usingContext: sizeValueContext
      );
      
      let fallbackHeight = max(
        auxiliaryPreviewController.preferredContentSize.height,
        auxiliaryPreviewController.view.frame.size.height
      );
        
      return computedHeight ?? fallbackHeight;
    }();
    
    self.verticalAnchorPosition = {
      let preferredAnchorPosition = auxiliaryPreviewConfig.verticalAnchorPosition;
      
      if let preferredAnchorPosition = preferredAnchorPosition.verticalAnchorPosition {
        return preferredAnchorPosition;
      };
      
      switch auxiliaryPreviewConfig.verticalAnchorPosition {
        case .top:
          return .top;
        
        case .bottom:
          return .bottom;
          
        case .automatic:
          let targetViewY = targetView.frame.midY;
          let rootViewY = presentedController.view.frame.midY;
          
          return targetViewY <= rootViewY ? .bottom : .top
      };
    }();
    
    // TODO: WIP - To be implemented
    self.offsetY = 0;
  };
};
