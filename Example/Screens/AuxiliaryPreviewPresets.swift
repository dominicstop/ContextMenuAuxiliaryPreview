//
//  AuxiliaryPreviewPresets.swift
//  ContextMenuAuxiliaryPreviewExample
//
//  Created by Dominic Go on 11/15/23.
//

import UIKit
import ContextMenuAuxiliaryPreview

struct AuxiliaryPreviewPresets {

  typealias PresetItem = (
    config: AuxiliaryPreviewConfig,
    dataEntries: [DebugDataCardViewController.DataEntry]
  );

  var presets: [PresetItem] = [(
    config: AuxiliaryPreviewConfig(
      verticalAnchorPosition: .automatic,
      alignmentHorizontal: .targetCenter,
      preferredWidth: .constant(100),
      preferredHeight: .constant(100),
      marginInner: 10,
      marginOuter: 10,
      transitionConfigEntrance: .syncedToMenuEntranceTransition(),
      transitionExitPreset: .fade
    ),
    dataEntries: []
  ),];
  
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
