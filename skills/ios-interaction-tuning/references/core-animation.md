# Core Animation

Use Core Animation when the motion belongs to layers, not to layout. It is strongest for transforms, opacity, paths, masks, gradients, replicated layers, shape layers, and visual effects that should avoid repeated view layout.

## Mental Model

- The model layer stores target values.
- The presentation layer exposes in-flight values currently visible on screen.
- The render tree is private to Core Animation.
- Core Animation is a compositing and animation system, not a general drawing loop.

Use the presentation layer to start a new animation from the current visible state. Never mutate the presentation layer.

## Explicit Animation Pattern

```swift
func animatePulse(on layer: CALayer) {
    let animation = CASpringAnimation(keyPath: "transform.scale")
    animation.fromValue = layer.presentation()?.value(forKeyPath: "transform.scale") ?? 0.96
    animation.toValue = 1.0
    animation.damping = 18
    animation.stiffness = 240
    animation.mass = 1
    animation.initialVelocity = 0
    animation.duration = animation.settlingDuration

    layer.transform = CATransform3DIdentity
    layer.add(animation, forKey: "pulse.scale")
}
```

The model value must be set to the final value. Avoid relying on `fillMode` plus `isRemovedOnCompletion = false` as the persistent state; that often leaves the model and visible state out of sync.

## Disable Implicit Animations

Use transactions when a layer property change is a state update rather than visible motion:

```swift
CATransaction.begin()
CATransaction.setDisableActions(true)
shapeLayer.path = newPath
shapeLayer.position = newPosition
CATransaction.commit()
```

## Good Uses

- Animating `position`, `bounds`, `transform`, `opacity`, `cornerRadius`, `path`, `strokeEnd`, `backgroundColor`, and gradient locations.
- Reusing a `CAShapeLayer` instead of redrawing complex paths in a view every frame.
- Matching a new explicit animation to the current presentation value during retargeting.
- Isolating purely decorative visual motion from Auto Layout.

## Risky Uses

- Animating layer frame while Auto Layout owns the view geometry.
- Animating properties that force expensive offscreen rendering without profiling.
- Creating many animations or layers inside scrolling cell reuse without cleanup.
- Using masks, shadows, blurs, and rasterization as permanent fixes without measuring.
- Driving frame-by-frame artwork by swapping layer contents from the main thread.

## Review Checklist

- Does the model layer match the intended final state?
- Are implicit animations disabled for non-animated setup?
- Are animations keyed so they can be replaced or removed intentionally?
- Are delegates weakly or safely managed?
- Does cell reuse remove stale animations and reset layer state?
- Does the animation survive backgrounding, view disappearance, and repeated triggers?
