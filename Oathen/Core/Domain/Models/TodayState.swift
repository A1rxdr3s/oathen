// Sprint 3 — TodayState domain model.
// In-memory representation of the full state for the current day.
// Resets on app restart. Persistence: Sprint 3+.
// Pure Swift struct. No SwiftData, no Supabase, no persistence.
import Foundation

struct TodayState: Codable, Equatable, Sendable {
    var date: Date
    var contextMode: ContextMode
    var morningCheckIn: MorningCheckIn?
    var dailyPlan: DailyPlan
    var nightReview: NightReview?
    var score: DisciplineScore

    init(
        date: Date = Date(),
        contextMode: ContextMode = .normal,
        morningCheckIn: MorningCheckIn? = nil,
        dailyPlan: DailyPlan,
        nightReview: NightReview? = nil,
        score: DisciplineScore = DisciplineScore()
    ) {
        self.date = date
        self.contextMode = contextMode
        self.morningCheckIn = morningCheckIn
        self.dailyPlan = dailyPlan
        self.nightReview = nightReview
        self.score = score
    }

    // MARK: - Computed status

    var isMorningCheckInComplete: Bool { morningCheckIn?.isComplete == true }
    var isNightReviewComplete: Bool { nightReview?.isComplete == true }

    var completionSummary: String {
        let completed = dailyPlan.completedCount
        let total = dailyPlan.totalCount
        guard total > 0 else { return "No commitments today." }
        return "\(completed)/\(total) commitments complete"
    }

    var criticalCompletionSummary: String {
        let completed = dailyPlan.completedCriticalCount
        let total = dailyPlan.totalCriticalCount
        guard total > 0 else { return "No critical commitments." }
        if completed == total { return "All critical commitments done." }
        return "\(completed)/\(total) critical done"
    }

    var pendingCriticalCount: Int {
        dailyPlan.criticalItems.filter { !$0.isComplete }.count
    }

    var isFullyComplete: Bool {
        dailyPlan.progressFraction >= 1.0 && isMorningCheckInComplete
    }
}
