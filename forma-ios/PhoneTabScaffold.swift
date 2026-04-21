#if os(iOS)
import SwiftData
import SwiftUI

/// iPhone-specific root layout. Mirrors the Forma iOS wireframes: a five-tab
/// `TabView` (Today / Stats / Friends / Account / Calendar) replaces the macOS
/// edge-handle paradigm. All global overlays (onboarding, intro, confetti,
/// speech bubble nudge) sit above the TabView.
struct PhoneTabScaffold: View {
    enum Tab: Hashable { case today, stats, friends, account, calendar }

    let colorScheme: ColorScheme
    let habits: [Habit]
    let todayKey: String
    @Binding var newHabitTitle: String
    @Binding var newEntryType: HabitEntryType
    let metrics: HabitMetrics
    @ObservedObject var backend: HabitBackendStore

    let showCelebration: Bool
    @Binding var mentorNudge: String?
    let showMentorCharacter: Bool
    let showMenteeCharacter: Bool
    let mentorMissedCount: Int

    let showOnboarding: Bool

    let stampNamespace: Namespace.ID
    let stampStagingIds: Set<PersistentIdentifier>

    let onAddHabit: (HabitEntryType, Date?) -> Void
    let onToggleHabit: (Habit) -> Void
    let onDeleteHabit: (Habit) -> Void
    let onSync: () -> Void
    let onFindMentor: () -> Void
    let onReminderChange: (Habit, HabitReminderWindow?) -> Void
    let onCompleteOnboarding: ([String]) -> Void

    @State private var selectedTab: Tab = .today

    var body: some View {
        TabView(selection: $selectedTab) {
            todayTab
                .tabItem { Label("Today", systemImage: "checkmark.circle.fill") }
                .tag(Tab.today)

            statsTab
                .tabItem { Label("Stats", systemImage: "chart.bar.xaxis") }
                .tag(Tab.stats)

            friendsTab
                .tabItem { Label("Friends", systemImage: "person.2.fill") }
                .tag(Tab.friends)

            calendarTab
                .tabItem { Label("Calendar", systemImage: "calendar") }
                .tag(Tab.calendar)

            accountTab
                .tabItem { Label("Account", systemImage: "person.crop.circle") }
                .tag(Tab.account)
        }
        .tint(CleanShotTheme.accent)
        .onChange(of: selectedTab) { _, _ in Haptics.selection() }
        .overlay {
            if showCelebration {
                ConfettiOverlay()
                    .allowsHitTesting(false)
                    .transition(.opacity)
                    .zIndex(100)
            }
        }
        .overlay {
            if showOnboarding {
                OnboardingView(onComplete: onCompleteOnboarding)
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
                    .zIndex(190)
            }
        }
        .overlay {
            FormaIntroView(backend: backend, onReady: onSync)
                .transition(.opacity)
                .zIndex(200)
        }
    }

    // MARK: - Today

    private var todayTab: some View {
        ZStack {
            MinimalBackground()
                .ignoresSafeArea()

            DoneHabitPillsBackground(
                habits: habits.filter {
                    $0.completedDayKeys.contains(todayKey)
                        && !stampStagingIds.contains($0.persistentModelID)
                },
                todayKey: todayKey,
                stampNamespace: stampNamespace
            )
            .allowsHitTesting(false)

            CenterPanel(
                habits: habits,
                todayKey: todayKey,
                newHabitTitle: $newHabitTitle,
                newEntryType: $newEntryType,
                metrics: metrics,
                clusters: backend.dashboard?.habitClusters ?? [],
                stampNamespace: stampNamespace,
                stampStagingIds: stampStagingIds,
                onAddHabit: onAddHabit,
                onToggleHabit: onToggleHabit,
                onDeleteHabit: onDeleteHabit
            )
            .padding(.horizontal, 4)

            if showMentorCharacter && backend.isAuthenticated {
                MentorCharacterView(backend: backend, nudge: $mentorNudge)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .allowsHitTesting(true)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .ignoresSafeArea(.keyboard)
            }

            if showMenteeCharacter && backend.isAuthenticated {
                MenteeCharacterView(backend: backend, mentorMissedCount: mentorMissedCount)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .ignoresSafeArea(.keyboard)
            }
        }
        .safeAreaInset(edge: .top) {
            phoneTopStatusBar
                .padding(.horizontal, 12)
                .padding(.top, 6)
                .padding(.bottom, 4)
        }
        .refreshable { onSync() }
    }

    @ViewBuilder
    private var phoneTopStatusBar: some View {
        HStack(spacing: 10) {
            Spacer(minLength: 0)
            ConnectionStatusIcon(backend: backend)
        }
    }

    // MARK: - Stats

    private var statsTab: some View {
        ZStack {
            MinimalBackground().ignoresSafeArea()

            StatsSidebar(
                metrics: metrics,
                dashboard: backend.dashboard,
                backend: backend,
                todayKey: todayKey
            )
            .padding(.horizontal, 16)
        }
        .refreshable { onSync() }
    }

    // MARK: - Friends

    private var friendsTab: some View {
        ZStack {
            MinimalBackground().ignoresSafeArea()

            SettingsPanel(
                mode: .friends,
                metrics: metrics,
                backend: backend,
                habits: habits.filter { $0.entryType == .habit },
                onSync: onSync,
                onFindMentor: onFindMentor,
                onReminderChange: onReminderChange
            )
            .padding(.horizontal, 16)
        }
        .refreshable { onSync() }
    }

    // MARK: - Account

    private var accountTab: some View {
        ZStack {
            MinimalBackground().ignoresSafeArea()

            SettingsPanel(
                mode: .account,
                metrics: metrics,
                backend: backend,
                habits: habits.filter { $0.entryType == .habit },
                onSync: onSync,
                onFindMentor: onFindMentor,
                onReminderChange: onReminderChange
            )
            .padding(.horizontal, 16)
        }
        .refreshable { onSync() }
    }

    // MARK: - Calendar

    private var calendarTab: some View {
        ZStack {
            MinimalBackground().ignoresSafeArea()

            CalendarSheet(habits: habits, onClose: {})
                .padding(.horizontal, 12)
                .padding(.top, 4)
        }
        .refreshable { onSync() }
    }
}
#endif
