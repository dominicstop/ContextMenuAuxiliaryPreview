//
//  ContextMenuAuxiliaryPreviewConfig.swift
//  
//
//  Created by Dominic Go on 10/9/23.
//
import Foundation
import UIKit


public struct ContextMenuAuxiliaryPreviewConfig {
  
  // MARK: - Nested Types
  // --------------------
  
  public enum AnchorPosition: String {
    case top, bottom, automatic;
  };
  
  public enum HorizontalAlignment: String {
    case stretchScreen, stretchPreview;
    case previewLeading, previewTrailing, previewCenter;
  };
  
  public enum TransitionType {
    case none, fade;
    
    case slide(slideOffset: CGFloat);
    case zoom(zoomOffset: CGFloat);
    case zoomAndSlide(slideOffset: CGFloat, zoomOffset: CGFloat);
  };
  
  public struct TransitionConfig {
    public static let `default`: Self = .init(
      transition: .fade,
      duration: 0.3,
      delay: 0,
      options: []
    );
  
   public var transition: TransitionType;
    
   public var duration: CGFloat;
   public var delay: CGFloat;
   public var options: UIView.AnimationOptions;
  };
  
  public enum TransitionEntranceDelay: Equatable {
    case seconds(CGFloat);
    
    case RECOMMENDED;
    case AFTER_PREVIEW;
    
    public var seconds: CGFloat {
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
  
  public var height: CGFloat?;
  public var width: CGFloat?;

  public var anchorPosition: AnchorPosition;
  public var alignmentHorizontal: HorizontalAlignment;
  
  public var marginPreview: CGFloat;
  public var marginAuxiliaryPreview: CGFloat;

  public var transitionConfigEntrance: TransitionConfig;
  public var transitionEntranceDelay: TransitionEntranceDelay;
  
  // MARK: - Init
  // ------------
  
  public init(
    height: CGFloat? = nil,
    width: CGFloat? = nil,
    anchorPosition: AnchorPosition,
    alignmentHorizontal: HorizontalAlignment,
    marginPreview: CGFloat,
    marginAuxiliaryPreview: CGFloat,
    transitionConfigEntrance: TransitionConfig,
    transitionEntranceDelay: TransitionEntranceDelay
  ) {
  
    self.height = height
    self.width = width
    self.anchorPosition = anchorPosition
    self.alignmentHorizontal = alignmentHorizontal
    self.marginPreview = marginPreview
    self.marginAuxiliaryPreview = marginAuxiliaryPreview
    self.transitionConfigEntrance = transitionConfigEntrance
    self.transitionEntranceDelay = transitionEntranceDelay
  }
};
