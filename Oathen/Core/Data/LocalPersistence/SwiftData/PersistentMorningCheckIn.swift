import Foundation
import SwiftData

@Model
final class PersistentMorningCheckIn {
    var id: UUID
    /// Original MorningCheckIn.id — preserved for stable round-trip mapping.
    var domainID: UUID
    var date: Date
    var sleepHours: Double?
    var energyLevelRaw: String
    var focusLevelRaw: String
    var moodRaw: String
    var mainObstacle: String
    var selectedContextModeRaw: String
    var confirmedHydrationGoal: Bool
    var confirmedExerciseGoal: Bool
    /// JSON-encoded array of UUID strings — avoids SwiftData [UUID] compatibility issues.
    var confirmedCriticalTaskIDsJSON: String
    var completedAt: Date?
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        domainID: UUID,
        date: Date,
        sleepHours: Double?,
        energyLevelRaw: String,
        focusLevelRaw: String,
        moodRaw: String,
        mainObstacle: String,
        selectedContextModeRaw: String,
        confirmedHydrationGoal: Bool,
        confirmedExerciseGoal: Bool,
        confirmedCriticalTaskIDsJSON: String,
        completedAt: Date?,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.domainID = domainID
        self.date = date
        self.sleepHours = sleepHours
        self.energyLevelRaw = energyLevelRaw
        self.focusLevelRaw = focusLevelRaw
        self.moodRaw = moodRaw
        self.mainObstacle = mainObstacle
        self.selectedContextModeRaw = selectedContextModeRaw
        self.confirmedHydrationGoal = confirmedHydrationGoal
        self.confirmedExerciseGoal = confirmedExerciseGoal
        self.confirmedCriticalTaskIDsJSON = confirmedCriticalTaskIDsJSON
        self.completedAt = completedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
