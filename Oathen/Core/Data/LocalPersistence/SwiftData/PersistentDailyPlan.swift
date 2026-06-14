import Foundation
import SwiftData

@Model
final class PersistentDailyPlan {
    var id: UUID
    /// Original DailyPlan.id — preserved for stable round-trip mapping.
    var domainID: UUID
    var date: Date
    var contextModeRaw: String
    var hydrationTargetML: Int
    var exerciseTargetMinutes: Int
    var sleepTargetHours: Double
    var approvedAt: Date?
    var createdAt: Date
    var updatedAt: Date

    @Relationship(deleteRule: .cascade) var items: [PersistentDailyPlanItem]

    init(
        id: UUID = UUID(),
        domainID: UUID,
        date: Date,
        contextModeRaw: String,
        hydrationTargetML: Int,
        exerciseTargetMinutes: Int,
        sleepTargetHours: Double,
        approvedAt: Date?,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.domainID = domainID
        self.date = date
        self.contextModeRaw = contextModeRaw
        self.hydrationTargetML = hydrationTargetML
        self.exerciseTargetMinutes = exerciseTargetMinutes
        self.sleepTargetHours = sleepTargetHours
        self.approvedAt = approvedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.items = []
    }
}
