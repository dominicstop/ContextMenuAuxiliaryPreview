//
//  AuxiliaryPreviewPresets.swift
//  ContextMenuAuxiliaryPreviewExample
//
//  Created by Dominic Go on 11/15/23.
//

import UIKit
import ContextMenuAuxiliaryPreview

private let DEFAULT_DELAY: TimeInterval = 0.325;

struct AuxiliaryPreviewPresets {

  typealias PresetItem = (
    config: AuxiliaryPreviewConfig,
    dataEntries: [DebugDataCardViewController.DataEntry]
  );

  var presets: [PresetItem] = [(
    config: AuxiliaryPreviewConfig(
      verticalAnchorPosition: .automatic,
      alignmentHorizontal: .targetLeading,
      preferredWidth: .constant(100),
      preferredHeight: .constant(100),
      marginInner: 10,
      marginOuter: 10,
      transitionConfigEntrance: .syncedToMenuEntranceTransition(),
      transitionExitPreset: .fade
    ),
    dataEntries: []
  ), (
    config: AuxiliaryPreviewConfig(
      verticalAnchorPosition: .automatic,
      alignmentHorizontal: .targetCenter,
      preferredWidth: .constant(150),
      preferredHeight: .constant(100),
      marginInner: 12,
      marginOuter: 10,
      transitionConfigEntrance: .syncedToMenuEntranceTransition(
        shouldAnimateSize: true
      ),
      transitionExitPreset: .fade
    ),
    dataEntries: []
  ),    (
    config: AuxiliaryPreviewConfig(
      verticalAnchorPosition: .automatic,
      alignmentHorizontal: .targetTrailing,
      preferredWidth: .constant(100),
      preferredHeight: .constant(125),
      marginInner: 10,
      marginOuter: 10,
      transitionConfigEntrance: .afterMenuEntranceTransition(
        AuxiliaryPreviewTransitionAnimationConfig(
          delay: 0,
          animatorConfig: .presetCurve(
            duration: 0.3,
            curve: .linear
          ),
          transitionPreset: .fade
        )
      ),
      transitionExitPreset: .fade
    ),
    dataEntries: []
  ), (
    config: AuxiliaryPreviewConfig(
      verticalAnchorPosition: .automatic,
      alignmentHorizontal: .targetCenter,
      preferredWidth: .constant(100),
      preferredHeight: .constant(100),
      marginInner: 10,
      marginOuter: 10,
      transitionConfigEntrance: .afterMenuEntranceTransition(
        AuxiliaryPreviewTransitionAnimationConfig(
          delay: 0,
          animatorConfig: .presetCurve(
            duration: 0.3,
            curve: .linear
          ),
          transitionPreset: .fade
        )
      ),
      transitionExitPreset: .fade
    ),
    dataEntries: []
  ), (
    config: AuxiliaryPreviewConfig(
      verticalAnchorPosition: .automatic,
      alignmentHorizontal: .stretchTarget,
      preferredHeight: .constant(90),
      marginInner: 10,
      marginOuter: 10,
      transitionConfigEntrance: .customDelay(
        AuxiliaryPreviewTransitionAnimationConfig(
          delay: DEFAULT_DELAY,
          animatorConfig: .presetCurve(
            duration: 0.3,
            curve: .easeIn
          ),
          transitionPreset: .slide()
        )
      ),
      transitionExitPreset: .slide()
    ),
    dataEntries: []
  ), (
    config: AuxiliaryPreviewConfig(
      verticalAnchorPosition: .automatic,
      alignmentHorizontal: .targetCenter,
      preferredWidth: .constant(120),
      preferredHeight: .constant(80),
      marginInner: 10,
      marginOuter: 10,
      transitionConfigEntrance: .customDelay(
        AuxiliaryPreviewTransitionAnimationConfig(
          delay: DEFAULT_DELAY,
          animatorConfig: .presetCurve(
            duration: 0.3,
            curve: .easeIn
          ),
          transitionPreset: .zoom()
        )
      ),
      transitionExitPreset: .zoom()
    ),
    dataEntries: []
  ), (
    config: AuxiliaryPreviewConfig(
      verticalAnchorPosition: .automatic,
      alignmentHorizontal: .targetTrailing,
      preferredWidth: .constant(150),
      preferredHeight: .constant(100),
      marginInner: 10,
      marginOuter: 10,
      transitionConfigEntrance: .customDelay(
        AuxiliaryPreviewTransitionAnimationConfig(
          delay: DEFAULT_DELAY,
          animatorConfig: .presetCurve(
            duration: 0.3,
            curve: .easeIn
          ),
          transitionPreset: .zoomAndSlide()
        )
      ),
      transitionExitPreset: .zoomAndSlide()
    ),
    dataEntries: []
  ), (
    config: AuxiliaryPreviewConfig(
      verticalAnchorPosition: .automatic,
      alignmentHorizontal: .targetLeading,
      preferredWidth: .constant(125),
      preferredHeight: .constant(75),
      marginInner: 15,
      marginOuter: 10,
      transitionConfigEntrance: .customDelay(
        AuxiliaryPreviewTransitionAnimationConfig(
          delay: DEFAULT_DELAY,
          animatorConfig: .presetCurve(
            duration: 0.3,
            curve: .easeOut
          ),
          transitionPreset: .custom(
            keyframeStart: .init(
              opacity: 0,
              transform: .init(
                translateX: -40,
                translateY: 7,
                scaleX: 0.90,
                scaleY: 0.95
              ),
              auxiliaryPreviewPreferredWidth: .constant(20)
            )
          )
        )
      ),
      transitionExitPreset: .fade
    ),
    dataEntries: [
      .body("Custom entrance transition keyframe"),
      .body("height/width, transform, opacity")
    ]
  )];
  
