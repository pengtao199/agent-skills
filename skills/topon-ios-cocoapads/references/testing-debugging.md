# TopOn iOS Testing And Debugging

Updated: 2026-04-13 (Asia/Shanghai)

## Primary official pages

- How to test ads: https://help.toponad.net/cn/docs/5xiiue
- Error codes: https://help.toponad.net/cn/docs/LqJJG4
- Integration checklist: https://help.toponad.net/cn/docs/ji-cheng-jian-cha-qing-dan-nLun

## Debug sequence

TopOn's docs support a layered validation path. Follow this order:

1. Turn on SDK logs.
2. Run integration checking.
3. Use TopOn test tools or debug mode.
4. Only then triage platform-specific error codes.

## Log and integration checking

The iOS integration doc shows:

```objc
[ATAPI setLogEnabled:YES];
[ATAPI integrationChecking];
```

Use these in debug builds while integrating. The official guide warns that integration checking should be removed for release builds.

## DebugUI and checklist usage

The integration checklist also points to the debugger UI path using `ATDebuggerAPI`. Use it when the user wants on-device verification of:

- device and app base info
- TopOn privacy and permission settings
- adapter integration state
- ad load behavior in a controlled test setup

If the task is "why does this placement not load", prefer DebugUI plus logs before changing business logic.

## How TopOn suggests testing ads

The "如何测试广告" page emphasizes:

- the test tool is only available after TopOn SDK initialization
- test tooling does not replace the app's own ad-flow testing
- test-tool code should be removed before release
- newer TopOn SDK versions need matching debugger versions

It also describes a debug-mode approach that locks requests to a selected ad platform and test source. That is useful when verifying whether a specific network adapter is integrated correctly.

## Error-code handling

The error-code page shows that many failures are network-specific rather than TopOn-core failures. For example:

- Tencent `4020`: `window` is nil, so app/window lifecycle wiring is wrong.
- Tencent `5006`: configured package name does not match backend settings.
- AppLovin `204`: no fill; region and network conditions may matter.

This means error handling should first classify:

- TopOn-core integration problem
- app lifecycle or view-controller wiring issue
- backend/config mismatch
- normal no-fill
- third-party network issue

## Practical troubleshooting checklist

When a user says "TopOn iOS is not working":

1. Confirm init succeeds and uses the correct app credentials.
2. Confirm the placement ID matches the intended ad format.
3. Confirm consent and ATT ordering.
4. Enable logs and integration checking.
5. Use test mode or DebugUI on a real device.
6. Inspect the returned domain and code before changing code paths.
