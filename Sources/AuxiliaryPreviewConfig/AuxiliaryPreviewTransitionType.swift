//
//  AuxiliaryPreviewTransitionType.swift
//  
//
//  Created by Dominic Go on 11/14/23.
//

import Foundation


public enum AuxiliaryPreviewTransitionType {

  // MARK: - Static Properties
  // -------------------------

  public static var defaultSlideOffset: CGFloat = 20;
  public static var defaultZoomOffset: CGFloat = 0.8;
  
  // MARK: - Enum Cases
  // ------------------

  case none;
  case fade;
  
  case slide(slideOffset: CGFloat = Self.defaultSlideOffset);
  case zoom(zoomOffset: CGFloat = Self.defaultZoomOffset);
  
  case zoomAndSlide(
    slideOffset: CGFloat = Self.defaultSlideOffset,
    zoomOffset: CGFloat = Self.defaultZoomOffset
  );
  
  case custom(
    keyframeStart: AuxiliaryPreviewTransitionKeyframeConfig,
    keyframeEnd: AuxiliaryPreviewTransitionKeyframeConfig
  );
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var transitionKeyframeConfig: (
    keyframeStart: AuxiliaryPreviewTransitionKeyframeConfig,
    keyframeEnd: AuxiliaryPreviewTransitionKeyframeConfig
  ) {
    switch self {
      case .none:
        return (
          keyframeStart: .init(
            opacity: 1
          ),
          keyframeEnd: .init(
            opacity: 1
          )
        );
        
      case .fade:
        return (
          keyframeStart: .init(
            opacity: 0
          ),
          keyframeEnd: .init(
            opacity: 1
          )
        );
        
      case let .slide(slideOffset):
        return (
          keyframeStart: .init(
            opacity: 0,
            transform: .init(
              translateY: slideOffset
            )
          ),
          keyframeEnd: .init(
            opacity: 1,
            transform: .default
          )
        );
        
      case let .zoom(zoomOffset):
        return (
          keyframeStart: .init(
            opacity: 0,
            transform: .init(
              scaleX: zoomOffset,
              scaleY: zoomOffset
            )
          ),
          keyframeEnd: .init(
            opacity: 1,
            transform: .default
          )
        );
        
      case let .zoomAndSlide(slideOffset, zoomOffset):
        return (
          keyframeStart: .init(
            opacity: 0,
            transform: .init(
              translateY: slideOffset,
              scaleX: zoomOffset,
              scaleY: zoomOffset
            )
          ),
          keyframeEnd: .init(
            opacity: 1,
            transform: .default
          )
        );
        
      case let .custom(keyframeStart, keyframeEnd):
        return(keyframeStart, keyframeEnd);
    };
  };
};
