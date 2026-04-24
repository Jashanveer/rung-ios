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

- `com.apple.developer.family-controls` entitlement enabled in
  `forma-ios.entitlements`
- `ScreenTimeService.swift` (iOS-only via `#if os(iOS)`) — authorization
  wrapper for Family Controls. `DeviceActivityMonitor` extension target
  is **not yet added** — needs manual Xcode surgery
- Onboarding's permissions step surfaces a Screen Time row alongside the
  Apple Health row; `VerificationService` falls through to self-report
  for `.screenTimeSocial` until the monitor extension ships

## Code Style

- 4-space indentation, PascalCase types, camelCase properties/methods
- SwiftUI + SwiftData + HealthKit + FamilyControls + Foundation only — no
  Combine in new code, no UIKit, no third-party packages
- iOS-specific APIs gated with `#if os(iOS)`; HealthKit is cross-platform
  and gated by entitlement, not platform
- Swift Testing framework (`@Test`, `#expect`) for tests

## MCP Tools: code-review-graph

See `~/Documents/Forma/CLAUDE.md` — same tooling guidance applies.
