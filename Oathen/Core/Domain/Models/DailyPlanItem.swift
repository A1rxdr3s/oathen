// Sprint 3 — DailyPlanItem domain model.
// Represents a single action in the daily plan.
// Pure Swift struct. No SwiftData, no Supabase, no persistence.
import Foundation

// MARK: - DailyPlanItemKind

enum DailyPlanItemKind: String, Codable, Equatable, Hashable, Sendable, CaseIterable {
    case criticalTask
    case habit
    case hydration
    case exercise
    case sleepRoutine
    case review

    var displayName: String {
        switch self {
        case .criticalTask:  "Critical Task"
        case .habit:         "Habit"
        case .hydration:     "Hydration"
        case .exercise:      "Exercise"
        case .sleepRoutine:  "Sleep Routine"
        case .review:        "Review"
        }
    }

    var icon: String {
        switch self {
        case .criticalTask:  "exclamationmark.circle.fill"
        case .habit:         "repeat.circle.fill"
        case .hydration:     "drop.fill"
        case .exercise:      "figure.run.circle.fill"
        case .sleepRoutine:  "moon.fill"
        case .review:        "checklist"
        }
    }

    var isHealthPillar: Bool {
        switch self {
        case .hydration, .exercise, .sleepRoutine: true
        default: false
        }
    }
}

// MARK: - DailyPlanItemStatus

enum DailyPlanItemStatus: String, Codable, Equatable, Hashable, Sendable, CaseIterable {
    case pending
    case completed
    case skipped

    var displayName: String {
        switch self {
        case .pending:   "Pending"
        case .completed: "Completed"
        case .skipped:   "Skipped"
        }
    }

    var isTerminal: Bool { self == .completed || self == .skipped }
    var isComplete: Bool { self == .completed }
}

// MARK: - DailyPlanItem

struct DailyPlanItem: Identifiable, Codable, Equatable, Hashable, Sendable {
    let id: UUID
    var title: String
    var kind: DailyPlanItemKind
    var priority: Priority
    var status: DailyPlanItemStatus
    var evidenceRequirement: EvidenceRequirement
    var estimatedMinutes: Int?      // nil = not time-boxed
    var dueDate: Date?
    var completedAt: Date?

    init(
        id: UUID = UUID(),
        title: String,
        kind: DailyPlanItemKind,
        priority: Priority = .normal,
        status: DailyPlanItemStatus = .pending,
        evidenceRequirement: EvidenceRequirement = .none,
        estimatedMinutes: Int? = nil,
        dueDate: Date? = nil,
        completedAt: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.kind = kind
        self.priority = priority
        self.status = status
        self.evidenceRequirement = evidenceRequirement
        self.estimatedMinutes = estimatedMinutes.map { max(0, $0) }
        self.dueDate = dueDate
        self.completedAt = completedAt
    }

    var isComplete: Bool { status.isComplete }

    // Returns a toggled copy with status flipped between pending and completed.
    func toggled(at now: Date) -> DailyPlanItem {
        var copy = self
        if status == .completed {
            copy.status = .pending
            copy.completedAt = nil
        } else {
            copy.status = .completed
            copy.completedAt = now
        }
        return copy
    }
}
