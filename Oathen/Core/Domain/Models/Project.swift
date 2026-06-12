// Sprint 2 — Project domain model.
// A structured workstream under a Goal (optional).
// Pure Swift struct. No SwiftData, no Supabase, no persistence.
import Foundation

struct Project: Identifiable, Codable, Equatable, Hashable, Sendable {
    let id: UUID
    // nil = standalone project, not under a goal
    var goalID: UUID?
    var title: String
    var description: String
    var status: ProjectStatus
    var priority: Priority
    var startDate: Date?
    var targetDate: Date?
    var tags: [String]
    var taskIDs: [UUID]
    var habitIDs: [UUID]
    let createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        goalID: UUID? = nil,
        title: String,
        description: String = "",
        status: ProjectStatus = .active,
        priority: Priority = .normal,
        startDate: Date? = nil,
        targetDate: Date? = nil,
        tags: [String] = [],
        taskIDs: [UUID] = [],
        habitIDs: [UUID] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.goalID = goalID
        self.title = title
        self.description = description
        self.status = status
        self.priority = priority
        self.startDate = startDate
        self.targetDate = targetDate
        self.tags = tags
        self.taskIDs = taskIDs
        self.habitIDs = habitIDs
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
