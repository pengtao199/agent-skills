# UIKit Property Animator

Use `UIViewPropertyAnimator` when UIKit motion must be interruptible, scrubbable, reversible, or retargeted after it starts.

## Choose It For

- Pan-driven sheet, drawer, card, carousel, scrubber, reveal, or dismissal interactions.
- Transitions that must pause on touch down and resume on release.
- Animations that need `fractionComplete`, `isReversed`, `pauseAnimation()`, `continueAnimation(withTimingParameters:durationFactor:)`, or gesture velocity handoff.
- Cases where `UIView.animate` completion blocks cause jumps because a second interaction starts before the first finishes.

## Core Pattern

```swift
final class CardDismissInteraction {
    private var animator: UIViewPropertyAnimator?
    private var startProgress: CGFloat = 0

    func begin(card: UIView) {
        let animator = UIViewPropertyAnimator(duration: 0.45, dampingRatio: 0.86) {
            card.transform = CGAffineTransform(translationX: 0, y: card.bounds.height)
            card.alpha = 0
        }
        animator.pausesOnCompletion = true
        animator.startAnimation()
        animator.pauseAnimation()
        self.animator = animator
        self.startProgress = animator.fractionComplete
    }

    func update(translationY: CGFloat, travel: CGFloat) {
        let progress = max(0, min(1, startProgress + translationY / max(travel, 1)))
        animator?.fractionComplete = progress
    }

    func end(velocityY: CGFloat, shouldFinish: Bool) {
        guard let animator else { return }
        animator.isReversed = !shouldFinish
        let timing = UISpringTimingParameters(dampingRatio: shouldFinish ? 0.88 : 0.92)
        let remaining = max(0.05, shouldFinish ? 1 - animator.fractionComplete : animator.fractionComplete)
        animator.continueAnimation(withTimingParameters: timing, durationFactor: remaining)
        self.animator = nil
    }
}
```

Adapt this pattern to local conventions. Do not copy it blindly when navigation controllers, custom presentation controllers, or collection view transitions already own the interaction.

## Tuning Rules

- Normalize gesture distance to a stable travel distance. Avoid using changing layout values during the same gesture.
- Pause before setting `fractionComplete`; changing progress on a running animator often produces surprises.
- Decide completion from both progress and velocity. A quick flick should finish even if progress is low.
- For retargeting, continue a paused animator with new timing parameters instead of creating a second overlapping animator.
- Use `durationFactor` as remaining-duration scaling, not as a new absolute duration.
- Keep animator ownership tied to the interaction lifetime. Clear references after completion or cancellation.

## Common Bugs

- Jump at gesture start: the animator was created after the view already moved, or `startProgress` was not captured.
- Snap on release: final layout/model state does not match the visual end state.
- Cannot continue: the animator is inactive, still running, or not interruptible.
- Completion fires after the screen disappears: completion does not validate the current view state.
- Layout fights transforms: constraints are mutated while transform-based gesture motion is active.

## Review Questions

- What is the source of progress?
- What decides finish versus cancel?
- What happens if a second gesture starts before completion?
- Are final constraints, transforms, alpha, and interaction-enabled states restored consistently?
- Does the interaction still work with Reduce Motion or when the app resigns active?
