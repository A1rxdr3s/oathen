// Sprint 2 — Habit domain model.
// A recurring discipline behaviour tracked daily or on a schedule.
// Pure Swift struct. No SwiftData, no Supabase, no persistence.
import Foundation

struct Habit: Identifiable, Codable, Equatable, Hashable, Sendable {
    let id: UUID
    // nil = not under a specific project
    var projectID: UUID?
    var title: String
    var description: String
    var recurrence: RecurrenceRule
    var priority: Priority
    var evidenceRequirement: EvidenceRequirement
    // Consecutive completions without a miss
    var currentStreak: Int
    // All-time best streak
    var bestStreak: Int
    var status: HabitStatus
    let createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        projectID: UUID? = nil,
        title: String,
        description: String = "",
        recurrence: RecurrenceRule = .daily,
        priority: Priority = .normal,
        evidenceRequirement: EvidenceRequirement = .none,
        currentStreak: Int = 0,
        bestStreak: Int = 0,
        status: HabitStatus = .active,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.projectID = projectID
        self.title = title
        self.description = description
        self.recurrence = recurrence
        self.priority = priority
        self.evidenceRequirement = evidenceRequirement
        self.currentStreak = max(0, currentStreak)
        self.bestStreak = max(0, bestStreak)
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
