import SwiftUI

/// Cross-platform hover/press tracker. On macOS the `isPressed` binding tracks
/// `.onHover`; on iOS it tracks the finger-down state of a long-press that
/// starts immediately, plus a drag gesture so releasing outside the view still
/// clears the flag.
///
/// Use this everywhere the macOS code previously called `.onHover { isHovered =
/// $0 }`. On Mac the behavior is identical. On iPhone/iPad the same callback
/// now fires on touch-down and clears on touch-up.
struct PressHoverModifier: ViewModifier {
    @Binding var isPressed: Bool

    func body(content: Content) -> some View {
        #if os(macOS)
        content
            .onHover { isPressed = $0 }
        #else
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !isPressed { isPressed = true }
                    }
                    .onEnded { _ in
                        isPressed = false
                    }
            )
        #endif
    }
}

extension View {
    /// Track "hover on Mac, press on iOS" into a single boolean. See
    /// `PressHoverModifier` for why.
    func pressHover(_ isPressed: Binding<Bool>) -> some View {
        modifier(PressHoverModifier(isPressed: isPressed))
    }
}
