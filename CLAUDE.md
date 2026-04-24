# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working
with the iOS client repo.

## Repo layout

- `forma-ios/` — app source (SwiftUI + SwiftData)
- `forma-iosTests/` — unit tests (Swift Testing framework)
- `forma-iosUITests/` — UI tests
- `FormaShared/` — shared widget types (duplicated, not via SPM)
- `FormaWidgets/` — widget extension

The three-repo layout is: this repo for iOS, `~/Documents/Forma` for macOS,
`~/Documents/habit-tracker` for the Spring Boot backend. The iOS and macOS
clients share source by **duplication**, not SPM — every edit to shared
files (`Habit.swift`, `HabitBackend.swift`, `VerificationService.swift`,
etc.) must land in both repos.

## Build & Test Commands

```sh
xcodebuild -project forma-ios.xcodeproj -scheme forma-ios \
  -destination 'generic/platform=iOS Simulator' build

xcodebuild -project forma-ios.xcodeproj -scheme forma-ios \
  -destination 'platform=iOS Simulator,name=iPhone 15' test
```

## Verification + weekly targets

Same feature set as the macOS repo — see `~/Documents/Forma/CLAUDE.md` for
the full description.

**iOS-specific pieces**:

- `com.apple.developer.family-controls` entitlement enabled on both the
  main `forma-ios` target (`forma-ios.entitlements`) and the
  `ScreenTimeMonitor` extension target (`ScreenTimeMonitor.entitlements`)
- App Group `group.jashanveer.habit-tracker-macos` shared between both
  targets — the only memory bridge between the extension process and the
  main app
- `ScreenTimeService.swift` (iOS-only via `#if os(iOS)`) — authorization,
  selection persistence, and `DeviceActivityCenter` schedule lifecycle.
  `wasOverLimit(on:)` reads the App Group flag the extension writes.
- `ScreenTimeMonitor/DeviceActivityMonitorExtension.swift` — runs in a
  separate process, writes per-day overLimit flags into the shared
  `UserDefaults(suiteName:)` on `eventDidReachThreshold`. Keep the
  hardcoded `kAppGroupID` / activity / event names in sync with
  `ScreenTimeService`'s constants.
- `SocialAppsPickerSheet.swift` — wraps Apple's `FamilyActivityPicker`,
  presented automatically from `AddHabitBar` after the user creates a
  habit with the canonical `screenTime` key.
- `VerificationService.verifyScreenTimeSocial(...)` reads
  `ScreenTimeService.wasOverLimit(on:)` and awards `.auto` only when the
  user stayed under the threshold AND monitoring is active.

**Phase 3 distribution gate** — `Family Controls (Distribution)` is a
separate entitlement Apple grants by hand on request via
https://developer.apple.com/contact/request/family-controls-distribution.
Required to ship the feature on the App Store or to external TestFlight
testers. Internal testing on the developer's own device works the
moment the paid Apple Developer team is selected.

## Code Style

- 4-space indentation, PascalCase types, camelCase properties/methods
- SwiftUI + SwiftData + HealthKit + FamilyControls + Foundation only — no
  Combine in new code, no UIKit, no third-party packages
- iOS-specific APIs gated with `#if os(iOS)`; HealthKit is cross-platform
  and gated by entitlement, not platform
- Swift Testing framework (`@Test`, `#expect`) for tests

## MCP Tools: code-review-graph

See `~/Documents/Forma/CLAUDE.md` — same tooling guidance applies.
