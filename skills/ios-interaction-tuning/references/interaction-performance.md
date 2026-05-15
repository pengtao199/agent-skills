# Interaction Performance

Do not declare an interaction fixed from code inspection alone when the complaint is jank, hitches, overheating, scroll drops, or first-play stutter. Request or capture evidence when possible.

## Target Budgets

- At 60 Hz, each frame has about 16.67 ms.
- At 120 Hz, each frame has about 8.33 ms.
- Touch feedback should start as soon as possible, ideally by the next frame.
- Main-thread work during gestures, scroll, and transitions should be tiny and predictable.

## Profiling Sequence

1. Reproduce the exact interaction in a Release build when possible.
2. Record with Instruments using the most relevant template: Time Profiler, Core Animation, SwiftUI, Hangs/Hitches, Allocations, or Energy.
3. Mark the interaction window: start gesture, update/scrub, release, settle, repeat.
4. Inspect the main thread, render server/GPU indicators, layout passes, image decoding, and allocation spikes.
5. Change one suspected cause and profile again.

## Common Sources Of Hitches

- Synchronous image or vector decoding at first playback.
- Auto Layout work during every gesture update.
- Rebuilding SwiftUI view identity during animation.
- Heavy shadow, blur, mask, or corner-radius composition without measurement.
- Creating animation views, layers, display links, or decoders inside scroll cell reuse.
- Running several Lottie or Rive animations at once.
- Completion handlers starting more work exactly when the transition settles.
- Logging, analytics, network callbacks, or persistence on the main thread during visible motion.

## Code Review Search Patterns

Search with `rg`:

```bash
rg "UIView\\.animate|UIViewPropertyAnimator|withAnimation|\\.animation\\("
rg "CABasicAnimation|CAKeyframeAnimation|CASpringAnimation|CADisplayLink|CATransaction"
rg "layoutIfNeeded\\(|setNeedsLayout\\(|setNeedsDisplay\\("
rg "LottieAnimationView|AnimationView|RiveView|RiveViewModel"
rg "DispatchQueue\\.main\\.sync|Data\\(contentsOf:|UIImage\\(contentsOfFile:"
```

## Fix Patterns

- Preload assets before first visible interaction.
- Cache parsed animation assets separately from view instances when the runtime supports it.
- Move state mapping outside per-frame gesture callbacks.
- Replace constraint mutation during high-frequency updates with transforms when layout does not need to change.
- Defer analytics, persistence, and network work until after the visible transition.
- Remove stale animations and reset layer/view state during reuse.
- Use simpler motion under Reduce Motion and on older devices when appropriate.

## Evidence To Ask The User For

- Device model, iOS version, simulator versus physical device.
- Screen recording with slow motion if the issue is visual.
- Instruments trace or screenshots around the hitch.
- The exact file and function that owns the interaction.
- Asset sizes and whether the animation uses external images.
- How many animated instances can be visible at once.
