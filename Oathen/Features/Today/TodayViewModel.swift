// Sprint 3 — TodayViewModel.
// In-memory state for the current day. Resets on app restart (no persistence yet).
// Owns TodayState and drives all Today tab interactions.
import SwiftUI
import Observation

@MainActor
@Observable
final class TodayViewModel {

    // MARK: - State

    var todayState: TodayState
    var isShowingMorningCheckIn: Bool = false
    var isShowingNightReview: Bool = false
    var isShowingDailyPlan: Bool = false

    // MARK: - Init

    init() {
        self.todayState = DailyRoutinePolicy.defaultTodayState()
    }

    // MARK: - Accessors

    var score: DisciplineScore { todayState.score }
    var dailyPlan: DailyPlan { todayState.dailyPlan }
    var contextMode: ContextMode { todayState.contextMode }
    var isMorningCheckInComplete: Bool { todayState.isMorningCheckInComplete }
    var isNightReviewComplete: Bool { todayState.isNightReviewComplete }

    var coachNudge: String { DailyRoutinePolicy.coachNudge(for: todayState) }

    // MARK: - Morning Check-in

    func completeMorningCheckIn(
        sleepHours: Double,
        energyLevel: EnergyLevel,
        focusLevel: FocusLevel,
        mood: MoodLevel,
        mainObstacle: String,
        contextMode: ContextMode
    ) {
        let now = Date()
        var checkIn = DailyRoutinePolicy.defaultMorningCheckIn(for: todayState.date, contextMode: contextMode)
        checkIn.sleepHours = sleepHours
        checkIn.energyLevel = energyLevel
        checkIn.focusLevel = focusLevel
        checkIn.mood = mood
        checkIn.mainObstacle = mainObstacle
        checkIn.selectedContextMode = contextMode
        checkIn.completedAt = now
        checkIn.updatedAt = now

        todayState.morningCheckIn = checkIn
        todayState.contextMode = contextMode
        todayState.dailyPlan.contextMode = contextMode
        recalculateScore()
    }

    func completeMorningCheckInWithDefaults() {
        completeMorningCheckIn(
            sleepHours: 7.5,
            energyLevel: .moderate,
            focusLevel: .moderate,
            mood: .good,
            mainObstacle: "",
            contextMode: .normal
        )
    }

    // MARK: - Daily plan item toggling

    func toggleItem(id: UUID) {
        guard let idx = todayState.dailyPlan.items.firstIndex(where: { $0.id == id }) else { return }
        todayState.dailyPlan.items[idx] = todayState.dailyPlan.items[idx].toggled(at: Date())
        todayState.dailyPlan.updatedAt = Date()
        recalculateScore()
    }

    // MARK: - Night Review

    func completeNightReview(failureReason: String = "") {
        let now = Date()
        var review = DailyRoutinePolicy.nightReview(
            from: todayState.dailyPlan,
            failureReason: failureReason,
            now: now
        )
        review.completedAt = now
        todayState.nightReview = review
        recalculateScore()
    }

    // MARK: - Reset

    func resetToDefaults() {
        todayState = DailyRoutinePolicy.defaultTodayState()
    }

    // MARK: - Private

    private func recalculateScore() {
        todayState.score = DailyRoutinePolicy.calculateScore(from: todayState)
    }
}
