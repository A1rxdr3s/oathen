import Foundation
import SwiftData

@Model
final class PersistentDailyPlanItem {
    var id: UUID
    /// Original DailyPlanItem.id — preserved for stable round-trip mapping.
    var domainID: UUID
    var title: String
    var kindRaw: String
    var priorityRaw: String
    var statusRaw: String
    var evidenceRequirementRaw: String
    var estimatedMinutes: Int?
    var dueDate: Date?
    var completedAt: Date?
    /// Position in the parent plan's ordered item list.
    var sortOrder: Int

    init(
        id: UUID = UUID(),
        domainID: UUID,
        title: String,
        kindRaw: String,
        priorityRaw: String,
        statusRaw: String,
        evidenceRequirementRaw: String,
        estimatedMinutes: Int?,
        dueDate: Date?,
        completedAt: Date?,
        sortOrder: Int
    ) {
        self.id = id
        self.domainID = domainID
        self.title = title
        self.kindRaw = kindRaw
        self.priorityRaw = priorityRaw
        self.statusRaw = statusRaw
        self.evidenceRequirementRaw = evidenceRequirementRaw
        self.estimatedMinutes = estimatedMinutes
        self.dueDate = dueDate
        self.completedAt = completedAt
        self.sortOrder = sortOrder
    }
}
