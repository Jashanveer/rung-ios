import SwiftUI

// MARK: - Rung brand palette
extension Color {
    /// Deep warm dark — scene / launch backdrop.
    static let rungBg     = Color(red: 0x14/255, green: 0x11/255, blue: 0x0E/255)
    /// Warm beige — icon tile fill.
    static let rungTile   = Color(red: 0xD8/255, green: 0xD3/255, blue: 0xC4/255)
    /// Near-black ink — rails and ghost rungs.
    static let rungRail   = Color(red: 0x2A/255, green: 0x25/255, blue: 0x20/255)
    /// Terracotta — main rung, tagline, primary accent throughout the UI.
    static let rungAccent = Color(red: 0xC9/255, green: 0x64/255, blue: 0x42/255)
    /// Soft gold — glow under the main rung at landing.
    static let rungGold   = Color(red: 0xFF/255, green: 0xD4/255, blue: 0x7A/255)
    /// Cream — wordmark text on dark scenes.
    static let rungText   = Color(red: 0xF3/255, green: 0xE9/255, blue: 0xD2/255)
    /// Subtle white tint — muted overlay primitive.
    static let rungGrey   = Color.white.opacity(0.08)
}

/// Squircle ladder icon: two dark rails sit on a warm beige tile, a single
/// terracotta rung crosses between them, ghost rungs hint at the climb above
/// and below. The `time` parameter drives the staged build animation; pass
/// `nil` (default) for the completed static icon used in nav bars, headers,
/// and the auth card slot.
///
/// Geometry source-of-truth is the design handoff
/// (`Rung Launch Animation.html` → `rung-anim.jsx`). Coordinates are authored
/// in the design's 1024-unit canvas and scaled to `size` here.
struct RungIconView: View {
    let size: CGFloat
    /// Seconds into the 3.5s launch sequence. `nil` (default) renders the
    /// completed icon, which is what every static use site wants.
    var time: Double? = nil

