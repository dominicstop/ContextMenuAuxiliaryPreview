//
//  AuxiliaryPreviewTransitionAnimationConfig.swift
//  
//
//  Created by Dominic Go on 11/8/23.
//

import UIKit
import DGSwiftUtilities


public struct AuxiliaryPreviewTransitionAnimationConfig {

  public static var `default`: Self = .init(
    delay: .zero,
    animatorConfig: .presetCurve(duration: 0.3, curve: .linear),
    transitionType: .fade
  );

  public var delay: TimeInterval;
  public var animatorConfig: AnimationConfig;
  public var transition: AuxiliaryPreviewTransitionConfig;
  
  public init(
    delay: TimeInterval,
    animatorConfig: AnimationConfig,
    transitionType: AuxiliaryPreviewTransitionType
  ) {
  
    self.delay = delay
    self.animatorConfig = animatorConfig
    self.transition = .init(transitionType: transitionType);
  };
};
