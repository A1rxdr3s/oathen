// Sprint 4 — TodayViewModel with local persistence.
// In-memory state backed by SwiftData. Falls back to in-memory-only when store is nil
// (previews, tests that don't need persistence).
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

    /// No-persistence init — used by previews and tests.
    init() {
        self.store = nil
        self.todayState = DailyRoutinePolicy.defaultTodayState()
    }

    /// Persistent init — loads today's saved state or defaults on first launch.
    init(store: TodayPersistenceStore) {
        self.store = store
        if let saved = try? store.loadToday(for: Date()) {
            self.todayState = saved
        } else {
            self.todayState = DailyRoutinePolicy.defaultTodayState()
        }
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
        persistState()
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
        persistState()
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
        persistState()
    }

    // MARK: - Reset

    func resetToDefaults() {
        if let store {
            todayState = (try? store.resetToday()) ?? DailyRoutinePolicy.defaultTodayState()
        } else {
            todayState = DailyRoutinePolicy.defaultTodayState()
        }
    }

    // MARK: - Private

    private let store: TodayPersistenceStore?

    private func recalculateScore() {
        todayState.score = DailyRoutinePolicy.calculateScore(from: todayState)
    }

    private func persistState() {
        guard let store else { return }
        do {
            try store.saveToday(todayState)
        } catch {
            // Persistence failure is non-fatal — in-memory state remains correct.
            print("[Oathen] Persistence save failed: \(error.localizedDescription)")
        }
    }
}
