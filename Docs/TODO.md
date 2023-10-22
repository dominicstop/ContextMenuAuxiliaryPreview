# TODO - ContextMenuAuxiliaryPreview

<br>

## WIP

- [ ] `TODO:2023-10-23-02-55-23` - Impl: Adjust transform based on the position of the menu, i.e. `shouldAutoOrientTransformToContextMenuPosition`.
  * Transforms that should be adjusted: translate, rotation.
  * Positive values means away from the preview, and negative values means towards the menu.

<br>

- [ ] `TODO:2023-10-22-09-09-34` - Add: Examples - Add VC for testing the different possible combinations of aux. preview config.
- [ ] `TODO:2023-10-22-08-25-16` - Refactor: Re-write aux. preview + hit test swizzling logic.
- [ ] `TODO:2023-10-21-06-11-22` - Refactor: Re-write menu aux. preview entrance/exit transition logic + config.
  * Transition config should accept keyframes for the initial position, and final position.
  * The keyframes are then used to animate the aux. preview.
  * Keyframe values to support: `Transform3D`, alpha.

<br><br>

## Completed

- [x] `TODO:2023-10-22-09-06-33` - Impl: Event delegate - aux. preview related events.
- [x] `TODO:2023-10-21-20-22-12` - Refactor: Re-write logic for attaching the aux. preview.