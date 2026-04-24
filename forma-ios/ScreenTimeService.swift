#if os(iOS)
import Foundation
import FamilyControls

/// iOS-only bridge to Family Controls for Screen Time verification.
///
/// This is the Phase 3 scaffold. It handles authorization (and stores the
/// authorization state so the rest of the app can reason about it), but the
/// actual `DeviceActivityMonitor` extension that tallies daily social-media
/// minutes lives in a separate Xcode target and must be added manually —
/// the `project.pbxproj` surgery can't be scripted safely from here.
///
/// Until the monitor extension ships, `.screenTimeSocial` verifications fall
/// through to `.selfReport` inside `VerificationService`. Authorizing here
/// still matters because (a) the user has already consented, which shortens
/// the follow-up prompt when the monitor ships, and (b) a future
/// `VerificationService` update can gate on `isAuthorized` without forcing
/// every caller to handle the not-yet-asked case.
@MainActor
final class ScreenTimeService {
    static let shared = ScreenTimeService()

    /// Mirrors `AuthorizationCenter.shared.authorizationStatus` on the main
    /// actor. Observed by UI to decide whether to re-surface the permission
    /// prompt at onboarding or hide it entirely.
    private(set) var isAuthorized: Bool = {
        AuthorizationCenter.shared.authorizationStatus == .approved
    }()

    private init() {}

    /// Requests individual (self-managed) Family Controls authorization.
    /// Silent on failure — the caller's UI already shows "Not enabled" when
    /// `isAuthorized` stays false, so a thrown error never blocks onboarding.
    func requestAuthorization() async {
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            isAuthorized = AuthorizationCenter.shared.authorizationStatus == .approved
        } catch {
            isAuthorized = false
        }
    }
}
#endif
