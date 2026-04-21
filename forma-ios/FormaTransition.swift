import SwiftUI

/// Full-screen 5×8 grid that obscures the auth → dashboard handoff.
///
/// Two drive modes:
/// - **Automatic (default):** tiles cascade in diagonally, hold ~1s, then fade.
///   Used by onboarding completion where we control the full timeline.
/// - **Await-dismiss:** tiles fill the screen nearly instantly, then hold
///   indefinitely until `dismiss` flips true (driven by the login API result).
///   Used for the login/register cascade so the grid shows the moment the
///   button is tapped and stays covering until the network round-trip completes.
struct FormaTransition: View {
    /// When true, tiles fill fast (no staggered cascade) and the view holds
    /// covered until `dismiss` flips true. `onCovered` fires once the grid is
    /// fully opaque so the caller can kick off its background work.
    var awaitDismiss: Bool = false
    /// In `awaitDismiss` mode, flip true to start the fade-out. Ignored when
    /// `awaitDismiss == false` (legacy automatic timeline).
    var dismiss: Bool = false
    var onCovered: (() -> Void)? = nil
    let onComplete: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let rows = 5
    private let cols = 8

    @State private var tileProgress: [CGFloat] = []
    @State private var overlayOpacity: Double = 1
    @State private var hasCovered = false
    @State private var fadeStarted = false

    var body: some View {
        GeometryReader { geo in
            let tileW = geo.size.width  / CGFloat(cols)
            let tileH = geo.size.height / CGFloat(rows)

            ZStack {
                // Solid backdrop. Keeps whatever is behind (dashboard during
                // auth → dashboard handoff) fully hidden while tiles cascade in
                // from scale 0. Fades out with the tiles.
                Color.formaBg
                    .opacity(overlayOpacity)
                    .ignoresSafeArea()

                if !reduceMotion {
                    ForEach(0..<rows * cols, id: \.self) { i in
                        let row = i / cols
                        let col = i % cols
                        let isGold = i.isMultiple(of: 2)
                        Rectangle()
                            .fill(isGold ? Color.formaGold : Color.formaBlue)
                            .frame(width: tileW, height: tileH)
                            .position(
                                x: tileW * (CGFloat(col) + 0.5),
                                y: tileH * (CGFloat(row) + 0.5)
                            )
                            .scaleEffect(tileScale(at: i))
                    }
                    .opacity(overlayOpacity)
                }
            }
            .task { await runTimeline() }
            .onChange(of: dismiss) { _, shouldDismiss in
                guard awaitDismiss, shouldDismiss else { return }
                Task { await startFadeOutIfReady() }
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(overlayOpacity > 0.05)
    }

    private func tileScale(at index: Int) -> CGFloat {
        guard index < tileProgress.count else { return 0 }
        return tileProgress[index]
    }

    @MainActor
    private func runTimeline() async {
        tileProgress = Array(repeating: 0, count: rows * cols)

        if reduceMotion {
            try? await Task.sleep(nanoseconds: 120_000_000)
            hasCovered = true
            onCovered?()
            if awaitDismiss {
                // Parent drives fade-out via `dismiss`. Bail here; `onChange`
                // will call startFadeOutIfReady when it flips.
                if dismiss { await startFadeOutIfReady() }
                return
            }
            try? await Task.sleep(nanoseconds: 200_000_000)
            await performFadeOut()
            return
        }

        // In await-dismiss mode the whole grid snaps in essentially at once so
        // the user perceives an instant cover. A tiny stagger (5ms per diagonal
        // step, vs 40ms in legacy mode) preserves a hint of the cascade
        // character without delaying the cover.
        let diagonalStep: Double = awaitDismiss ? 0.005 : 0.04
        let springResponse: Double = awaitDismiss ? 0.22 : 0.45

        for i in 0..<rows * cols {
            let row = i / cols
            let col = i % cols
            let delay = Double(row + col) * diagonalStep

            Task { @MainActor in
                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                guard i < tileProgress.count else { return }
                withAnimation(.spring(response: springResponse, dampingFraction: 0.78)) {
                    tileProgress[i] = 1
                }
            }
        }

        // Wait for the final tile to seat before declaring the screen covered.
        let coverWait: UInt64 = awaitDismiss ? 220_000_000 : 1_000_000_000
        try? await Task.sleep(nanoseconds: coverWait)
        hasCovered = true
        onCovered?()

        if awaitDismiss {
            // Parent will flip `dismiss` when its work is done.
            if dismiss { await startFadeOutIfReady() }
            return
        }

        await performFadeOut()
    }

    @MainActor
    private func startFadeOutIfReady() async {
        guard hasCovered, !fadeStarted else { return }
        await performFadeOut()
    }

    @MainActor
    private func performFadeOut() async {
        guard !fadeStarted else { return }
        fadeStarted = true
        withAnimation(.easeOut(duration: 0.3)) { overlayOpacity = 0 }
        try? await Task.sleep(nanoseconds: 320_000_000)
        onComplete()
    }
}

#Preview {
    FormaTransition(onComplete: {})
        .frame(width: 800, height: 500)
}
