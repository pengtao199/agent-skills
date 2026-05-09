# Official TopOn CocoaPods Demo Repo Notes

Updated: 2026-04-13 (Asia/Shanghai)

## Source

- Official repo: https://github.com/toponteam/TopOn-iOS-Pod-Demo

This reference is based on the official TopOn CocoaPods demo repository, especially the Swift demo and the `OCDemo_v6.5.xx` branch of examples.

## What the repo proves

### 1. Pod selection is intentionally partial

The official demo does not try to install every adapter. Its Podfiles explicitly say the demo only includes a reduced set of adapters and that real integrations should replace them with portal-selected adapters, then run:

```bash
pod install --repo-update
```

This is important for real projects:

- Do not treat the demo Podfile as a universal pod list.
- Use the TopOn portal output for the actual production pod set.
- Use the demo to understand structure and API flow only.

### 2. TopOn uses one SDK manager plus one file per ad format

In the Swift demo, the core split is:

- `AdSDKManager.swift`: SDK init, debug hooks, GDPR flow, top-most-VC helper
- `BannerVC.swift`: banner load/show lifecycle
- `InterstitialVC.swift`: interstitial load/show lifecycle
- `RewardedVC.swift`: rewarded load/show lifecycle and reward callbacks
- `NativeExpressVC.swift`: native template rendering flow
- `NativeSelfRenderVC.swift`: native self-rendering flow
- `SplashVC.swift`: splash timeout and display flow
- `SDKConfig/*`: optional config helpers

This is the main architectural lesson to copy into product code.

### 3. The demo separates required code from optional code

The demo marks many features as optional:

- scene reporting
- querying valid cache before show
- querying placement load status
- ad-platform-specific load extras
- test mode
- DebugUI
- custom global segmentation or filtering rules

For product integration, only keep the optional pieces the app truly needs.

### 4. EU flow is explicitly a different init path

The Swift demo provides:

- `initSDK()`: non-EU path
- `initSDK_EU(...)`: consent dialog first, then init

This reinforces the rule that consent gating is not a tiny add-on. It changes the initialization path itself.

### 5. The demo keeps placement IDs local to each ad-format implementation

The repo does not bury all placement IDs inside one giant manager. Instead:

- App credentials live in the SDK manager.
- Placement IDs live near the matching ad-format code.

That is a good default when building a reusable demo or integration module.

## High-value files to study

For Swift:

- `SwiftDemo/Podfile`
- `SwiftDemo/SwiftDemo/AdDemo/AdSDKManager.swift`
- `SwiftDemo/SwiftDemo/AdDemo/Banner/BannerVC.swift`
- `SwiftDemo/SwiftDemo/AdDemo/Interstitial/InterstitialVC.swift`
- `SwiftDemo/SwiftDemo/AdDemo/RewardVideo/RewardedVC.swift`
- `SwiftDemo/SwiftDemo/AdDemo/Native/NativeExpressVC.swift`
- `SwiftDemo/SwiftDemo/AdDemo/Splash/SplashVC.swift`
- `SwiftDemo/SwiftDemo/AdDemo/SDKConfig/SDKGlobalConfig/SDKGlobalConfigTool.swift`
- `SwiftDemo/SwiftDemo/AdDemo/SDKConfig/TestMode/TestModeTool.swift`

For Objective-C `v6.5.xx`:

- `OCDemo_v6.5.xx/Podfile`
- `OCDemo_v6.5.xx/iOSDemo/AppDelegate.m`
- corresponding files under `OCDemo_v6.5.xx/iOSDemo/AdDemo/`

## What to copy into a real project

Safe to copy conceptually:

- one SDK manager / init facade
- one file per ad format
- retry-on-load-failure pattern with a small cap
- preload-next-after-close pattern for rewarded/interstitial
- optional config helper buckets
- optional DebugUI and test-mode hooks behind debug-only gates

Do not copy blindly:

- hard-coded pod versions from the demo
- demo placement IDs
- demo App ID / App Key
- all optional config helpers
- every ad format if the app only needs a subset

## Best integration takeaway

Use the official demo as a code-shape reference:

- init and compliance flow in one place
- ad-format code self-contained
- pod/version selection owned by the TopOn portal
- optional features kept optional
