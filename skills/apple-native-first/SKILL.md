---
name: apple-native-first
description: Use when building, reviewing, planning, or debugging Apple-platform apps and the user wants native iOS, SwiftUI, UIKit, Apple Developer documentation, or official Apple frameworks considered before custom code or third-party libraries. Routes product needs to Apple-native APIs such as SwiftUI, UIKit, App Intents, StoreKit, SwiftData, CloudKit, PhotosUI, PhotoKit, AVFoundation, Vision, Core ML, MapKit, WidgetKit, ActivityKit, BackgroundTasks, UserNotifications, HealthKit, PencilKit, PassKit, and related official frameworks.
---

# Apple Native First

## Purpose

Use this skill as a guardrail before inventing an iOS solution. The job is to map the user's need to official Apple capabilities first, then to existing project patterns, then to third-party libraries or custom code only when the native route is insufficient.

Reference docs must come from Apple official documentation only. Prefer `https://developer.apple.com/documentation/...`, Apple Human Interface Guidelines, Apple sample code, and Apple Developer videos. Do not cite blogs, Stack Overflow, package READMEs, vendor tutorials, or AI-generated summaries as the reference basis for the native decision.

## Workflow

1. Identify the Apple-platform problem.
   - Name the target platform and deployment floor if known: iOS, iPadOS, macOS, watchOS, tvOS, visionOS.
   - Name the user-facing need: search, media, persistence, sync, payments, notifications, widgets, scanning, AI, maps, accessibility, authentication, background work, sharing, drawing, testing, or review compliance.
   - If the deployment target is unknown, state the assumption and avoid choosing APIs whose availability is likely too new without calling that out.

2. Read local context before choosing a pattern.
   - Inspect nearby code, project rules, entitlements, package dependencies, and existing architecture.
   - If the project has `.codegraph/`, use CodeGraph for broad architecture or symbol exploration before broad file searches.
   - Prefer established local wrappers when they already expose the native Apple API cleanly.

3. Check the native Apple route first.
   - Look up current Apple Developer documentation when API availability, behavior, or platform guidance may have changed.
   - Use only Apple official reference links in the answer or artifact.
   - Prefer system UI and system services where they match the job: native controls, native permissions, native rendering, native background execution, native data stores, native privacy and review flows.

4. Route to a more specific skill when useful.
   - SwiftUI UI, navigation, state, controls: use a SwiftUI UI/patterns skill.
   - SwiftUI performance or jank: use a SwiftUI performance skill.
   - App Intents, Shortcuts, Siri, Spotlight, widgets, controls: use an App Intents skill.
   - Networking: use an iOS networking skill.
   - Localization: use an iOS localization skill.
   - Interaction motion: use an iOS interaction tuning skill.
   - StoreKit, monetization, App Store review, privacy: use the matching commerce or review skill.
   - If an external Apple API-reference skill is installed, use it as an index, but keep final reference links Apple-official.

5. Decide visibly.
   - State the native option, why it fits or does not fit, and any OS availability constraints.
   - If choosing custom code or a third-party library, explain the native gap first.
   - Keep the implementation minimal and aligned with local architecture.

## Native Capability Map

Use this map to route common user requests:

