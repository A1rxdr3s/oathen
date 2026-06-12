// Sprint 1 — Design tokens: colors
// These are PLACEHOLDER tokens, not final branding.
// Final brand colors are NOT determined yet.
import SwiftUI

enum OathenColors {

    // MARK: — Brand / Accent
    /// Discipline accent — deep indigo placeholder.
    /// Not final brand color — Sprint 1 placeholder only.
    static let accent = Color(red: 0.310, green: 0.275, blue: 0.898)    // #4F46E5 approx

    // MARK: — Status
    static let critical = Color.red
    static let high     = Color.orange
    static let normal   = Color.blue
    static let low      = Color.secondary
    static let success  = Color.green
    static let warning  = Color.yellow

    // MARK: — Health pillars
    static let exercise   = Color.green
    static let hydration  = Color(red: 0.220, green: 0.741, blue: 0.973)  // #38BDF8
    static let sleep      = Color(red: 0.388, green: 0.400, blue: 0.945)  // #6366F1

    // MARK: — Score ranges
    static let scoreHigh = Color.green    // 80–100
    static let scoreMid  = Color.orange   // 50–79
    static let scoreLow  = Color.red      // 0–49

    // MARK: — Adaptive surfaces (cross-platform)
    static var cardBackground: Color {
        #if canImport(UIKit)
        Color(UIColor.secondarySystemBackground)
        #else
        Color(NSColor.controlBackgroundColor)
        #endif
    }

    static var screenBackground: Color {
        #if canImport(UIKit)
        Color(UIColor.systemBackground)
        #else
        Color(NSColor.windowBackgroundColor)
        #endif
    }

    static var tertiaryFill: Color {
        #if canImport(UIKit)
        Color(UIColor.tertiarySystemFill)
        #else
        Color(NSColor.quaternaryLabelColor)
        #endif
    }
}
