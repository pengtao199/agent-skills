---
name: topon-ios-cocoapads
description: Use this skill when working on TopOn iOS integration through CocoaPods, especially for Podfile setup, TopOn portal-generated snippets, Info.plist keys, ATT/IDFA, GDPR or Google UMP consent flow, DebugUI/integration checking, migration review, or TopOn iOS SDK troubleshooting.
---

# TopOn iOS CocoaPods

Use this skill for TopOn iOS work that is centered on CocoaPods-based integration and validation. It is for adding TopOn to an app, reviewing an existing integration, debugging no-fill or init failures, or checking whether privacy and testing steps are complete before release.

This skill is also the default skill for building a reusable TopOn iOS integration layer or extracting a standalone TopOn demo from an existing app. The preferred reference implementation is the official TopOn CocoaPods demo repo, which separates SDK initialization from each ad-format implementation instead of scattering TopOn calls across unrelated screens.

When the target app is a larger production app instead of a demo, bias strongly toward isolation:

- business flow decides when ads are needed
- integration layer decides how TopOn works
- UI consumes neutral ad renderables or protocols
- ad-SDK imports stay inside a narrow integration boundary

## When To Use

Trigger this skill when the request mentions any of:

- TopOn iOS
- AnyThinkSDK / ATAPI
- CocoaPods / Podfile / `pod install`
- `Info.plist` keys for SKAdNetwork, ATT, ATS, AdMob app ID
- GDPR / Google UMP / privacy consent before SDK init
- TopOn debug logs, `integrationChecking`, DebugUI, error codes
- TopOn iOS migration review, especially `v6.5.xx`

## Workflow

### 1. Confirm the integration boundary

First determine:

- Is the user doing a fresh CocoaPods integration, or reviewing an existing one?
- Which ad networks are enabled in the TopOn portal?
- Whether AdMob is included.
- Whether the app serves EEA/UK users or otherwise needs GDPR / UMP handling.
- Whether the user wants only docs/analysis, or real project edits.

If the task is ambiguous, pause and ask before editing because Podfile content, `Info.plist` keys, and consent flow depend on the selected networks and compliance path.

If the codebase already contains another ad provider or a mixed ad architecture, first map the boundary between:

- startup bootstrap
- rewarded business flow
- page-level banner/native rendering
- revenue and record upload logic

Do not start by swapping SDK calls in place. Start by defining the isolation seam.

### 2. Treat the TopOn portal output as the source of truth

For CocoaPods integration, do not guess pod names or `Info.plist` snippets from memory.

- Use the TopOn SDK download center output as the primary source for the Podfile block.
- Keep the portal page open while integrating because it also provides `SKAdNetworkItems` and `LSApplicationQueriesSchemes`.
- If the current task is version-sensitive, browse the latest official TopOn docs before finalizing.

The official demo repo is a secondary source of truth for code structure, not for pod versions. Use it to model initialization boundaries, load/show flow, and delegate handling. Use the portal output to decide the actual pods and versions.

If the user wants a starting point they can copy into a new app or extract into a small demo target, reuse the asset template under `./assets/topon-swift-minimal-template/`.

### 3. Apply the base integration checklist

For a normal CocoaPods flow, verify all of the following:

- The project uses the TopOn portal-generated Podfile snippet.
- `pod install --repo-update` is run from the Podfile directory.
- `Info.plist` includes the current portal-generated `SKAdNetworkItems`.
- `Info.plist` includes the required `LSApplicationQueriesSchemes`.
- `NSUserTrackingUsageDescription` is present if ATT is requested.
- `NSAppTransportSecurity` is configured if the integration path requires it.
- `GADApplicationIdentifier` is added only when AdMob is included.
- The TopOn `App ID`, `App Key`, placement IDs, and bundle ID match the TopOn backend.

Read [integration-checklist.md](./references/integration-checklist.md) for the exact validation sequence and doc links.

If the task asks for a reusable integration or demo extraction, also read [official-demo-repo.md](./references/official-demo-repo.md).

### 4. Gate initialization behind consent when required

The most important rule is ordering:

- If the app has its own first-launch privacy agreement, make sure the user agrees before initializing TopOn.
- If GDPR / Google UMP applies, complete that flow before calling TopOn SDK initialization.
- Prefer the TopOn-provided UMP flow when the project is already using TopOn's recommended path.
- If keeping the app's original UMP API flow, initialize TopOn only after consent is resolved or ads can be requested.

