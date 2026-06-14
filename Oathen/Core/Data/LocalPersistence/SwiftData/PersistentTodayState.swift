import Foundation
import SwiftData

@Model
final class PersistentTodayState {
    var id: UUID
    /// Normalized start-of-day for predicate-based date lookup.
    var dayStart: Date
    var date: Date
    var contextModeRaw: String
    var createdAt: Date
    var updatedAt: Date

    @Relationship(deleteRule: .cascade) var dailyPlan: PersistentDailyPlan?
    @Relationship(deleteRule: .cascade) var morningCheckIn: PersistentMorningCheckIn?
    @Relationship(deleteRule: .cascade) var nightReview: PersistentNightReview?

    init(
        id: UUID = UUID(),
        dayStart: Date,
        date: Date,
        contextModeRaw: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.dayStart = dayStart
        self.date = date
        self.contextModeRaw = contextModeRaw
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
