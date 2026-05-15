# Motion Tuning Cheatsheet

Use these as starting points, not universal constants. Tune against the actual distance, density, brand personality, device refresh rate, and input velocity.

## Interaction Categories

| Interaction | Starting point | Notes |
| --- | --- | --- |
| Button press | 80-140 ms, ease-out down, spring back | Keep travel tiny; never delay the action unnecessarily. |
| Toggle or chip selection | 140-220 ms, ease-in-out or light spring | The selected state should be readable at rest. |
| Sheet/card settle | 320-520 ms spring | Use gesture velocity; avoid long tails after a flick. |
| Navigation push/pop | Follow platform defaults unless custom transition is essential | Users are sensitive to navigation weirdness. |
| Success celebration | 600-1400 ms asset or keyframes | Do not block the task flow unless celebration is the product moment. |
| Loading loop | Prefer subtle loop, pause offscreen | Avoid looping motion that competes with content. |
| Error shake | 240-420 ms keyframe | Keep amplitude small and accessible. |

## Symptom To Fix

- Feels sluggish: reduce delay, shorten duration, start feedback on touch down, preload assets.
- Feels abrupt: add ease-out or spring settle, reduce distance, avoid linear timing.
- Feels floaty: increase damping, shorten duration, reduce overshoot, tie motion to gesture velocity.
- Feels heavy: increase initial response, reduce mass-like distance, lighten shadow/blur work.
- Jumps on interrupt: start from presentation value or paused animator progress.
- Snaps after gesture: final model/layout state does not match visible state.
- Stutters on first play: decode/preload/caching issue is likely.
- Drifts out of sync: duplicate state exists between product model and animation runtime.

## Spring Guidance

- Use higher damping for utility UI and lower damping for playful moments.
- Preserve user velocity when ending pan gestures.
- Avoid bounce when the animation communicates completion of a serious or destructive action.
- Prefer physically plausible travel. Large overshoot on small controls often feels cheap.

## Curve Guidance

- Ease-out: immediate response that settles naturally.
- Ease-in-out: contained state transitions that do not track touch.
- Linear: progress indicators or scrubbed segments, rarely direct UI motion.
- Custom cubic: use when matching brand motion or existing design system curves.

## Accessibility

- Respect Reduce Motion for parallax, zoom, large spatial movement, infinite decorative loops, and vestibularly intense effects.
- Replace removed motion with opacity, color, scale under a smaller range, or instant state changes.
- Do not use animation as the only signal for success, error, focus, or selection.
