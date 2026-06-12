// Sprint 2 — ContextMode domain model.
// Represents the user's operational context, which modulates score targets
// and discipline expectations. No UIKit, no SwiftUI, no persistence.
import Foundation

enum ContextMode: String, Codable, Equatable, Hashable, Sendable, CaseIterable {
    case normal
    case travel
    case tour
    case vacation
    case illnessRecovery
    case restDay
    case ultraStrict
    case postTravelRecovery

    var displayName: String {
        switch self {
        case .normal:             "Normal"
        case .travel:             "Travel"
        case .tour:               "Tour"
        case .vacation:           "Vacation"
        case .illnessRecovery:    "Illness Recovery"
        case .restDay:            "Rest Day"
        case .ultraStrict:        "Ultra Strict"
        case .postTravelRecovery: "Post-Travel Recovery"
        }
    }

    var shortDescription: String {
        switch self {
        case .normal:             "Standard discipline targets apply."
        case .travel:             "Adjusted targets for travel days."
        case .tour:               "Performance mode — full schedule active."
        case .vacation:           "Minimal targets, recovery focus."
        case .illnessRecovery:    "Health first. Reduced targets."
        case .restDay:            "Intentional rest. Core habits only."
        case .ultraStrict:        "Maximum accountability. No exceptions."
        case .postTravelRecovery: "Rebalancing after travel. Gradual re-entry."
        }
    }

    // Multiplier applied to raw score for context adjustment.
    // ultraStrict rewards effort; illness/vacation reduces pressure.
    var scoreMultiplier: Double {
        switch self {
        case .ultraStrict:        1.10
        case .normal, .tour:      1.00
        case .postTravelRecovery: 0.90
        case .travel:             0.85
        case .restDay:            0.80
        case .vacation:           0.70
        case .illnessRecovery:    0.60
        }
    }

    var isRestrictive: Bool { self == .ultraStrict }
    var isReduced: Bool { scoreMultiplier < 1.0 }
}
