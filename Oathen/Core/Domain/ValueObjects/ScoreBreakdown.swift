// Sprint 2 — ScoreBreakdown value object.
// Component scores that sum to the DisciplineScore total.
// Max total: 100 points (before context mode multiplier).
// Real calculation engine: Sprint 3.
import Foundation

struct ScoreBreakdown: Codable, Equatable, Hashable, Sendable {
    // Max 40: critical task completion ratio × 40
    var criticalTaskScore: Int

    // Max 20: high task completion ratio × 20
    var highTaskScore: Int

    // Max 20: habit completion — placeholder until Sprint 3
    var habitScore: Int

    // Max 7: hydration goal met
    var hydrationScore: Int

    // Max 7: exercise goal met
    var exerciseScore: Int

    // Max 6: sleep goal met
    var sleepScore: Int

    var total: Int {
        criticalTaskScore + highTaskScore + habitScore +
        hydrationScore + exerciseScore + sleepScore
    }

    // MARK: - Presets

    static let zero = ScoreBreakdown(
        criticalTaskScore: 0,
        highTaskScore: 0,
        habitScore: 0,
        hydrationScore: 0,
        exerciseScore: 0,
        sleepScore: 0
    )

    static let perfect = ScoreBreakdown(
        criticalTaskScore: 40,
        highTaskScore: 20,
        habitScore: 20,
        hydrationScore: 7,
        exerciseScore: 7,
        sleepScore: 6
    )
}
