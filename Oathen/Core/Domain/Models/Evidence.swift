// Sprint 2 — Evidence domain model.
// Concept-only: models the evidence lifecycle without photo storage or AI validation.
// Photo storage: Sprint 5. AI validation: Sprint 7.
// Pure Swift struct. No SwiftData, no Supabase, no persistence.
import Foundation

struct Evidence: Identifiable, Codable, Equatable, Hashable, Sendable {
    let id: UUID
    var linkedEntityID: UUID
    var linkedEntityType: EvidenceEntityType
    var type: EvidenceType
    // true = stays on device; false = user opted into cloud sync
    var localOnly: Bool
    var validationStatus: EvidenceValidationStatus
    let createdAt: Date
    var notes: String?

    init(
        id: UUID = UUID(),
        linkedEntityID: UUID,
        linkedEntityType: EvidenceEntityType,
        type: EvidenceType,
        localOnly: Bool = true,
        validationStatus: EvidenceValidationStatus = .pending,
        createdAt: Date = Date(),
        notes: String? = nil
    ) {
        self.id = id
        self.linkedEntityID = linkedEntityID
        self.linkedEntityType = linkedEntityType
        self.type = type
        self.localOnly = localOnly
        self.validationStatus = validationStatus
        self.createdAt = createdAt
        self.notes = notes
    }

    var isResolved: Bool { validationStatus.isResolved }
    var isAccepted: Bool { validationStatus == .accepted }
}

enum EvidenceEntityType: String, Codable, Equatable, Hashable, Sendable, CaseIterable {
    case task
    case habit
    case routineStep

    var displayName: String {
        switch self {
        case .task:        "Task"
        case .habit:       "Habit"
        case .routineStep: "Routine Step"
        }
    }
}

enum EvidenceType: String, Codable, Equatable, Hashable, Sendable, CaseIterable {
    case photo
    case metric
    case manual
    case aiValidated

    var displayName: String {
        switch self {
        case .photo:       "Photo"
        case .metric:      "Metric"
        case .manual:      "Manual"
        case .aiValidated: "AI Validated"
        }
    }

    // aiValidated requires Sprint 7. All others are Sprint 5+.
    var requiresAI: Bool { self == .aiValidated }
    var isSafeForLocalOnly: Bool { self != .aiValidated }
}

enum EvidenceValidationStatus: String, Codable, Equatable, Hashable, Sendable, CaseIterable {
    case pending
    case accepted
    case rejected
    case manualOverride

    var displayName: String {
        switch self {
        case .pending:        "Pending"
        case .accepted:       "Accepted"
        case .rejected:       "Rejected"
        case .manualOverride: "Manual Override"
        }
    }

    var isResolved: Bool {
        switch self {
        case .pending:                             false
        case .accepted, .rejected, .manualOverride: true
        }
    }
}
