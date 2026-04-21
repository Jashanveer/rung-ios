import Foundation
#if os(iOS) && canImport(ActivityKit)
import ActivityKit
#endif

/// Shared Live Activity schema for the "streak in progress" activity.
/// Lives in the main app so both the app (which starts / updates activities)
/// and the Widget Extension (which renders them) can import it.
#if os(iOS) && canImport(ActivityKit)
@available(iOS 16.1, *)
struct StreakActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var doneToday: Int
        public var totalToday: Int
        public var currentStreak: Int
        public var todayKey: String

        public init(doneToday: Int, totalToday: Int, currentStreak: Int, todayKey: String) {
            self.doneToday = doneToday
            self.totalToday = totalToday
            self.currentStreak = currentStreak
            self.todayKey = todayKey
        }

        public var progress: Double {
            totalToday > 0 ? Double(doneToday) / Double(totalToday) : 0
        }
    }

    public var userName: String

    public init(userName: String) { self.userName = userName }
}
#endif
