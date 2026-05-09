# TopOn iOS CocoaPods Integration Checklist

Updated: 2026-04-13 (Asia/Shanghai)

## Primary official pages

- Main entry: https://help.toponad.net/cn/docs/iOS
- Integration: https://help.toponad.net/cn/docs/ji-cheng
- Integration checklist: https://help.toponad.net/cn/docs/ji-cheng-jian-cha-qing-dan-nLun

## Core conclusions

### 1. CocoaPods is the preferred path

The TopOn iOS integration page explicitly marks CocoaPods as the preferred method. The docs instruct the developer to generate the Podfile snippet in the TopOn SDK download center and then run:

```bash
pod install --repo-update
```

Do not reconstruct the pod list from memory. The selected ad networks in the portal determine the generated dependency block.

### 2. Keep the SDK download center open

The integration page repeatedly tells the developer not to leave the TopOn download center because the same page also provides:

- the Podfile snippet
- `SKAdNetworkItems`
- `LSApplicationQueriesSchemes`
- any extra integration hints for selected networks

If the user asks for project edits, require these generated values when they are not already present in the repo.

### 3. `Info.plist` is part of the integration, not a follow-up

The official integration page requires these checks:

- Add the generated `SKAdNetworkItems`.
- Add `LSApplicationQueriesSchemes`.
- Add `NSUserTrackingUsageDescription` for ATT.
- Add `NSAppTransportSecurity` if the integration guide requires it.
- Add `GADApplicationIdentifier` only when AdMob is selected.

### 4. ATT permission timing matters

TopOn's iOS integration guide notes that IDFA is unavailable until the app requests tracking authorization and the user responds. It also notes that on iOS 15+, the permission prompt only appears while the app is active.

This means ATT request placement should be reviewed together with app lifecycle code, not as an isolated plist change.

### 5. Initialization baseline

The integration page shows the base init flow as:

- optional privacy / GDPR / UMP handling first
- then `[[ATAPI sharedInstance] startWithAppID:appID appKey:appKey error:nil]`

Treat consent ordering as a hard gate when privacy controls apply.

## Practical review sequence

When auditing a repo:

1. Check `Podfile` for a TopOn portal-generated CocoaPods block.
2. Check `Info.plist` for ATT, SKAdNetwork, schemes, ATS, and AdMob app ID where applicable.
3. Check app launch and consent flow ordering before `ATAPI` initialization.
4. Check that placement IDs and bundle ID match the backend config the team is using.
5. Check that debug-only verification calls are not left enabled in release code.

## Extra checklist notes from TopOn's integration checklist page

The official checklist emphasizes:

- `App ID`, `App Key`, placement IDs, and bundle ID must match backend configuration.
- All placements should load and show after SDK init.
- `Info.plist` permissions such as ATT and HTTP-related settings should be correct.
- Debug stage should enable logs.
- Device-side debug tooling should be used to verify third-party adapter integration.

## Common audit smells

- Handwritten pod declarations that do not clearly come from the current TopOn portal output.
- `Info.plist` missing generated SKAdNetwork entries.
- AdMob enabled without `GADApplicationIdentifier`.
- ATT string present but no actual consent request path.
- SDK init running before privacy agreement or UMP completion.