Read [privacy-compliance.md](./references/privacy-compliance.md) before changing consent logic.

### 5. Add debugging before assuming the integration is broken

During integration or troubleshooting:

- Enable TopOn debug logs with `ATAPI setLogEnabled:YES`.
- Use `ATAPI integrationChecking` during debug builds to verify adapter integration.
- Use DebugUI when the user wants a device-side inspection workflow.
- Remove or disable debug-only checks before release.

Read [testing-debugging.md](./references/testing-debugging.md) for the recommended test order.

When the user wants a reusable scaffold, also read [swift-demo-blueprint.md](./references/swift-demo-blueprint.md) and keep the code split close to the official demo:

- one SDK manager for init and compliance flow
- one file per ad format
- one small config helper area for optional load/show extras
- no ad-SDK types leaking into unrelated business views unless wrapped by a dedicated integration layer

### 6. Troubleshoot in this order

When ads do not load or display:

1. Verify SDK init parameters, placement IDs, bundle ID, and Podfile output from the portal.
2. Verify `Info.plist` keys and ATT / consent ordering.
3. Enable logs and run integration checking.
4. Use TopOn test tooling or debug mode before blaming fill rate.
5. Only then inspect platform-specific error codes.

Avoid treating "single device, short time, no fill" as proof of a broken integration if test mode and integration checks are otherwise healthy.

### 7. Use migration guidance when the task mentions `v6.5.xx`

If the request is a migration or upgrade:

- Review current SDK version, adapters, and custom wrappers.
- Check whether consent flow, debug tools, or callback assumptions changed.
- Re-run the same integration checklist after migration instead of assuming old settings still apply.

Keep migration notes separate from the base integration path so the main skill stays reusable.

### 8. Prefer a demo-friendly architecture

When implementing TopOn in a production app that may later be extracted into a standalone sample:

- Keep App ID, App Key, debug key, and placement IDs in one focused integration area.
- Isolate SDK init in a single manager similar to the official `AdSDKManager`.
- Keep each ad format in its own file or small group of files.
- Separate global configuration helpers from ad-format controllers.
- Avoid mixing ad SDK calls into unrelated feature stores or view models.
- Preserve a clean path for later extraction into a minimal demo target.

For Swift projects, the best default is:

1. `TopOnSDKManager` or equivalent init facade.
2. `TopOnConfig` for IDs and environment flags.
3. `TopOnRewardedService`, `TopOnBannerService`, `TopOnNativeService`, etc.
4. Thin UI wrappers that only consume those services.

### 9. Isolation-first migration rule

For migrations from another ad provider to TopOn:

1. Remove or neutralize the old provider.
2. Define provider-agnostic product interfaces.
3. Centralize ad config and placement ownership.
4. Move TopOn SDK code into `Core/Integrations/Ads/TopOn` or equivalent.
5. Only then reconnect business flows.

If a codebase mixes ad SDK calls directly inside download flows, preview pages, or content grids, treat that as an architecture problem before treating it as an SDK migration problem.

## Output Expectations

When using this skill, structure the response around:

1. Current integration state.
2. Missing items or risks.
3. Exact files to update, such as `Podfile`, `Info.plist`, `AppDelegate`, consent manager, or ad wrapper.
4. Validation steps to prove the integration is correct.
5. If migrating an existing app, explicitly state which files belong to product-layer ads and which belong to SDK-layer ads.

If editing code, keep changes small and tie each change to one concrete verification point.

## References

- [integration-checklist.md](./references/integration-checklist.md): CocoaPods integration, `Info.plist`, initialization, and checklist items.
- [privacy-compliance.md](./references/privacy-compliance.md): privacy policy, ATT, GDPR, UMP, and init ordering.
- [testing-debugging.md](./references/testing-debugging.md): logs, DebugUI, integration checking, test flow, and error-code triage.
- [official-demo-repo.md](./references/official-demo-repo.md): what the official TopOn CocoaPods demo repo demonstrates and what to copy from it.
- [swift-demo-blueprint.md](./references/swift-demo-blueprint.md): a reusable Swift integration blueprint distilled from the official demo.
- `./assets/topon-swift-minimal-template/`: copyable minimal Swift template based on the official demo structure.
