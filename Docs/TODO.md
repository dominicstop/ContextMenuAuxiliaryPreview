# TODO - ContextMenuAuxiliaryPreview

<br>

## WIP - Current

- [ ] `TODO:2023-11-14-06-08-12` - Impl: Aux. Preview Popover - Use `AuxiliaryPreviewConfig.transitionConfigExit` for the modal exit transition.
- [ ] `TODO:2023-11-13-11-07-59` - Impl: Aux. Preview Menu - Impl. exit transition config + logic for aux. preview.
- [ ] `TODO:2023-11-09-15-38-40` - Impl: Aux. Preview Popover - `backgroundTapInteraction` - Defines what happens when the bg dimming view is tapped (e.g. close aux. preview modal).
- [ ] `TODO:2023-11-09-15-40-11` - Impl: Aux. Preview Popover - Update target view position on layout change.
- [ ] `TODO:2023-11-10-12-36-58` - Refactor: Aux. Preview Keyframes - Add default start/end keyframes for entrance/exit Keyframes.
- [ ] `TODO:2023-11-10-12-37-33` - Refactor: Aux. Preview Keyframes - Automatically set values for the start/end keyframes based on the aux. preview config.
- [ ] `TODO:2023-11-09-15-49-09` - Refactor: Aux. Preview Popover - Move computed height/width of aux. preview to keyframe (i.e. `AuxiliaryPreviewTransitionKeyframe`).
- [ ] `TODO:2023-11-10-12-24-03` - Impl: `ContextMenuManaer.presentContextMenu` - Add helper function that calls `ContextMenuInteractionWrapper.presentMenuAtLocation`. 
- [ ] `TODO:2023-10-22-09-09-34` - Impl: Examples - Add VC for testing the different possible combinations of aux. preview config.
- [ ] `TODO:2023-11-10-12-39-29` - Impl: Aux. Preview Popover + ScrollView - Impl. logic for scrolling the target view into view before the aux. preview modal is presented, e.g. `minDistanceFromEdges`.
- [ ] `TODO:2023-11-10-12-51-51 ` - Aux. Preview Popover: Impl. separate config for "Aux. Preview Popover" - Derive the base config from "Context Menu Aux. Preview", and implicitly override base values w/ the new ones.
- [ ] `TODO:2023-11-10-12-57-44` - Impl: Aux. Preview Keyframes + Aux. Preview Popover - Add support for setting the background dimming color + opacity.
- [ ] `TODO:2023-11-10-12-58-00` - Impl: Aux. Preview Keyframes + Aux. Preview Popover - Add support for background blur.
- [ ] `TODO:2023-11-13-13-50-14` Impl: Aux. Preview Manager - Impl. `AuxiliaryPreviewMenuManager` event delegate for notifying when the aux. preview is shown or hidden. 

<br><br>

## WIP - Queue

- [ ] `TODO:2023-11-10-12-17-26` - Bug: Aux. Preview - Fix aux. preview not receiving touch events when it's at the very bottom of the screen.
  * This is likely caused by nudging the context menu container view.

<br>

- [ ] `TODO:2023-11-09-00-59-48` - Impl: `ContextMenuInteractionDelegateInterceptor` - Intercept `UIContextMenuInteractionDelegate` calls from `UIButton`.
- [ ] `TODO:2023-11-09-01-01-04` - Impl: Add support for attaching an aux. preview. to a `UIButton` w/ a context menu.
  * Related to: `TODO:2023-11-09-00-59-48`

<br>

- [ ] `TODO:2023-10-23-07-55-46` - Impl: Attach aux. preview to a deeper subview in the context menu preview (i.e. the parent of the context menu preview).

<br>

- [ ] `TODO:2023-10-22-08-25-16` - Refactor: Re-write aux. preview + hit test swizzling logic.

<br><br>

## Completed

- [x] `TODO:2023-11-10-12-25-26` - Bug: Aux. Preview Popover - Fix: Cannot show aux. preview again after it has been prev. presented.
- [x] `TODO:2023-11-10-12-24-16` - Bug: Context Menu Aux. Preview - Fix the entrance transition not working properly when the aux. preview is located at the top half of the screen.
- [x] `TODO:2023-11-10-12-59-55` - Refactor: Aux. Preview Popover - Cleanup + separate out logic for attaching the aux. preview + entrance/exit transitions.
- [x] `TODO:2023-11-10-07-11-39` - Refactor: Extract common/duplicated code - Code sharing/re-use between `AuxiliaryPreviewMenuManager` and `AuxiliaryPreviewModalManager`.
- [x] `TODO:2023-11-08-14-01-55` - Impl: Aux. Preview Popover - `AuxiliaryPreviewModalManager` - Manager used to show/attach the auxiliary preview on the target view.
  * Ideally, we would have a function like an `showAuxiliaryPreview` where it would use the existing auxiliary preview config to show the aux. preview.

<br>

- [x] `TODO:2023-10-23-02-55-23` - Impl: Adjust transform based on the position of the menu.
  * Transforms that should be adjusted: translate, rotation.
  * Positive values means away from the preview, and negative values means towards the menu.

<br>

- [x]  `TODO:2023-10-29-08-15-08` - Impl: Transition Config - Add support for `3DTransform` keyframes.
- [x] `TODO:2023-11-08-14-13-46` - Refactor: Extract `AuxiliaryPreviewEntranceTransitionConfig` associated enum values to its own type called: `AuxiliaryPreviewTransitionAnimationConfig`.

<br>

- [x] `TODO:2023-10-23-06-15-16` - Impl: Transition Config - Support both legacy entrance transition config + new config via adding a "transition mode" option.
  * This mode defines when and how to attach + transition the aux. preview.
  * This can be defined as an enum, e.g.: `follow` (or: `synced`, `together`, `syncedToEntranceTransition`), `customDelay`, `afterTransition` (or: `onTransitionEnd`, `onEntranceTransitionEnd`).
  * Modes that support a custom transition configuration: `customDelay`, `onEntranceTransitionEnd`.
  * Mode: `syncedToEntranceTransition` - The entrance transition for the aux. preview is synced to the context menu.
  * Mode: `customDelay` - Wait for the specified amount of seconds before attaching and starting the context menu transition.
    * Use `CADisplayLink` to check on each frame if the context menu preview has been attached to the window.
  * Mode: `onEntranceTransitionEnd` - Wait for the context menu transition to end before attaching the aux. preview.

<br>

- [x] `TODO:2023-10-25-04-11-29` - Refactor: Aux. Preview Config - Re-write how the aux. preview anchor + size is set and applied.
- [x] `TODO:2023-10-21-06-11-22` - Refactor: Initial re-write for menu aux. preview entrance.
  * Transition config should accept keyframes for the initial position, and final position.
  * The keyframes are then used to animate the aux. preview.
  * Keyframe values to support: `Transform3D`, alpha.
  * For the initial re-write, the only keyframe to be implemented is alpha.

<br>

- [x] `TODO:2023-10-24-21-05-23` - Package: Add dependency to `DGSwiftUtilities`, and replace redundant/duplicated code + usage w/  `DGSwiftUtilities`. 
- [x] `TODO:2023-10-22-09-06-33` - Impl: Event delegate - aux. preview related events.
- [x] `TODO:2023-10-21-20-22-12` - Refactor: Re-write logic for attaching the aux. preview.