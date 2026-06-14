import Foundation
import SwiftData

@Model
final class PersistentNightReview {
    var id: UUID
    /// Original NightReview.id — preserved for stable round-trip mapping.
    var domainID: UUID
    var date: Date
    /// JSON-encoded arrays of UUID strings — avoids SwiftData [UUID] compatibility issues.
    var completedCriticalTaskIDsJSON: String
    var missedCriticalTaskIDsJSON: String
    var completedHabitIDsJSON: String
    var missedHabitIDsJSON: String
    var hydrationCompleted: Bool
    var exerciseCompleted: Bool
    var sleepRoutineStarted: Bool
    var failureReason: String?
    var excuseDetected: Bool
    var recoveryPlan: String?
    var completedAt: Date?
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        domainID: UUID,
        date: Date,
        completedCriticalTaskIDsJSON: String,
        missedCriticalTaskIDsJSON: String,
        completedHabitIDsJSON: String,
        missedHabitIDsJSON: String,
        hydrationCompleted: Bool,
        exerciseCompleted: Bool,
        sleepRoutineStarted: Bool,
        failureReason: String?,
        excuseDetected: Bool,
        recoveryPlan: String?,
        completedAt: Date?,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.domainID = domainID
        self.date = date
        self.completedCriticalTaskIDsJSON = completedCriticalTaskIDsJSON
        self.missedCriticalTaskIDsJSON = missedCriticalTaskIDsJSON
        self.completedHabitIDsJSON = completedHabitIDsJSON
        self.missedHabitIDsJSON = missedHabitIDsJSON
        self.hydrationCompleted = hydrationCompleted
        self.exerciseCompleted = exerciseCompleted
        self.sleepRoutineStarted = sleepRoutineStarted
        self.failureReason = failureReason
        self.excuseDetected = excuseDetected
        self.recoveryPlan = recoveryPlan
        self.completedAt = completedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
