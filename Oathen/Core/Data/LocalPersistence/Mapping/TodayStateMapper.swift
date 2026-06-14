import Foundation
import SwiftData

enum TodayStateMapper {

    // MARK: - Domain → Persistent

    @MainActor
    static func toPersistent(_ state: TodayState, in context: ModelContext) -> PersistentTodayState {
        let now = Date()
        let dayStart = Calendar.current.startOfDay(for: state.date)

        let persistent = PersistentTodayState(
            dayStart: dayStart,
            date: state.date,
            contextModeRaw: state.contextMode.rawValue,
            createdAt: now,
            updatedAt: now
        )
        context.insert(persistent)

        persistent.dailyPlan = DailyPlanMapper.toPersistent(state.dailyPlan, in: context)

        if let checkIn = state.morningCheckIn {
            let p = MorningCheckInMapper.toPersistent(checkIn)
            context.insert(p)
            persistent.morningCheckIn = p
        }

        if let review = state.nightReview {
            let p = NightReviewMapper.toPersistent(review)
            context.insert(p)
            persistent.nightReview = p
        }

        return persistent
    }

    // MARK: - Persistent → Domain

    /// Returns nil when required data is corrupt or missing — caller should fall back to defaults.
    @MainActor
    static func toDomain(_ p: PersistentTodayState) -> TodayState? {
        guard
            let contextMode = ContextMode(rawValue: p.contextModeRaw),
            let persistentPlan = p.dailyPlan,
            let dailyPlan = DailyPlanMapper.toDomain(persistentPlan)
        else { return nil }

        let morningCheckIn = p.morningCheckIn.flatMap { MorningCheckInMapper.toDomain($0) }
        let nightReview = p.nightReview.map { NightReviewMapper.toDomain($0) }

        var state = TodayState(
            date: p.date,
            contextMode: contextMode,
            morningCheckIn: morningCheckIn,
            dailyPlan: dailyPlan,
            nightReview: nightReview
        )
        // Recalculate score from plan state — avoids persisting a derived value.
        state.score = DailyRoutinePolicy.calculateScore(from: state)
        return state
    }
}
