// Sprint 3 — DailyPlan domain model.
// Represents the approved set of commitments for a single day.
// Pure Swift struct. No SwiftData, no Supabase, no persistence.
import Foundation

struct DailyPlan: Identifiable, Codable, Equatable, Hashable, Sendable {
    let id: UUID
    var date: Date
    var contextMode: ContextMode
    var items: [DailyPlanItem]
    var hydrationTargetML: Int          // default 3000 ml
    var exerciseTargetMinutes: Int      // default 45 min
    var sleepTargetHours: Double        // default 7.5 h
    var approvedAt: Date?
    let createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        contextMode: ContextMode = .normal,
        items: [DailyPlanItem] = [],
        hydrationTargetML: Int = 3000,
        exerciseTargetMinutes: Int = 45,
        sleepTargetHours: Double = 7.5,
        approvedAt: Date? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.date = date
        self.contextMode = contextMode
        self.items = items
        self.hydrationTargetML = max(0, hydrationTargetML)
        self.exerciseTargetMinutes = max(0, exerciseTargetMinutes)
        self.sleepTargetHours = max(0, min(24, sleepTargetHours))
        self.approvedAt = approvedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    // MARK: - Filtered views

    var criticalItems: [DailyPlanItem] {
        items.filter { $0.priority == .critical }.sorted { $0.priority.sortOrder < $1.priority.sortOrder }
    }

    var highItems: [DailyPlanItem] {
        items.filter { $0.priority == .high }
    }

    var healthPillarItems: [DailyPlanItem] {
        items.filter { $0.kind.isHealthPillar }
    }

    var taskItems: [DailyPlanItem] {
        items.filter { $0.kind == .criticalTask || $0.kind == .habit }
    }

    // MARK: - Progress

    var completedCount: Int { items.filter(\.isComplete).count }
    var totalCount: Int { items.count }

    var progressFraction: Double {
        totalCount == 0 ? 0.0 : Double(completedCount) / Double(totalCount)
    }

    var completedCriticalCount: Int { criticalItems.filter(\.isComplete).count }
    var totalCriticalCount: Int { criticalItems.count }

    var completedHighCount: Int { highItems.filter(\.isComplete).count }
    var totalHighCount: Int { highItems.count }

    var hydrationCompleted: Bool {
        healthPillarItems.first(where: { $0.kind == .hydration })?.isComplete ?? false
    }

    var exerciseCompleted: Bool {
        healthPillarItems.first(where: { $0.kind == .exercise })?.isComplete ?? false
    }

    var sleepRoutineStarted: Bool {
        healthPillarItems.first(where: { $0.kind == .sleepRoutine })?.isComplete ?? false
    }

    var hydrationTargetLiters: Double { Double(hydrationTargetML) / 1000.0 }
}
