// Sprint 2 — DisciplineScorePolicy.
// Placeholder rule-based scoring. No HealthKit, no AI, no real analytics.
// Full scoring engine: Sprint 3.
// Inputs are simple booleans and counts; real inputs will come from Sprint 3 domain.
import Foundation

enum DisciplineScorePolicy {

    // MARK: - Input / Output

    struct Input: Sendable {
        var completedCriticalTasks: Int
        var totalCriticalTasks: Int
        var completedHighTasks: Int
        var totalHighTasks: Int
        var hydrationCompleted: Bool
        var exerciseCompleted: Bool
        var sleepCompleted: Bool
        var contextMode: ContextMode
    }

    struct Output: Sendable {
        var total: Int               // 0 – 100
        var breakdown: ScoreBreakdown
    }

    // MARK: - Calculation

    static func calculate(_ input: Input) -> Output {
        // Critical tasks: 40 points max
        let criticalScore: Int
        if input.totalCriticalTasks == 0 {
            criticalScore = 40  // full marks when no critical tasks are assigned
        } else {
            let ratio = Double(input.completedCriticalTasks) / Double(input.totalCriticalTasks)
            criticalScore = Int(ratio * 40)
        }

        // High tasks: 20 points max
        let highScore: Int
        if input.totalHighTasks == 0 {
            highScore = 20
        } else {
            let ratio = Double(input.completedHighTasks) / Double(input.totalHighTasks)
            highScore = Int(ratio * 20)
        }

        // Health pillars: 20 points (hydration=7, exercise=7, sleep=6)
        let hydrationScore = input.hydrationCompleted ? 7 : 0
        let exerciseScore  = input.exerciseCompleted  ? 7 : 0
        let sleepScore     = input.sleepCompleted     ? 6 : 0

        // Habit score: full 20 marks until Sprint 3 calculates real habit data
        let habitScore = 20

        let breakdown = ScoreBreakdown(
            criticalTaskScore: criticalScore,
            highTaskScore: highScore,
            habitScore: habitScore,
            hydrationScore: hydrationScore,
            exerciseScore: exerciseScore,
            sleepScore: sleepScore
        )

        let raw = min(100, breakdown.total)
        let adjusted = Int(Double(raw) * input.contextMode.scoreMultiplier)
        let total = max(0, min(100, adjusted))

        return Output(total: total, breakdown: breakdown)
    }

    // MARK: - Convenience

    static func calculatePerfect(contextMode: ContextMode = .normal) -> Output {
        calculate(Input(
            completedCriticalTasks: 1,
            totalCriticalTasks: 1,
            completedHighTasks: 1,
            totalHighTasks: 1,
            hydrationCompleted: true,
            exerciseCompleted: true,
            sleepCompleted: true,
            contextMode: contextMode
        ))
    }
}
