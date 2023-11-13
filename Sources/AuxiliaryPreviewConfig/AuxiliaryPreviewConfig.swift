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
  
  public var preferredWidth: AuxiliaryPreviewSizeValue?;
  public var preferredHeight: AuxiliaryPreviewSizeValue?;
  
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
    preferredWidth: AuxiliaryPreviewSizeValue? = nil,
    preferredHeight: AuxiliaryPreviewSizeValue? = nil,
    marginInner: CGFloat,
    marginOuter: CGFloat,
    transitionConfigEntrance: AuxiliaryPreviewEntranceTransitionConfig,
    transitionConfigExit: AuxiliaryPreviewTransitionConfig
  ) {
  
    self.verticalAnchorPosition = verticalAnchorPosition;
    self.alignmentHorizontal = alignmentHorizontal;
    self.preferredWidth = preferredWidth;
    self.preferredHeight = preferredHeight;
    self.marginInner = marginInner;
    self.marginOuter = marginOuter;
    self.transitionConfigEntrance = transitionConfigEntrance;
    self.transitionConfigExit = transitionConfigExit;
  };
};
