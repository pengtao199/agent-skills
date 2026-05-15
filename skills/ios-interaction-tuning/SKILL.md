---
name: ios-interaction-tuning
description: Tune and review Swift iOS interaction motion, UIKit and SwiftUI animation feel, Core Animation layers, UIViewPropertyAnimator gesture-driven transitions, Lottie iOS playback, and Rive Apple runtime integrations. Use when the user mentions janky animation, interaction polish, drag-to-dismiss, interruptible animation, spring tuning, frame hitches, Core Animation, UIViewPropertyAnimator, CALayer, CAAnimation, Lottie, Rive, .json/.lottie/.riv assets, or asks to make an iOS interaction feel smoother, faster, more native, or more responsive.
---

# iOS Interaction Tuning

## Overview

Use this skill to improve the feel and runtime behavior of iOS interactions, not just to add visual motion. Treat every animation as part of an input loop: what starts it, whether it tracks touch, how it cancels or reverses, how it hands off velocity, and whether it can sustain the target frame budget on real hardware.

Prefer native UIKit, SwiftUI, or Core Animation primitives for structural UI motion. Use Lottie and Rive when the motion is authored artwork or a designer-owned state machine, and keep those runtimes behind narrow wrappers so product state and animation state stay synchronized.

## Workflow

1. Identify the interaction contract.
   - Name the trigger: tap, pan, scroll, navigation, state change, loading, success, failure, empty state, onboarding, or game-like input.
   - Name the expected control model: fire-and-forget, reversible, interruptible, gesture-scrubbable, physics-following, or asset-driven.
   - Ask for a screen recording, target file, or specific repro path when the symptom is subjective or performance-related.

2. Choose the motion engine.
   - Use SwiftUI animation for SwiftUI state changes when identity is stable and the interaction is declarative.
   - Use `UIViewPropertyAnimator` for UIKit interactions that need pause, reverse, retarget, `fractionComplete`, or gesture velocity handoff. Read `references/uikit-property-animator.md`.
   - Use Core Animation for layer-level transforms, masks, paths, gradients, opacity, keyframes, or cases where view layout should not be invalidated. Read `references/core-animation.md`.
   - Use Lottie or Rive for authored animation assets and designer-owned motion. Read `references/lottie-rive-ios.md`.

3. Inspect the current implementation.
   - Search for animation entry points: `UIView.animate`, `UIViewPropertyAnimator`, `withAnimation`, `.animation(`, `CABasicAnimation`, `CAKeyframeAnimation`, `LottieAnimationView`, `AnimationView`, `RiveViewModel`, `RiveView`.
   - Find state ownership before editing. Animation state should derive from product state or gesture state, not from duplicated booleans scattered across views.
   - Check whether completion handlers, cancellation paths, and interaction disabling restore the UI to a coherent state.

4. Tune feel with observable parameters.
   - Start with distance, duration, damping, initial velocity, response, delay, and easing curve.
   - Preserve touch continuity: update progress from gesture translation, pause before scrubbing, and continue with the gesture's ending velocity.
   - Avoid animating layout-heavy changes every frame when a transform or layer property expresses the same motion.
   - Read `references/motion-tuning-cheatsheet.md` when choosing curves and springs.

5. Validate performance and accessibility.
   - Build and run the app when a project is available.
   - Profile real repro interactions when the complaint involves hitches, scrolling, launch, battery, memory, or repeated playback.
   - Check Reduce Motion behavior for decorative, parallax, looping, and large spatial transitions.
   - Read `references/interaction-performance.md` before giving final performance conclusions.

## Implementation Defaults

- Keep animation coordinators small and local to the interaction. Extract only when the same interaction appears in multiple screens or needs testable state mapping.
- Prefer a single source of truth for interaction progress: gesture progress, scroll progress, product state, or runtime state machine input.
- Make interruptible interactions explicit. A paused or cancelled interaction should have a predictable visual state and a clear next transition.
- Use transforms and opacity for high-frequency visual changes. Be cautious with constraints, text layout, shadows, blur, masks, and image decoding inside active gestures.
- Keep authored assets deterministic. Wrap Lottie/Rive behind app-specific APIs such as `playSuccess()`, `setProgress(_:)`, or `setIsSelected(_:)` instead of leaking runtime calls through feature code.
- Treat animation constants as design tokens only when they are shared intentionally. A modal dismissal spring, a button press feedback, and a celebratory success animation usually need different timing.

## Review Checklist

- Does the interaction respond within one frame of input when possible?
- Can it be interrupted, cancelled, reversed, or repeated without jumping?
- Does the implementation avoid duplicate state between gesture recognizers, view models, and animation runtimes?
- Are completions guarded against stale state when the view disappears or the transition is cancelled?
- Are heavy assets preloaded or cached before first visible playback?
- Is Reduce Motion respected for large, decorative, looping, or vestibularly intense motion?
- Is profiling evidence requested or captured before claiming a performance fix?

## Reference Map

- `references/uikit-property-animator.md`: UIKit gesture-driven and interruptible motion.
- `references/core-animation.md`: Layer-backed animation, model/presentation layers, and explicit animations.
- `references/lottie-rive-ios.md`: Authored animation runtime integration patterns.
- `references/interaction-performance.md`: Profiling, frame budgets, hitches, and rendering smells.
- `references/motion-tuning-cheatsheet.md`: Practical tuning defaults and symptom-to-fix mapping.

For version-sensitive Lottie, Rive, or newly released Apple APIs, consult the current official documentation before finalizing code.
