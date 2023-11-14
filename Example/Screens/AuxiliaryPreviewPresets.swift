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
      transitionConfigEntrance: .syncedToMenuEntranceTransition,
      transitionExitPreset: .fade
    ),
    dataEntries: [
      .labelDesc(
        label: "Entrance Type",
        desc: "syncedToMenuEntranceTransition"
      )
    ]
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
    self.currentPreset.dataEntries;
  };
  
  mutating func nextPreset(){
    self.presetCounter += 1;
  };
};
