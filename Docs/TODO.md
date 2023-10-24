# TODO - ContextMenuAuxiliaryPreview

<br>

## WIP

- [ ] `TODO:2023-10-23-07-55-46` - Impl: Attach aux. preview to a deeper subview in the context menu preview (i.e. the parent of the context menu preview).

<br>

- [ ] `TODO:2023-10-23-06-15-16` - Impl: Transition Config - Support both legacy entrance transition config + new config via adding a "transition mode" option.
  * This mode defines when and how to attach + transition the aux. preview.
  * This can be defined as an enum, e.g.: `follow` (or: `synced`, `together`, `syncedToEntranceTransition`), `customDelay`, `afterTransition` (or: `onTransitionEnd`, `onEntranceTransitionEnd`).
  * Modes that support a custom transition configuration: `customDelay`, `onEntranceTransitionEnd`.
  * Mode: `syncedToEntranceTransition` - The entrance transition for the aux. preview is synced to the context menu.
  * Mode: `customDelay` - Wait for the specified amount of seconds before attaching and starting the context menu transition.
    * Use `CADisplayLink` to check on each frame if the context menu preview has been attached to the window.
  * Mode: `onEntranceTransitionEnd` - Wait for the context menu transition to end before attaching the aux. preview.

<br>

- [ ] `TODO:2023-10-23-02-55-23` - Impl: Adjust transform based on the position of the menu, i.e. `shouldAutoOrientTransformToContextMenuPosition`.
  * Transforms that should be adjusted: translate, rotation.
  * Positive values means away from the preview, and negative values means towards the menu.

<br>

- [ ] `TODO:2023-10-22-09-09-34` - Add: Examples - Add VC for testing the different possible combinations of aux. preview config.
- [ ] `TODO:2023-10-22-08-25-16` - Refactor: Re-write aux. preview + hit test swizzling logic.
- [ ] `TODO:2023-10-21-06-11-22` - Refactor: Initial re-write for menu aux. preview entrance.
  * Transition config should accept keyframes for the initial position, and final position.
  * The keyframes are then used to animate the aux. preview.
  * Keyframe values to support: `Transform3D`, alpha.
  * For the initial re-write, the only keyframe to be implemented is alpha.

<br><br>

## Completed

- [x] `TODO:2023-10-24-21-05-23` - Package: Add dependency to `DGSwiftUtilities`, and replace redundant/duplicated code + usage w/  `DGSwiftUtilities`. 
- [x] `TODO:2023-10-22-09-06-33` - Impl: Event delegate - aux. preview related events.
- [x] `TODO:2023-10-21-20-22-12` - Refactor: Re-write logic for attaching the aux. preview.