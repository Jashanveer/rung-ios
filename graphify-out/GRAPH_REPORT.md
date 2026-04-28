# Graph Report - /Users/jashanveer/Documents/forma-ios  (2026-04-27)

## Corpus Check
- 68 files · ~117,962 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 406 nodes · 792 edges · 34 communities detected
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 81 edges (avg confidence: 0.79)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 11|Community 11]]
- [[_COMMUNITY_Community 12|Community 12]]
- [[_COMMUNITY_Community 13|Community 13]]
- [[_COMMUNITY_Community 14|Community 14]]
- [[_COMMUNITY_Community 15|Community 15]]
- [[_COMMUNITY_Community 16|Community 16]]
- [[_COMMUNITY_Community 17|Community 17]]
- [[_COMMUNITY_Community 18|Community 18]]
- [[_COMMUNITY_Community 19|Community 19]]
- [[_COMMUNITY_Community 20|Community 20]]
- [[_COMMUNITY_Community 21|Community 21]]
- [[_COMMUNITY_Community 22|Community 22]]
- [[_COMMUNITY_Community 23|Community 23]]
- [[_COMMUNITY_Community 24|Community 24]]
- [[_COMMUNITY_Community 25|Community 25]]
- [[_COMMUNITY_Community 26|Community 26]]
- [[_COMMUNITY_Community 27|Community 27]]
- [[_COMMUNITY_Community 28|Community 28]]
- [[_COMMUNITY_Community 29|Community 29]]
- [[_COMMUNITY_Community 30|Community 30]]
- [[_COMMUNITY_Community 31|Community 31]]
- [[_COMMUNITY_Community 32|Community 32]]
- [[_COMMUNITY_Community 33|Community 33]]

## God Nodes (most connected - your core abstractions)
1. `HabitBackendStore` - 73 edges
2. `CodingKeys` - 48 edges
3. `BackendAPIClient` - 22 edges
4. `Habit @Model` - 15 edges
5. `WidgetSnapshot DTO` - 15 edges
6. `BackendHabit` - 13 edges
7. `PhoneTabScaffold (iPhone 5-tab root)` - 13 edges
8. `AccountabilityRepository` - 13 edges
9. `HabitRepository` - 12 edges
10. `SnapshotTimelineProvider` - 12 edges

## Surprising Connections (you probably didn't know these)
- `FlowLayout (private)` --semantically_similar_to--> `ProgressRing`  [INFERRED] [semantically similar]
  forma-ios/VerificationHelpSheet.swift → FormaWidgets/WidgetStyles.swift
- `Habit @Model` --rationale_for--> `Code Style (SwiftUI + SwiftData, no Combine/UIKit)`  [INFERRED]
  forma-ios/Habit.swift → CLAUDE.md
- `VerificationService actor` --semantically_similar_to--> `ToggleHabitIntent (AppIntent)`  [INFERRED] [semantically similar]
  forma-ios/VerificationService.swift → FormaShared/ToggleHabitIntent.swift
- `Debounced username availability check (350ms)` --calls--> `BackendAPIClient`  [INFERRED]
  forma-ios/AppleProfileSetupView.swift → /Users/jashanveer/Documents/forma-ios/forma-ios/BackendNetworking.swift
- `DeviceActivityMonitorExtension` --shares_data_with--> `VerificationService actor`  [INFERRED]
  ScreenTimeMonitor/DeviceActivityMonitorExtension.swift → forma-ios/VerificationService.swift

## Hyperedges (group relationships)
- **Cold-launch intro → auth → cascade → dashboard handoff** — formaintroview_formaintroview, formatransition_formatransition, authviews_authgateview, formaiconview_formaiconview, contentview_contentview [INFERRED 0.90]
- **Cross-device real-time habit sync (SSE + outbox + reconcile)** — backendnetworking_user_stream_request, habitbackend_user_sse_stream, forma_iosapp_habitschangedsse_notification, contentview_syncwithbackend, contentview_flushoutbox, contentview_applyreconcile [EXTRACTED 1.00]
- **Habit verification: canonical match → AutoVerify → tier-weighted scoring** — canonicalhabits_canonicalhabits_registry, habit_verificationtier, habit_verificationsource, autoverificationcoordinator_autoverificationcoordinator, contentview_togglehabit [EXTRACTED 1.00]
- **** —  [INFERRED]
- **** —  [INFERRED]
- **** —  [INFERRED]
- **** —  [INFERRED 0.90]
- **** —  [INFERRED 0.95]
- **** —  [EXTRACTED 1.00]

