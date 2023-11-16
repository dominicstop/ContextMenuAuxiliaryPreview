//
//  AuxiliaryPreviewPopoverScrollViewMetadata.swift
//  
//
//  Created by Dominic Go on 11/16/23.
//

import UIKit
import DGSwiftUtilities

//
// +---------------+ topEdgeMax
// |               |
// |               |
// +---------------+ topEdgeMin
// |               |
// |               |
// |               |
// |               |
// +---------------+ bottomEdgeMin
// |               |
// |               |
// +---------------+ bottomEdgeMax
//
struct AuxiliaryPreviewPopoverScrollViewMetadata {

  weak var parentScrollView: UIScrollView?;
  var parentScrollViewFrame: CGRect;
  var parentScrollViewGlobalFrame: CGRect;
      
  var targetFrame: CGRect;
  var targetGlobalFrame: CGRect;
  
  var minDistanceFromTopEdge: CGFloat;
  var minDistanceFromBottomEdge: CGFloat;
  
  var topEdgeMax: CGFloat;
  var bottomEdgeMax: CGFloat;
  
  var topEdgeMin: CGFloat;
  var bottomEdgeMin: CGFloat;
  
  var targetDistanceFromTopEdge: CGFloat;
  var targetDistanceFromBottomEdge: CGFloat;
  
  var isTargetAboveTopEdge: Bool;
  var isTargetBelowBottomEdge: Bool;
  var isTargetOutsideVerticalEdges: Bool;
  
  let scrollViewContentOffsetAdjY: CGFloat;
  
  init(
    targetView: UIView,
    auxiliaryPreviewConfig: AuxiliaryPreviewConfig,
    auxiliaryPreviewMetadata: AuxiliaryPreviewMetadata
  ) throws {
  
    guard let _ = targetView.window else {
      throw AuxiliaryPreviewError(
        errorCode: .unexpectedNilValue,
        description: "`targetView.window` is nil"
      );
    };
  
    let targetFrame = targetView.frame;
    self.targetFrame = targetFrame;
  
    let parentScrollView =
      targetView.recursivelyFindParentView(whereType: UIScrollView.self);
  
    guard let parentScrollView = parentScrollView else {
      throw AuxiliaryPreviewError(
        errorCode: .unexpectedNilValue,
        description: "Could not find parent scroll view instance for `targetView`"
      );
    };
    
    let parentScrollViewFrame = parentScrollView.frame;
    self.parentScrollViewFrame = parentScrollViewFrame;
    
    guard let parentScrollViewGlobalFrame = parentScrollView.globalFrame else {
      throw AuxiliaryPreviewError(
        errorCode: .unexpectedNilValue,
        description: "Could not get `globalFrame` for `parentScrollView`"
      );
    };
    
    self.parentScrollViewGlobalFrame = parentScrollViewGlobalFrame;
    
    guard let targetGlobalFrame = targetView.globalFrame else {
      throw AuxiliaryPreviewError(
        errorCode: .unexpectedNilValue,
        description: "Could not get `globalFrame` from `targetView`"
      );
    };
    
    self.targetGlobalFrame = targetGlobalFrame;
    
    // MARK: Computation Start
    // -----------------------
    
    let safeAreaInsets = parentScrollView.safeAreaInsets;
    
    let minDistanceFromTopEdge: CGFloat = {
      switch auxiliaryPreviewMetadata.verticalAnchorPosition {
        case .top:
          return
              auxiliaryPreviewMetadata.computedHeight
            + auxiliaryPreviewConfig.marginInner
            + auxiliaryPreviewConfig.marginOuter;
        
        case .bottom:
          return auxiliaryPreviewConfig.marginOuter;
      };
    }();
    
    self.minDistanceFromTopEdge = minDistanceFromTopEdge;
    
    let minDistanceFromBottomEdge: CGFloat = {
      switch auxiliaryPreviewMetadata.verticalAnchorPosition {
        case .top:
          return
              safeAreaInsets.top
            + auxiliaryPreviewConfig.marginOuter;
            
        case .bottom:
          return
              safeAreaInsets.top
            + auxiliaryPreviewMetadata.computedHeight
            + auxiliaryPreviewConfig.marginInner
            + auxiliaryPreviewConfig.marginOuter;
      };
    }();
      
    self.minDistanceFromBottomEdge = minDistanceFromBottomEdge;
    
    let topEdgeMax = parentScrollViewGlobalFrame.minY;
    self.topEdgeMax = topEdgeMax;
    
    let bottomEdgeMax = parentScrollViewGlobalFrame.maxY;
    self.bottomEdgeMax = bottomEdgeMax;
    
    // TODO: WIP - does not account for top nav bar
    let topEdgeMin = topEdgeMax + safeAreaInsets.top;
    self.topEdgeMin = topEdgeMin;
     
    // TODO: WIP - does not account for bottom tab bar
    let bottomEdgeMin = bottomEdgeMax - safeAreaInsets.bottom;
    self.bottomEdgeMin = bottomEdgeMin;
    
    /// "target min y" - "scrollview min y"
    ///
    /// * 0 means touching top edge
    /// * negative means offscreen top
    /// * positive means inside scrollview
    ///
    let targetDistanceFromTopEdge = targetGlobalFrame.minY - topEdgeMin;
    self.targetDistanceFromTopEdge = targetDistanceFromTopEdge;
    
    /// "target max y" - "scrollview max y"
    ///
    /// * 0 means touching bottom edge
    /// * negative means offscreen bottom
    /// * positive means inside
    ///
    let targetDistanceFromBottomEdge = bottomEdgeMin - targetGlobalFrame.maxY;
    self.targetDistanceFromBottomEdge = targetDistanceFromBottomEdge;
    
    let isTargetAboveTopEdge =
      targetDistanceFromTopEdge < minDistanceFromTopEdge;
      
    self.isTargetAboveTopEdge = isTargetAboveTopEdge;
      
    let isTargetBelowBottomEdge =
      targetDistanceFromBottomEdge < minDistanceFromBottomEdge;
      
    self.isTargetBelowBottomEdge = isTargetBelowBottomEdge;
    
    let isTargetOutsideVerticalEdges =
      isTargetAboveTopEdge || isTargetBelowBottomEdge;
      
    self.isTargetOutsideVerticalEdges = isTargetOutsideVerticalEdges;
    
    let scrollViewContentOffsetAdjY: CGFloat = {
      if isTargetAboveTopEdge {
        
        /// Note: This assumes that `topEdgeMax` is 0
        let offScreenAdj = targetGlobalFrame.minY < 0
          ? abs(targetGlobalFrame.minY)
          : 0;
          
        let baseAdj = targetGlobalFrame.minY >= 0
          ? (minDistanceFromTopEdge - targetGlobalFrame.minY)
          : minDistanceFromTopEdge;
        
        return offScreenAdj + baseAdj;
      };
      
      if isTargetBelowBottomEdge {
        let offScreenAdj = targetGlobalFrame.maxY > bottomEdgeMax
          ? targetGlobalFrame.maxY - bottomEdgeMax
          : 0;
          
        let baseAdj = targetGlobalFrame.maxY <= bottomEdgeMax
          ? targetGlobalFrame.maxY - bottomEdgeMin
          : bottomEdgeMax - bottomEdgeMin;
          
        return -(offScreenAdj + baseAdj);
      };
      
      return 0;
    }();
    
    self.scrollViewContentOffsetAdjY = scrollViewContentOffsetAdjY;
  };
  
