// Sprint 1 — Static placeholder values used in UI previews.
// NOT real data. NOT real models.
// Will be replaced by domain models in Sprint 2.
import Foundation

enum PlaceholderData {

    // Score
    static let disciplineScore       = 74
    static let scoreProgress: Double = 0.74

    // Hydration
    static let hydrationCurrent: Double = 1.8
    static let hydrationGoal: Double    = 3.0
    static var hydrationProgress: Double { hydrationCurrent / hydrationGoal }

    // Exercise
    static let exerciseMinutes: Int    = 18
    static let exerciseGoal: Int       = 45
    static var exerciseProgress: Double { Double(exerciseMinutes) / Double(exerciseGoal) }

    // Sleep
    static let sleepHours: Double      = 7.2
    static let sleepGoal: Double       = 7.5
    static var sleepProgress: Double   { min(sleepHours / sleepGoal, 1.0) }

    // Tasks
    static let criticalTaskTitle       = "Placeholder Critical Task"
    static let highTaskTitle           = "Placeholder High Priority Task"

    // Pre-formatted decimal strings (Swift 6: specifier: renamed — use String(format:))
    static let hydrationCurrentStr = String(format: "%.1f", hydrationCurrent)
    static let hydrationGoalStr    = String(format: "%.1f", hydrationGoal)
    static let sleepHoursStr       = String(format: "%.1f", sleepHours)
    static let sleepGoalStr        = String(format: "%.1f", sleepGoal)

    // Goals
    static let goalTitles = [
        "Improve physical condition",
        "Finish DJHQ",
        "Prepare music release"
    ]

    // Coach
    static let coachNudge = "The accountability Coach connects after the daily routine is stable."

    // Context
    static let contextMode             = "Normal"
    static let streakDays              = 12
    static let todayDateString         = "Thursday, Jun 11"
}
