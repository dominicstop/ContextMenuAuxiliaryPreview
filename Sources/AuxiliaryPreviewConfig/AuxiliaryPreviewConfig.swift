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
  
  public enum TransitionType {
    case none, fade;
    
    case slide(slideOffset: CGFloat);
    case zoom(zoomOffset: CGFloat);
    case zoomAndSlide(slideOffset: CGFloat, zoomOffset: CGFloat);
  };

  // MARK: - Properties
  // ------------------

  public var anchorPosition: AuxiliaryPreviewAnchorPosition;
  public var alignmentHorizontal: AuxiliaryPreviewHorizontalAlignment;
  
  public var auxiliaryPreviewPreferredWidth: AuxiliaryPreviewSizeValue?;
  public var auxiliaryPreviewPreferredHeight: AuxiliaryPreviewSizeValue?;
  
  /// The distance between the aux. preview, and the menu preview
  public var auxiliaryPreviewMarginInner: CGFloat;
  
  /// The min. distance of the aux. preview from the edges of the window
  public var auxiliaryPreviewMarginOuter: CGFloat;

  public var transitionConfigEntrance: AuxiliaryPreviewTransitionConfig;
  
  // MARK: - Init
  // ------------
  
  public init(
    anchorPosition: AuxiliaryPreviewAnchorPosition,
    alignmentHorizontal: AuxiliaryPreviewHorizontalAlignment,
    auxiliaryPreviewMarginInner: CGFloat,
    auxiliaryPreviewMarginOuter: CGFloat,
    transitionConfigEntrance: AuxiliaryPreviewTransitionConfig
  ) {
  
    self.anchorPosition = anchorPosition;
    self.alignmentHorizontal = alignmentHorizontal;
    self.auxiliaryPreviewMarginInner = auxiliaryPreviewMarginInner;
    self.auxiliaryPreviewMarginOuter = auxiliaryPreviewMarginOuter;
    self.transitionConfigEntrance = transitionConfigEntrance;
  };
};
