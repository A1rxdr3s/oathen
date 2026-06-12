// Sprint 2 — OathenTask domain model.
// Named OathenTask to avoid collision with Swift's built-in Task type.
// Represents a concrete, evidence-optable action item.
// Pure Swift struct. No SwiftData, no Supabase, no persistence.
import Foundation

struct OathenTask: Identifiable, Codable, Equatable, Hashable, Sendable {
    let id: UUID
    // nil = not under a specific project
    var projectID: UUID?
    // nil = not tied to a habit instance
    var habitID: UUID?
    var title: String
    var notes: String?
    var priority: Priority
    var status: TaskStatus
    var dueDate: Date?
    var estimatedMinutes: Int?
    var evidenceRequirement: EvidenceRequirement
    let createdAt: Date
    var updatedAt: Date
    var completedAt: Date?

    init(
        id: UUID = UUID(),
        projectID: UUID? = nil,
        habitID: UUID? = nil,
        title: String,
        notes: String? = nil,
        priority: Priority = .normal,
        status: TaskStatus = .pending,
        dueDate: Date? = nil,
        estimatedMinutes: Int? = nil,
        evidenceRequirement: EvidenceRequirement = .none,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        completedAt: Date? = nil
    ) {
        self.id = id
        self.projectID = projectID
        self.habitID = habitID
        self.title = title
        self.notes = notes
        self.priority = priority
        self.status = status
        self.dueDate = dueDate
        self.estimatedMinutes = estimatedMinutes.map { max(0, $0) }
        self.evidenceRequirement = evidenceRequirement
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.completedAt = completedAt
    }

    var isComplete: Bool { status == .completed }
    var isOverdue: Bool {
        guard let due = dueDate, !isComplete else { return false }
        return due < Date()
    }
}
