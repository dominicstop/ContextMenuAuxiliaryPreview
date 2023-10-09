//
//  ContextMenuAuxiliaryPreviewConfig.swift
//  
//
//  Created by Dominic Go on 10/9/23.
//
import Foundation
import UIKit


struct ContextMenuAuxiliaryPreviewConfig {
  
  // MARK: - Nested Types
  // --------------------
  
  enum AnchorPosition: String {
    case top, bottom, automatic;
  };
  
  enum HorizontalAlignment: String {
    case stretchScreen, stretchPreview;
    case previewLeading, previewTrailing, previewCenter;
  };
  
  enum TransitionType {
    case none, fade;
    
    case slide(slideOffset: CGFloat);
    case zoom(zoomOffset: CGFloat);
    case zoomAndSlide(slideOffset: CGFloat, zoomOffset: CGFloat);
  };
  
  struct TransitionConfig {
    static let `default`: Self = .init(
      transition: .fade,
      duration: 0.3,
      delay: 0,
      options: []
    );
  
    var transition: TransitionType;
    
    var duration: CGFloat;
    var delay: CGFloat;
    var options: UIView.AnimationOptions;
  };
  
  enum TransitionEntranceDelay: Equatable {
    case seconds(CGFloat);
    
    case RECOMMENDED;
    case AFTER_PREVIEW;
    
    init?(string: String){
      switch string {
        case "RECOMMENDED"  : self = .RECOMMENDED;
        case "AFTER_PREVIEW": self = .AFTER_PREVIEW;
          
        default: return nil;
      };
    };
    
    var seconds: CGFloat {
      switch self {
        case .seconds(let seconds):
          return seconds;
          
        case .AFTER_PREVIEW: return 0;
        case .RECOMMENDED  : return 0.25;
      };
    };
  };
  
  // MARK: - Properties
  // ------------------
  
  var height: CGFloat?;
  var width: CGFloat?;

  var anchorPosition: AnchorPosition;
  var alignmentHorizontal: HorizontalAlignment;
  
  var marginPreview: CGFloat;
  var marginAuxiliaryPreview: CGFloat;

  var transitionConfigEntrance: TransitionConfig;
  var transitionEntranceDelay: TransitionEntranceDelay;
};



