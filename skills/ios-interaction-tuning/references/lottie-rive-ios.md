# Lottie And Rive On iOS

Use Lottie and Rive for authored motion assets. Keep runtime integration thin and app-specific: product code should speak in domain actions, while the wrapper translates those actions to runtime playback, progress, markers, or state machine inputs.

## Lottie Defaults

Use Lottie when the asset is a timeline animation exported from After Effects or a Lottie-compatible pipeline.

Common integration shape:

```swift
final class SuccessAnimationView: UIView {
    private let animationView = LottieAnimationView(name: "success")

    override init(frame: CGRect) {
        super.init(frame: frame)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.backgroundBehavior = .pauseAndRestore
        addSubview(animationView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        animationView.frame = bounds
    }

    func play() {
        animationView.currentProgress = 0
        animationView.play()
    }
}
```

Check current Lottie iOS docs before finalizing API names because the public Swift API has changed across major versions.

### Lottie Review Points

- Preload or cache heavy animations before first visible playback.
- Avoid creating a new animation view every time a cell appears.
- Stop or pause looping animations when offscreen.
- Coordinate playback with app state; avoid letting completion handlers mutate stale screens.
- Use markers or progress ranges when designers provide named segments.
- Validate `.json`, `.lottie`, image assets, and bundle paths on device, not only previews.
- Respect Reduce Motion for decorative loops and large celebratory motion.

## Rive Defaults

Use Rive when the asset contains interactive state machines, inputs, or designer-authored runtime logic.

Common integration shape:

```swift
final class FavoriteRiveControl: UIView {
    private let model = RiveViewModel(fileName: "favorite", stateMachineName: "Button")
    private lazy var riveView = model.createRiveView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(riveView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        riveView.frame = bounds
    }

    func setSelected(_ isSelected: Bool) {
        model.setInput("isSelected", value: isSelected)
    }

    func press() {
        model.triggerInput("press")
    }
}
```

Check the current Rive Apple runtime docs before finalizing API names, especially when using new Swift-first or multithreaded runtime features.

### Rive Review Points

- Ask for the `.riv` file's artboard, state machine, input names, and intended state diagram.
- Keep input names centralized in the wrapper; do not scatter string literals through feature code.
- Map product state to state machine inputs idempotently.
- Test state transitions with rapid taps, cancellation, and view reuse.
- Avoid running multiple heavy Rive files onscreen without profiling.
- Validate transparent backgrounds, fit/alignment, and offscreen lifecycle on device.

## Asset Runtime Smells

- The animation asset is used to hide slow app state changes instead of reflecting them.
- Runtime calls are spread through controllers, cells, and view models.
- The feature has no behavior when the asset fails to load.
- Loops continue in background tabs, offscreen cells, or hidden views.
- Designers and engineers disagree about state machine input names or marker names.
- A simple transform or opacity animation was implemented as a large asset.