| User need | Prefer Apple-native route |
| --- | --- |
| App UI, forms, lists, settings, search | SwiftUI controls, `NavigationStack`, `List`, `Form`, `.searchable`, `toolbar`, sheets, alerts |
| UIKit-only surfaces or incremental migration | UIKit, `UIViewRepresentable`, `UIViewControllerRepresentable`, `UIHostingController` |
| Search UI | SwiftUI `.searchable` and `SearchFieldPlacement` before custom search bars |
| Media playback | AVFoundation, AVKit, `AVPlayer`, `AVQueuePlayer`, `AVPlayerLooper`, `VideoPlayer` |
| Photo picking and library access | PhotosUI `PhotosPicker`, PhotoKit, PHPicker APIs |
| Camera, recording, capture previews | AVFoundation capture APIs; bridge UIKit views into SwiftUI when needed |
| Local persistence | SwiftData first for new SwiftUI apps; Core Data for existing Core Data apps |
| iCloud sync and sharing | CloudKit, SwiftData CloudKit configuration, `CKSyncEngine`, `CKShare` |
| In-app purchases and subscriptions | StoreKit 2, `Product`, `Transaction`, `ProductView`, `StoreView`, `SubscriptionStoreView` |
| Siri, Shortcuts, Spotlight, system actions | App Intents, App Entities, App Shortcuts |
| Widgets, Control Center, Live Activities | WidgetKit, ActivityKit, App Intents-backed controls |
| Notifications | UserNotifications, notification content/action/service extensions |
| Background refresh or processing | BackgroundTasks, background URLSession, silent push where appropriate |
| Maps and location display | MapKit, Core Location |
| OCR, barcode scanning, document scanning | Vision, VisionKit |
| Image classification, model inference, on-device ML | Core ML, Vision + Core ML |
| Apple Intelligence / on-device language tasks | Foundation Models where available; Core ML or app-specific fallback otherwise |
| Charts | Swift Charts |
| Drawing, pencil, markup | PencilKit; PaperKit where available |
| Payments and Wallet | PassKit, Apple Pay, Wallet passes |
| Health and fitness data | HealthKit |
| Calendar and reminders | EventKit and EventKitUI |
| Authentication | AuthenticationServices, LocalAuthentication, passkeys, Sign in with Apple |
| Security and crypto | Keychain Services, CryptoKit, Secure Enclave |
| Haptics | Core Haptics or UIKit feedback generators |
| Accessibility | SwiftUI/UIKit accessibility APIs, Dynamic Type, VoiceOver, Switch Control |
| Testing | Swift Testing, XCTest, XCUITest |
| Performance and debugging | Instruments, MetricKit, Xcode Memory Graph, os logging |

## Official Reference Links

Use these Apple-only entry points as starting references. Add deeper Apple links as needed for the exact API.

- SwiftUI: https://developer.apple.com/documentation/swiftui
- UIKit: https://developer.apple.com/documentation/uikit
- App Intents: https://developer.apple.com/documentation/appintents
- StoreKit: https://developer.apple.com/documentation/storekit
- SwiftData: https://developer.apple.com/documentation/swiftdata
- CloudKit: https://developer.apple.com/documentation/cloudkit
- AVFoundation: https://developer.apple.com/documentation/avfoundation
- AVKit: https://developer.apple.com/documentation/avkit
- PhotosUI: https://developer.apple.com/documentation/photosui
- PhotoKit: https://developer.apple.com/documentation/photokit
- Vision: https://developer.apple.com/documentation/vision
- VisionKit: https://developer.apple.com/documentation/visionkit
- Core ML: https://developer.apple.com/documentation/coreml
- Foundation Models: https://developer.apple.com/documentation/foundationmodels
- MapKit: https://developer.apple.com/documentation/mapkit
- Core Location: https://developer.apple.com/documentation/corelocation
- WidgetKit: https://developer.apple.com/documentation/widgetkit
- ActivityKit: https://developer.apple.com/documentation/activitykit
- BackgroundTasks: https://developer.apple.com/documentation/backgroundtasks
- UserNotifications: https://developer.apple.com/documentation/usernotifications
- HealthKit: https://developer.apple.com/documentation/healthkit
- EventKit: https://developer.apple.com/documentation/eventkit
- PassKit: https://developer.apple.com/documentation/passkit
- PencilKit: https://developer.apple.com/documentation/pencilkit
- Core Haptics: https://developer.apple.com/documentation/corehaptics
- AuthenticationServices: https://developer.apple.com/documentation/authenticationservices
- LocalAuthentication: https://developer.apple.com/documentation/localauthentication
- CryptoKit: https://developer.apple.com/documentation/cryptokit
- Swift Charts: https://developer.apple.com/documentation/charts
- Swift Testing: https://developer.apple.com/documentation/testing
- XCTest: https://developer.apple.com/documentation/xctest
- Human Interface Guidelines: https://developer.apple.com/design/human-interface-guidelines
- Apple Developer Videos: https://developer.apple.com/videos/
- Apple Sample Code: https://developer.apple.com/sample-code/

## Native-First Review Checklist

- Did you identify the matching Apple framework or explain why none fits?
- Did you check the deployment target before selecting a newer API?
- Are all cited reference links Apple official?
- Are system controls, permissions, and services used before custom UI or prompt-driven behavior?
- Does the solution fit the repo's existing architecture and wrappers?
- If a third-party dependency is proposed, is the Apple-native limitation explicit?
- Are deterministic behaviors implemented in code, not delegated to model prompts?
