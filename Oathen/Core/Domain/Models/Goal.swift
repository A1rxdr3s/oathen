// Sprint 2 — Goal domain model.
// Represents a major personal commitment — an oath.
// Pure Swift struct. No SwiftData, no Supabase, no persistence.
import Foundation

struct Goal: Identifiable, Codable, Equatable, Hashable, Sendable {
    let id: UUID
    var title: String
    var description: String
    var category: GoalCategory
    var targetDate: Date?
    var status: GoalStatus
    var priority: Priority
    // 0.0 – 100.0 — computed by score engine in Sprint 3
    var progressPercent: Double
    var evidenceRequired: Bool
    // Hidden from accountability partner when true
    var isPrivate: Bool
    var projectIDs: [UUID]
    var tags: [String]
    let createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        description: String = "",
        category: GoalCategory = .personal,
        targetDate: Date? = nil,
        status: GoalStatus = .active,
        priority: Priority = .normal,
        progressPercent: Double = 0,
        evidenceRequired: Bool = false,
        isPrivate: Bool = false,
        projectIDs: [UUID] = [],
        tags: [String] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.targetDate = targetDate
        self.status = status
        self.priority = priority
        self.progressPercent = max(0, min(100, progressPercent))
        self.evidenceRequired = evidenceRequired
        self.isPrivate = isPrivate
        self.projectIDs = projectIDs
        self.tags = tags
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

enum GoalCategory: String, Codable, Equatable, Hashable, Sendable, CaseIterable {
    case health
    case work
    case creative
    case personal
    case fitness
    case custom

    var displayName: String {
        switch self {
        case .health:   "Health"
        case .work:     "Work"
        case .creative: "Creative"
        case .personal: "Personal"
        case .fitness:  "Fitness"
        case .custom:   "Custom"
        }
    }
}
