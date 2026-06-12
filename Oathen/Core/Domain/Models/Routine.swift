// Sprint 2 — Routine domain model.
// Represents a structured check-in flow (Morning, Night, Weekly, or Custom).
// Steps are embedded value types — no separate persistence relationship needed in Sprint 2.
// Pure Swift struct. No SwiftData, no Supabase, no persistence.
import Foundation

struct Routine: Identifiable, Codable, Equatable, Hashable, Sendable {
    let id: UUID
    var title: String
    var type: RoutineType
    var steps: [RoutineStep]
    var status: RoutineStatus
    let createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        type: RoutineType,
        steps: [RoutineStep] = [],
        status: RoutineStatus = .pending,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.type = type
        self.steps = steps
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var completedStepCount: Int { steps.filter { $0.status == .completed }.count }
    var totalStepCount: Int { steps.count }
    var progressFraction: Double {
        totalStepCount == 0 ? 0 : Double(completedStepCount) / Double(totalStepCount)
    }
}

enum RoutineType: String, Codable, Equatable, Hashable, Sendable, CaseIterable {
    case morningCheckIn
    case nightReview
    case weeklyReview
    case custom

    var displayName: String {
        switch self {
        case .morningCheckIn: "Morning Check-in"
        case .nightReview:    "Night Review"
        case .weeklyReview:   "Weekly Review"
        case .custom:         "Custom Routine"
        }
    }
}