  func debugPrint(){
    print(
      "AuxiliaryPreviewPopoverScrolViewMetadata",
      "\n- parentScrollView == nil:", self.parentScrollView == nil,
      "\n- parentScrollViewFrame:", self.parentScrollViewFrame,
      "\n- parentScrollViewGlobalFrame:", self.parentScrollViewGlobalFrame,
      "\n- targetFrame:", self.targetFrame,
      "\n- targetGlobalFrame:", self.targetGlobalFrame,
      "\n- minDistanceFromTopEdge:", self.minDistanceFromTopEdge,
      "\n- minDistanceFromBottomEdge:", self.minDistanceFromBottomEdge,
      "\n- topEdgeMax:", self.topEdgeMax,
      "\n- bottomEdgeMax:", self.bottomEdgeMax,
      "\n- topEdgeMin:", self.topEdgeMin,
      "\n- bottomEdgeMin:", self.bottomEdgeMin,
      "\n- targetDistanceFromTopEdge:", self.targetDistanceFromTopEdge,
      "\n- targetDistanceFromBottomEdge:", self.targetDistanceFromBottomEdge,
      "\n- isTargetAboveTopEdge:", self.isTargetAboveTopEdge,
      "\n- isTargetBelowBottomEdge:", self.isTargetBelowBottomEdge,
      "\n- isTargetOutsideVerticalEdges:", self.isTargetOutsideVerticalEdges,
      "\n- scrollViewContentOffsetAdjY:", self.scrollViewContentOffsetAdjY,
      "\n"
    );
  };
};