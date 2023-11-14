//
//  AuxiliaryPreviewConfig.swift
//  
//
//  Created by Dominic Go on 10/9/23.
//
import Foundation
import UIKit


public struct AuxiliaryPreviewConfig {
  
  // MARK: - Properties
  // ------------------

  public var verticalAnchorPosition: AuxiliaryPreviewVerticalAnchorPosition;
  public var alignmentHorizontal: HorizontalAnchorPosition;
  
  public var height: AuxiliaryPreviewSizeValue;
  public var preferredWidth: AuxiliaryPreviewSizeValue?;
  
  /// The distance between the aux. preview, and the menu preview
  public var marginInner: CGFloat;
  
  /// The min. distance of the aux. preview from the edges of the window
  public var marginOuter: CGFloat;

  public var transitionConfigEntrance: AuxiliaryPreviewEntranceTransitionConfig;
  public var transitionConfigExit: AuxiliaryPreviewTransitionConfig;
  
  // MARK: - Init
  // ------------
  
  public init(
    verticalAnchorPosition: AuxiliaryPreviewVerticalAnchorPosition,
    alignmentHorizontal: HorizontalAnchorPosition,
    height: AuxiliaryPreviewSizeValue,
    preferredWidth: AuxiliaryPreviewSizeValue? = nil,
    marginInner: CGFloat,
    marginOuter: CGFloat,
    transitionConfigEntrance: AuxiliaryPreviewEntranceTransitionConfig,
    transitionExitPreset: AuxiliaryPreviewTransitionPreset
  ) {
  
    self.verticalAnchorPosition = verticalAnchorPosition;
    self.alignmentHorizontal = alignmentHorizontal;
    self.preferredWidth = preferredWidth;
    self.height = height;
    self.marginInner = marginInner;
    self.marginOuter = marginOuter;
    self.transitionConfigEntrance = transitionConfigEntrance;
    
    self.transitionConfigExit = .init(transitionPreset: transitionExitPreset);
  };
};
