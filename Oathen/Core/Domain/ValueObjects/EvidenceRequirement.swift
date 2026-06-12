// Sprint 2 — EvidenceRequirement value object.
// Describes whether evidence must accompany task or habit completion.
// No photo storage, no AI validation — concept only in Sprint 2.
import Foundation

enum EvidenceRequirement: String, Codable, Equatable, Hashable, Sendable, CaseIterable {
    case none
    case optional
    case required

    var displayName: String {
        switch self {
        case .none:     "None"
        case .optional: "Optional"
        case .required: "Required"
        }
    }

    var isRequired: Bool { self == .required }
    var isOptionalOrRequired: Bool { self != .none }
}