## Communities

### Community 0 - "Community 0"
Cohesion: 0.04
Nodes (40): ApiErrorResponse, AppleLoginRequest, AuthRepository, BackendAPIClient, BackendAuthTokens, BackendEnvironment, BackendSession, DeviceRepository (+32 more)

### Community 1 - "Community 1"
Cohesion: 0.09
Nodes (5): Entry, ResponseCache, resolveOnboardingState (signup-only gate), HabitBackendStore, ObservableObject

### Community 2 - "Community 2"
Cohesion: 0.06
Nodes (46): AppleProfileSetupView, Setup vs Edit dual init rationale, AvatarChoice (DiceBear avatar registry), AvatarChoiceButton, ConnectionStatusIcon, CalendarDisplayMode (activity vs perfectDays), CalendarSheet, FlowLayout (chip wrapping layout) (+38 more)

### Community 3 - "Community 3"
Cohesion: 0.04
Nodes (46): CodingKeys, aiMentor, badges, canonicalKey, checksByDate, checksToday, createdAt, currentUser (+38 more)

### Community 4 - "Community 4"
Cohesion: 0.07
Nodes (40): AutoVerificationCoordinator (singleton), HKObserverQuery + background delivery wakeup, Manual override always at .selfReport tier, Screen Time scans yesterday (today not decided until EOD), CanonicalHabit struct, CanonicalHabits registry (20 seeded habits), Fuzzy alias-match pipeline (normalize + Levenshtein), VerificationServiceFallbackTests (+32 more)

### Community 5 - "Community 5"
Cohesion: 0.13
Nodes (7): AccountabilityRepository, CheckUpdateRequest, HabitRepository, HabitWriteRequest, RetryPolicy, TaskWriteRequest, BackendHabit

### Community 6 - "Community 6"
Cohesion: 0.15
Nodes (21): Decodable, EmptyResponse, FriendSummary, HabitTimeCluster, LeaderboardEntry, Level, MenteeDashboard, MenteeSummary (+13 more)

### Community 7 - "Community 7"
Cohesion: 0.31
Nodes (21): ChecklistWidget, CommandCenterWidget, DashboardWidget, FormaWidgetsBundle, FriendsProgressWidget, LeaderboardWidget, MenteeViewWidget, SnapshotEntry (TimelineEntry) (+13 more)

### Community 8 - "Community 8"
Cohesion: 0.16
Nodes (16): Debounced username availability check (350ms), Apple-only sign-in policy (email path retained but hidden), AuthCodeField (6-cell OTP input), AuthExperienceOverlay, AuthGateView, FloatingHabitBackground, Color formaBg/formaBlue/formaGold/formaGrey, FormaIconView (4x4 brand icon) (+8 more)

### Community 9 - "Community 9"
Cohesion: 0.18
Nodes (9): CodingKeys, accessToken, accessTokenExpiresAtEpochSeconds, isNewUser, refreshToken, token, JWTTokenInspector, CodingKey (+1 more)

### Community 10 - "Community 10"
Cohesion: 1.0
Nodes (2): StreakActivityAttributes (Live Activity schema), StreakActivityController

### Community 11 - "Community 11"
Cohesion: 1.0
Nodes (2): Phase 3 Family Controls Distribution gate, iOS Screen Time / FamilyControls integration

### Community 12 - "Community 12"
Cohesion: 1.0
Nodes (0): 

### Community 13 - "Community 13"
Cohesion: 1.0
Nodes (1): SyncEngine (server-wins reconcile)

### Community 14 - "Community 14"
Cohesion: 1.0
Nodes (1): AvailabilityState enum

### Community 15 - "Community 15"
Cohesion: 1.0
Nodes (1): SmartGreeting

### Community 16 - "Community 16"
Cohesion: 1.0
Nodes (1): Compact (phone tab) vs regular (pad/mac edge-handle) layout split

### Community 17 - "Community 17"
Cohesion: 1.0
Nodes (1): TodayHeader

### Community 18 - "Community 18"
Cohesion: 1.0
Nodes (1): CleanShotSurfaceLevel enum

### Community 19 - "Community 19"
Cohesion: 1.0
Nodes (1): FormaQuotes

### Community 20 - "Community 20"
Cohesion: 1.0
Nodes (1): duplicateMatchKey / hasDuplicate

