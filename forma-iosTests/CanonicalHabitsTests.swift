import Testing
import Foundation
@testable import forma_ios

struct CanonicalHabitsTests {

    @Test func directAliasMatch() {
        #expect(CanonicalHabits.match(userTitle: "run")?.key == "run")
        #expect(CanonicalHabits.match(userTitle: "Running")?.key == "run")
        #expect(CanonicalHabits.match(userTitle: "MEDITATE")?.key == "meditate")
    }

    @Test func stopwordsAreStripped() {
        // "morning" / "evening" / "daily" should collapse to the core noun.
        #expect(CanonicalHabits.match(userTitle: "morning run")?.key == "run")
        #expect(CanonicalHabits.match(userTitle: "evening jog")?.key == "run")
        #expect(CanonicalHabits.match(userTitle: "daily meditation")?.key == "meditate")
    }

    @Test func tokenSetMatchesMultiWordAliases() {
        // "gym sesh" has "gym" as a known alias; extra words shouldn't block it.
        #expect(CanonicalHabits.match(userTitle: "gym sesh")?.key == "workout")
        #expect(CanonicalHabits.match(userTitle: "5k morning run")?.key == "run")
        #expect(CanonicalHabits.match(userTitle: "yoga flow")?.key == "yoga")
    }

    @Test func fuzzyMatchToleratesTypos() {
        // Single-character typo within Levenshtein ≤ 2 threshold.
        #expect(CanonicalHabits.match(userTitle: "runnin")?.key == "run")
        #expect(CanonicalHabits.match(userTitle: "meditaiton")?.key == "meditate")
    }

    @Test func nonsenseReturnsNil() {
        #expect(CanonicalHabits.match(userTitle: "asdkfjaldkfjsdf") == nil)
        #expect(CanonicalHabits.match(userTitle: "") == nil)
        #expect(CanonicalHabits.match(userTitle: "   ") == nil)
    }

    @Test func punctuationAndCasingNormalized() {
        #expect(CanonicalHabits.match(userTitle: "Run!!!")?.key == "run")
        #expect(CanonicalHabits.match(userTitle: "yoga, stretching")?.key == "yoga")
    }

    @Test func canonicalKeysAreStableAndUnique() {
        // If this test ever fails, someone renamed a canonical key in place —
        // which would strand the mapping on every device that persisted the
        // old key. Add a new key, don't mutate an existing one.
        let keys = CanonicalHabits.all.map(\.key)
        #expect(Set(keys).count == keys.count, "duplicate canonical keys")
        #expect(keys.contains("run"))
        #expect(keys.contains("workout"))
        #expect(keys.contains("meditate"))
    }

    @Test func levenshteinMatchesKnownDistances() {
        #expect(CanonicalHabits.levenshtein("kitten", "sitting") == 3)
        #expect(CanonicalHabits.levenshtein("book", "back") == 2)
        #expect(CanonicalHabits.levenshtein("", "hello") == 5)
        #expect(CanonicalHabits.levenshtein("same", "same") == 0)
    }
}

struct HabitMigrationTests {

    @Test func legacyInitDefaultsNewVerificationFields() {
        // Simulates a habit created by an older build that didn't know about
        // verification. The new fields must take their defaults without
        // forcing callers to pass them explicitly.
        let habit = Habit(
            title: "Run",
            entryType: .habit,
            createdAt: Date(),
            completedDayKeys: ["2026-04-20"]
        )
        #expect(habit.verificationTier == .selfReport)
        #expect(habit.verificationSource == nil)
        #expect(habit.verificationParam == nil)
        #expect(habit.canonicalKey == nil)
    }

    @Test func typedAccessorsRoundTripThroughRawStorage() {
        let habit = Habit(title: "Run")
        habit.verificationTier = .auto
        habit.verificationSource = .healthKitWorkout
        #expect(habit.verificationTierRaw == "auto")
        #expect(habit.verificationSourceRaw == "healthKitWorkout")
        #expect(habit.verificationTier == .auto)
        #expect(habit.verificationSource == .healthKitWorkout)
    }

    @Test func unknownRawValuesFallBackSafely() {
        // A build that persisted a verification tier we don't recognize
        // (future build wrote it) must degrade gracefully, not crash.
        let habit = Habit(title: "Run")
        habit.verificationTierRaw = "futurePlatinumTier"
        habit.verificationSourceRaw = "quantumVerifier"
        #expect(habit.verificationTier == .selfReport)
        #expect(habit.verificationSource == nil)
    }
}
