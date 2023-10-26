//
//  AuxiliaryPreviewSizeValue.swift
//  
//
//  Created by Dominic Go on 10/25/23.
//

import Foundation


public enum AuxiliaryPreviewSizeValue {
  
  case constant(CGFloat);
  case percentRelativeToWindow(CGFloat);
  case percentRelativeToPreview(CGFloat);
  
  case multipleValues([Self]);
  
  func compute(
    computingForSizeKey sizeKey: KeyPath<CGSize, CGFloat>,
    usingAuxiliaryPreviewManager auxPreviewManager: ContextMenuAuxiliaryPreviewManager
  ) -> CGFloat? {
  
    switch self {
      case let .constant(size):
        return size;
        
      case let .percentRelativeToWindow(percent):
        guard let window = auxPreviewManager.window else { return nil };
        
        let windowSize = window.bounds.size[keyPath: sizeKey];
        return windowSize * percent;
        
      case let .percentRelativeToPreview(percent):
        guard let auxPreviewTargetView = auxPreviewManager.auxPreviewTargetView
        else { return nil };
        
        let previewSize = auxPreviewTargetView.bounds.size[keyPath: sizeKey];
        return previewSize * percent;
      
      case let .multipleValues(sizeValues):
        let computedSizes = sizeValues.compactMap {
          $0.compute(
            computingForSizeKey: sizeKey,
            usingAuxiliaryPreviewManager: auxPreviewManager
          );
        };
      
        return computedSizes.reduce(0) {
          $0 + $1;
        };
    };
  };
};