### Community 21 - "Community 21"
Cohesion: 1.0
Nodes (1): handleOverdueTasks XP penalty

### Community 22 - "Community 22"
Cohesion: 1.0
Nodes (1): HabitCompletion (SwiftData verification record)

### Community 23 - "Community 23"
Cohesion: 1.0
Nodes (1): NetworkMonitor (NWPathMonitor wrapper)

### Community 24 - "Community 24"
Cohesion: 1.0
Nodes (1): forma_iosUITests

### Community 25 - "Community 25"
Cohesion: 1.0
Nodes (1): forma_iosUITestsLaunchTests

### Community 26 - "Community 26"
Cohesion: 1.0
Nodes (1): CanonicalHabitsTests

### Community 27 - "Community 27"
Cohesion: 1.0
Nodes (1): HabitMigrationTests

### Community 28 - "Community 28"
Cohesion: 1.0
Nodes (1): WeeklyTargetTests

### Community 29 - "Community 29"
Cohesion: 1.0
Nodes (1): forma_iosTests scaffold

### Community 30 - "Community 30"
Cohesion: 1.0
Nodes (1): Session epoch TOCTOU defence

### Community 31 - "Community 31"
Cohesion: 1.0
Nodes (1): 5s habits cache rationale (avoid stale SSE-driven sync)

### Community 32 - "Community 32"
Cohesion: 1.0
Nodes (1): Repo Layout (iOS+macOS+Backend)

### Community 33 - "Community 33"
Cohesion: 1.0
Nodes (1): Shared-by-duplication policy

## Knowledge Gaps
- **117 isolated node(s):** `MenteeEmptyChatBubble`, `PressHoverModifier`, `StreakActivityAttributes (Live Activity schema)`, `id`, `title` (+112 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **Thin community `Community 10`** (2 nodes): `StreakActivityAttributes (Live Activity schema)`, `StreakActivityController`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 11`** (2 nodes): `Phase 3 Family Controls Distribution gate`, `iOS Screen Time / FamilyControls integration`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 12`** (1 nodes): `FloatingCheckPill.swift`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 13`** (1 nodes): `SyncEngine (server-wins reconcile)`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 14`** (1 nodes): `AvailabilityState enum`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 15`** (1 nodes): `SmartGreeting`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 16`** (1 nodes): `Compact (phone tab) vs regular (pad/mac edge-handle) layout split`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 17`** (1 nodes): `TodayHeader`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 18`** (1 nodes): `CleanShotSurfaceLevel enum`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 19`** (1 nodes): `FormaQuotes`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 20`** (1 nodes): `duplicateMatchKey / hasDuplicate`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 21`** (1 nodes): `handleOverdueTasks XP penalty`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 22`** (1 nodes): `HabitCompletion (SwiftData verification record)`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 23`** (1 nodes): `NetworkMonitor (NWPathMonitor wrapper)`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 24`** (1 nodes): `forma_iosUITests`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 25`** (1 nodes): `forma_iosUITestsLaunchTests`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 26`** (1 nodes): `CanonicalHabitsTests`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 27`** (1 nodes): `HabitMigrationTests`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 28`** (1 nodes): `WeeklyTargetTests`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 29`** (1 nodes): `forma_iosTests scaffold`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 30`** (1 nodes): `Session epoch TOCTOU defence`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 31`** (1 nodes): `5s habits cache rationale (avoid stale SSE-driven sync)`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 32`** (1 nodes): `Repo Layout (iOS+macOS+Backend)`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 33`** (1 nodes): `Shared-by-duplication policy`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `HabitBackendStore` connect `Community 1` to `Community 0`, `Community 2`, `Community 4`, `Community 6`, `Community 7`, `Community 8`, `Community 9`?**
  _High betweenness centrality (0.498) - this node is a cross-community bridge._
- **Why does `CodingKeys` connect `Community 3` to `Community 9`, `Community 6`?**
  _High betweenness centrality (0.200) - this node is a cross-community bridge._
- **Why does `WidgetSnapshotWriter` connect `Community 7` to `Community 1`, `Community 2`, `Community 4`?**
  _High betweenness centrality (0.086) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `BackendAPIClient` (e.g. with `Debounced username availability check (350ms)` and `.init()`) actually correct?**
  _`BackendAPIClient` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `MenteeEmptyChatBubble`, `PressHoverModifier`, `StreakActivityAttributes (Live Activity schema)` to the rest of the system?**
  _117 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.04 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.09 - nodes in this community are weakly interconnected._