  var presetCounter = 0;
  
  var currentPresetIndex: Int {
    self.presetCounter % self.presets.count;
  };
  
  var currentPreset: PresetItem {
    self.presets[self.currentPresetIndex];
  };
  
  var currentAuxiliaryPreviewConfig: AuxiliaryPreviewConfig {
    self.currentPreset.config;
  };
  
  var currentDataEntries: [DebugDataCardViewController.DataEntry] {
    var baseEntries: [DebugDataCardViewController.DataEntry] = [];
    
    let currentConfig = self.currentPreset.config;
    
    baseEntries.append(
      .labelDesc(
        label: "presetCounter",
        desc: "\(presetCounter)"
      )
    );
    
    baseEntries.append(
      .labelDesc(
        label: "currentPresetIndex",
        desc: "\(currentPresetIndex)"
      )
    );
    
    baseEntries.append(
      .spacing(size: 10)
    );
    
    baseEntries.append(
      .title("AuxiliaryPreviewConfig")
    );
    
    baseEntries.append(
      .labelDesc(
        label: "verticalAnchorPosition",
        desc: currentConfig.verticalAnchorPosition.rawValue
      )
    );
    
    baseEntries.append(
      .labelDesc(
        label: "alignmentHorizontal",
        desc: currentConfig.alignmentHorizontal.rawValue
      )
    );
    
    if let preferredWidth = currentConfig.preferredWidth {
      baseEntries.append(
        .labelDesc(
          label: "preferredWidth",
          desc: "\(preferredWidth)"
        )
      );
    };
    
    if let preferredHeight = currentConfig.preferredHeight {
      baseEntries.append(
        .labelDesc(
          label: "preferredHeight",
          desc: "\(preferredHeight)"
        )
      );
    };
    
    baseEntries.append(
      .labelDesc(
        label: "marginInner",
        desc: "\(currentConfig.marginInner)"
      )
    );
    
    baseEntries.append(
      .labelDesc(
        label: "marginOuter",
        desc: "\(currentConfig.marginOuter)"
      )
    );
    
    baseEntries.append(
      .spacing(size: 10)
    );
    
    baseEntries.append(
      .labelDesc(
        label: "Entrance Transition Config",
        desc: ""
      )
    );
    
    baseEntries.append(
      .labelDesc(
        label: "Config",
        desc: currentConfig.transitionConfigEntrance.description
      )
    );
    
    if case let .syncedToMenuEntranceTransition(shouldAnimateSize) = currentConfig.transitionConfigEntrance {
      baseEntries.append(
        .labelDesc(
          label: "shouldAnimateSize",
          desc: shouldAnimateSize.description
        )
      );
    };
    
    if let transitionAnimationConfig = currentConfig.transitionConfigEntrance.transitionAnimationConfig {
      baseEntries.append(
        .labelDesc(
          label: "delay",
          desc: transitionAnimationConfig.delay.description
        )
      );
      
      baseEntries.append(
        .labelDesc(
          label: "animatorConfig",
          desc: transitionAnimationConfig.animatorConfig.description
        )
      );
      
      baseEntries.append(
        .labelDesc(
          label: "animatorConfig - duration",
          desc: {
            let animator = transitionAnimationConfig.animatorConfig.createAnimator(
              gestureInitialVelocity: .zero
            );
            
            return "\(animator.duration)";
          }()
        )
      );
      
      baseEntries.append(
        .labelDesc(
          label: "transitionPreset",
          desc: transitionAnimationConfig.transitionPreset.description
        )
      );
    };
    
    baseEntries.append(
      .spacing(size: 10)
    );
    
    baseEntries.append(
      .labelDesc(
        label: "Exit Transition Config",
        desc: ""
      )
    );
    
    baseEntries.append(
      .labelDesc(
        label: "Config",
        desc: currentConfig.transitionExitPreset.description
      )
    );
    
    let presetEntries = self.currentPreset.dataEntries;
    
    if presetEntries.count > 0 {
      baseEntries.append(
        .spacing(size: 10)
      );
      
      baseEntries += presetEntries;
    };
    
    return baseEntries;
  };
  
  mutating func nextPreset(){
    self.presetCounter += 1;
  };
};
