# Swift Demo Blueprint For Reusable TopOn Integrations

Updated: 2026-04-13 (Asia/Shanghai)

This blueprint distills the official TopOn Swift demo into a reusable pattern for app integrations and future demo extraction.

## Recommended split

### 1. SDK manager

Create one focused init facade, for example:

- `TopOnSDKManager`

Its responsibilities:

- hold App ID and App Key lookup
- initialize TopOn
- optionally run GDPR / UMP path first
- enable debug logs in debug builds
- optionally expose DebugUI helpers
- provide top-most-view-controller helpers if needed by consent or show flow

Its non-responsibilities:

- placement-specific load/show logic
- feature business rules
- product-specific reward accounting

### 2. Config layer

Create one small config area, for example:

- `TopOnConfig.swift`

Keep here:

- App ID
- App Key
- debug key
- environment switches
- placement IDs grouped by format or screen

Do not spread these constants across random views.

### 3. One service per ad format

Preferred split:

- `TopOnRewardedService`
- `TopOnInterstitialService`
- `TopOnBannerService`
- `TopOnNativeService`
- `TopOnSplashService` if needed

Each service should own:

- placement ID selection
- load extras for that format
- ready check
- show call
- delegate callbacks
- next-ad preload policy if needed

### 4. Thin UI wrappers

UI views or controllers should:

- call the format service
- observe presentation state
- render returned ad views where applicable
- avoid holding TopOn SDK global configuration logic

## Format-specific lessons from the official demo

### Banner

Keep banner rules near banner code:

- banner size must match backend ratio
- retrieve banner view only after ready check
- keep destroy/remove logic explicit

### Interstitial

Use the simple lifecycle:

1. load
2. ready check
3. show with `ATShowConfig`
4. on close or fail, preload next if desired

### Rewarded

Use load extras for reward metadata only where needed:

- user ID
- reward name
- reward amount
- media extra

Keep reward callback handling isolated from business granting logic so the product layer can decide what to do on reward success.

### Native

Separate template and self-render paths. They are not the same integration problem.

For template native:

- request target size at load
- build `ATNativeADConfiguration`
- retrieve one offer
- render into an `ATNativeADView`
- clean up with `destroyNative()`

### Splash

Treat splash as its own flow:

- load early
- set timeout explicitly
- handle timeout and show-failure navigation safely
- guard duplicate navigation

## Recommended production adaptations

When moving from demo to product:

- replace demo view controllers with service-backed wrappers that fit your app's architecture
- keep TopOn SDK types inside `Core/Integrations` or equivalent
- map callbacks into your own domain events instead of leaking SDK delegate names outward
- use debug-only gates for DebugUI and integration checking
- keep consent ordering outside ad-format services when it is app-wide

## Recommended extraction path for a standalone demo

If the app may later be extracted into a minimal demo:

1. centralize all TopOn config now
2. keep each ad format self-contained
3. avoid coupling TopOn services to unrelated app state stores
4. keep a small demo host layer that can be swapped out of the app later

This is the same direction the official demo demonstrates, and it makes later extraction much cheaper.
