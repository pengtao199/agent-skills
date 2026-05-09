# TopOn iOS Privacy And Compliance Notes

Updated: 2026-04-13 (Asia/Shanghai)

## Primary official pages

- Privacy data collection: https://help.toponad.net/cn/docs/yin-si-xin-xi-shuo-ming
- Privacy compliance guide: https://help.toponad.net/cn/docs/ByIf1V
- Google UMP guide: https://help.toponad.net/cn/docs/Google-UMP-shi-pei-shi-yong-zhi-nan-fMgm

## Non-negotiable ordering

TopOn's privacy compliance material says the app should:

1. have its own privacy policy
2. show that policy on first launch
3. obtain user agreement
4. only then initialize TopOn SDK

If a task touches init code, always review whether privacy acceptance and SDK init ordering are still correct.

## What the app privacy policy must cover

The privacy compliance guide says the app's own privacy policy should disclose that it uses TopOn SDK and should include the relevant TopOn privacy policy information.

The TopOn privacy data page lists iOS-side identifiers such as:

- IDFA
- IDFV

and also shared device/app/network metadata such as:

- app version
- bundle/package identity
- device model
- IP address
- network type
- language
- timezone

Do not copy these lists verbatim into product copy without legal review, but do use them to validate whether the team's disclosure is materially complete.

## ATT specifics

The TopOn integration guide requires `NSUserTrackingUsageDescription` before ATT request. ATT is necessary if the app wants IDFA access for personalized ads.

Check both:

- plist key exists
- runtime request actually happens in a valid lifecycle state

## GDPR and Google UMP

TopOn's UMP guide states:

- For EEA/UK monetization involving AdSense, Ad Manager, or AdMob, a compliant CMP path is required.
- TopOn supports integrating with Google UMP and reading that consent state to propagate GDPR settings to third-party networks.
- The AdMob GDPR partner list should include all applicable integrated networks, except for platform exceptions called out in TopOn's guide.

## Initialization rule when UMP is used

If using the TopOn-recommended path:

- prefer TopOn's consent dialog wrapper for UMP
- initialize TopOn in the dismissal callback after consent handling completes

If preserving the app's existing UMP SDK logic:

- initialize TopOn only after the consent form callback returns or the SDK reports that ads can be requested

This ordering is a frequent root cause of "integration seems correct but fill or behavior is wrong."

## Review checklist

When reviewing code:

1. Find where the app presents its own privacy agreement.
2. Find where ATT is requested.
3. Find whether UMP is used and which API path is chosen.
4. Verify `ATAPI` init runs after the required consent path.
5. Flag any early init done from `didFinishLaunching` when consent should have gated it.