    var body: some View {
        let t = time ?? 3.5
        let s = size / 1024

        // Tile-level transforms.
        let tileOpacity = Self.anim(from: 0, to: 1, start: 0.0, end: 0.30, ease: .easeOutCubic, t: t)
        let tileScale   = Self.anim(from: 0.92, to: 1.0, start: 0.0, end: 0.42, ease: .easeOutBack, t: t)
        let landBounce: Double = {
            guard t >= 2.60 && t <= 2.95 else { return 1 }
            return 1 + sin((t - 2.60) / 0.35 * .pi) * 0.012
        }()

        // Layer-level animated values.
        let groundProgress     = Self.anim(from: 0, to: 1, start: 0.30, end: 0.80, ease: .easeInOutQuart, t: t)
        let leftRailTop        = Self.anim(from: 904, to: 120, start: 0.80, end: 1.45, ease: .easeOutCubic, t: t)
        let rightRailTop       = Self.anim(from: 904, to: 120, start: 0.95, end: 1.60, ease: .easeOutCubic, t: t)
        let ghostTopOpacity    = Self.anim(from: 0, to: 0.18, start: 1.55, end: 1.95, ease: .easeOutCubic, t: t)
        let ghostBottomOpacity = Self.anim(from: 0, to: 0.18, start: 1.70, end: 2.10, ease: .easeOutCubic, t: t)
        let rungY: Double      = t >= 2.05 ? Self.anim(from: -120, to: 472, start: 2.05, end: 2.65, ease: .easeOutBack, t: t) : -120
        let rungOpacity: Double = t >= 2.05 ? Self.anim(from: 0, to: 1, start: 2.05, end: 2.30, ease: .easeOutCubic, t: t) : 0
        let glowOpacity: Double = {
            guard t >= 2.65 && t <= 3.20 else { return 0 }
            return sin((t - 2.65) / 0.55 * .pi) * 0.55
        }()

        return ZStack(alignment: .topLeading) {
            // Tile background fills the entire 1024² canvas.
            Color.rungTile

            // Ground line — thin dark stroke that "draws" left → right.
            if groundProgress > 0 {
                RoundedRectangle(cornerRadius: 3 * s)
                    .fill(Color.rungRail)
                    .frame(width: (904 - 120) * groundProgress * s, height: 6 * s)
                    .offset(x: 120 * s, y: (904 + 30 - 3) * s)
            }

            // Left rail — rises from the ground line up to RAIL_TOP.
            if t > 1.0 {
                let railH = (904 - leftRailTop) * s
                RoundedRectangle(cornerRadius: 8 * s)
                    .fill(Color.rungRail)
                    .frame(width: 60 * s, height: railH)
                    .offset(x: 240 * s, y: leftRailTop * s)
            }

            // Right rail — staggered ~150ms behind the left rail.
            if t > 1.15 {
                let railH = (904 - rightRailTop) * s
                RoundedRectangle(cornerRadius: 8 * s)
                    .fill(Color.rungRail)
                    .frame(width: 60 * s, height: railH)
                    .offset(x: 724 * s, y: rightRailTop * s)
            }

            // Top ghost rung.
            RoundedRectangle(cornerRadius: 8 * s)
                .fill(Color.rungRail)
                .frame(width: 624 * s, height: 60 * s)
                .opacity(ghostTopOpacity)
                .offset(x: 200 * s, y: 252 * s)

            // Bottom ghost rung.
            RoundedRectangle(cornerRadius: 8 * s)
                .fill(Color.rungRail)
                .frame(width: 624 * s, height: 60 * s)
                .opacity(ghostBottomOpacity)
                .offset(x: 200 * s, y: 712 * s)

            // Soft glow under the main rung at landing.
            if glowOpacity > 0 {
                RadialGradient(
                    colors: [Color.rungGold.opacity(0.9), Color.rungGold.opacity(0)],
                    center: .center,
                    startRadius: 0,
                    endRadius: 400 * s
                )
                .frame(width: 800 * s, height: 240 * s)
                .opacity(glowOpacity)
                .offset(x: (512 - 400) * s, y: (472 + 40 - 120) * s)
                .allowsHitTesting(false)
            }

            // Main rung — drops in from above with overshoot.
            if t >= 2.05 {
                RoundedRectangle(cornerRadius: 10 * s)
                    .fill(Color.rungAccent)
                    .frame(width: 624 * s, height: 80 * s)
                    .opacity(rungOpacity)
                    .offset(x: 200 * s, y: rungY * s)
            }
        }
        .frame(width: 1024 * s, height: 1024 * s)
        .clipShape(RoundedRectangle(cornerRadius: 230 * s))
        .overlay(
            // Inner stroke — same squircle, hairline dark border.
            RoundedRectangle(cornerRadius: 230 * s)
                .stroke(Color.black.opacity(0.10), lineWidth: 2 * s)
        )
        .frame(width: size, height: size)
        .scaleEffect(tileScale * landBounce)
        .opacity(tileOpacity)
    }

    // MARK: - Easing
    private enum Ease {
        case easeOutCubic, easeOutBack, easeInOutQuart
        func apply(_ t: Double) -> Double {
            switch self {
            case .easeOutCubic:
                return 1 - pow(1 - t, 3)
            case .easeOutBack:
                let c1 = 1.70158, c3 = c1 + 1
                return 1 + c3 * pow(t - 1, 3) + c1 * pow(t - 1, 2)
            case .easeInOutQuart:
                return t < 0.5 ? 8 * t * t * t * t : 1 - pow(-2 * t + 2, 4) / 2
            }
        }
    }

    private static func anim(from a: Double, to b: Double, start: Double, end: Double, ease: Ease, t: Double) -> Double {
        if t <= start { return a }
        if t >= end { return b }
        let local = (t - start) / (end - start)
        return a + (b - a) * ease.apply(local)
    }
}

// MARK: - Previews
#Preview("Rung icon — complete") {
    RungIconView(size: 240)
        .padding(40)
        .background(Color.rungBg)
}

#Preview("Rung icon — frozen mid-build") {
    VStack(spacing: 24) {
        ForEach([0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5], id: \.self) { t in
            HStack {
                Text(String(format: "t=%.1fs", t))
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.5))
                RungIconView(size: 80, time: t)
            }
        }
    }
    .padding(40)
    .background(Color.rungBg)
}
