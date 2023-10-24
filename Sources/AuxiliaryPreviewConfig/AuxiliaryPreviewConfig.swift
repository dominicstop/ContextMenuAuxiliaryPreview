//
//  AuxiliaryPreviewConfig.swift
//  
//
//  Created by Dominic Go on 10/9/23.
//
import Foundation
import UIKit


public struct AuxiliaryPreviewConfig {
  
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

  // MARK: - Properties
  // ------------------
  
  public var height: CGFloat?;
  public var width: CGFloat?;

  public var anchorPosition: AnchorPosition;
  public var alignmentHorizontal: HorizontalAlignment;
  
  public var marginPreview: CGFloat;
  public var marginAuxiliaryPreview: CGFloat;

  public var transitionConfigEntrance: AuxiliaryPreviewTransitionConfig;
  
  // MARK: - Init
  // ------------
  
  public init(
    height: CGFloat? = nil,
    width: CGFloat? = nil,
    anchorPosition: AnchorPosition,
    alignmentHorizontal: HorizontalAlignment,
    marginPreview: CGFloat,
    marginAuxiliaryPreview: CGFloat,
    transitionConfigEntrance: AuxiliaryPreviewTransitionConfig
  ) {
  
    self.height = height;
    self.width = width;
    self.anchorPosition = anchorPosition;
    self.alignmentHorizontal = alignmentHorizontal;
    self.marginPreview = marginPreview;
    self.marginAuxiliaryPreview = marginAuxiliaryPreview;
    self.transitionConfigEntrance = transitionConfigEntrance;
  }
};
