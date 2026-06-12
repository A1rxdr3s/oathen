// Sprint 1 — Design tokens: typography
// Placeholder tokens only — not final brand typography decisions.
import SwiftUI

enum OathenTypography {

    // MARK: — Display (score / metrics)
    /// Use SF Pro Rounded for numbers that represent achievements or scores.
    static let scoreDisplay  = Font.system(size: 72, weight: .bold,     design: .rounded)
    static let metricDisplay = Font.system(size: 48, weight: .bold,     design: .rounded)

    // MARK: — Headings
    static let screenTitle   = Font.system(size: 34, weight: .bold,     design: .default)
    static let headingLarge  = Font.system(size: 22, weight: .semibold, design: .default)
    static let headingMedium = Font.system(size: 17, weight: .semibold, design: .default)
    static let headingSmall  = Font.system(size: 15, weight: .medium,   design: .default)

    // MARK: — Body
    static let bodyLarge     = Font.system(size: 17, weight: .regular,  design: .default)
    static let bodyMedium    = Font.system(size: 15, weight: .regular,  design: .default)
    static let bodySmall     = Font.system(size: 13, weight: .regular,  design: .default)

    // MARK: — Labels / tags
    static let priorityLabel = Font.system(size: 11, weight: .bold,     design: .default)
    static let tagLabel      = Font.system(size: 11, weight: .medium,   design: .default)

    // MARK: — Monospaced (metrics, scores)
    static let monoData      = Font.system(size: 13, weight: .regular,  design: .monospaced)
}
