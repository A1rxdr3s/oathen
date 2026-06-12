// Sprint 2 — Priority value object.
// Shared priority level used by Goal, Project, Habit, and OathenTask.
// No UIKit, no SwiftUI, no persistence.
import Foundation

enum Priority: String, Codable, Equatable, Hashable, Sendable, CaseIterable {
    case critical
    case high
    case normal
    case low
    case blocked

    var displayName: String {
        switch self {
        case .critical: "Critical"
        case .high:     "High"
        case .normal:   "Normal"
        case .low:      "Low"
        case .blocked:  "Blocked"
        }
    }

    // Lower sortOrder = shown/addressed first.
    var sortOrder: Int {
        switch self {
        case .critical: 0
        case .high:     1
        case .normal:   2
        case .low:      3
        case .blocked:  4
        }
    }

    var isActionable: Bool { self != .blocked }
}
