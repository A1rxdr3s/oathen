// Sprint 3 — DailyRoutinePolicy.
// Pure deterministic helpers for the daily routine engine.
// No HealthKit, no AI, no cloud, no persistence.
import Foundation

enum DailyRoutinePolicy {

    // MARK: - Default plan

    static func defaultDailyPlan(for date: Date, contextMode: ContextMode = .normal) -> DailyPlan {
        let items: [DailyPlanItem] = [
            DailyPlanItem(
                title: "Physical conditioning session",
                kind: .criticalTask,
                priority: .critical,
                evidenceRequirement: .optional,
                estimatedMinutes: 60
            ),
            DailyPlanItem(
                title: "DJHQ production work block",
                kind: .criticalTask,
                priority: .critical,
                evidenceRequirement: .none,
                estimatedMinutes: 90
            ),
            DailyPlanItem(
                title: "Daily hydration — 3L",
                kind: .hydration,
                priority: .high,
                evidenceRequirement: .none
            ),
            DailyPlanItem(
                title: "Morning workout",
                kind: .exercise,
                priority: .high,
                evidenceRequirement: .none,
                estimatedMinutes: 45
            ),
            DailyPlanItem(
                title: "Evening wind-down routine",
                kind: .sleepRoutine,
                priority: .normal,
                evidenceRequirement: .none,
                estimatedMinutes: 20
            ),
            DailyPlanItem(
                title: "Night Review",
                kind: .review,
                priority: .high,
                evidenceRequirement: .none,
                estimatedMinutes: 10
            ),
        ]

        return DailyPlan(
            date: date,
            contextMode: contextMode,
            items: items,
            hydrationTargetML: 3000,
            exerciseTargetMinutes: 45,
            sleepTargetHours: 7.5,
            approvedAt: date
        )
    }

    // MARK: - Default morning check-in (all confirmations true for quick-start)

    static func defaultMorningCheckIn(for date: Date, contextMode: ContextMode = .normal) -> MorningCheckIn {
        MorningCheckIn(
            date: date,
            sleepHours: 7.5,
            energyLevel: .moderate,
            focusLevel: .moderate,
            mood: .good,
            mainObstacle: "",
            selectedContextMode: contextMode,
            confirmedHydrationGoal: true,
            confirmedExerciseGoal: true,
            confirmedCriticalTaskIDs: []
        )
    }

    // MARK: - Completion checks

    static func isMorningCheckInComplete(_ checkIn: MorningCheckIn) -> Bool {
        checkIn.isComplete
    }

    static func isNightReviewComplete(_ review: NightReview) -> Bool {
        review.isComplete
    }

    // MARK: - Progress

    static func progressFraction(for plan: DailyPlan) -> Double {
        plan.progressFraction
    }

    // MARK: - Night review derivation

    static func nightReview(from plan: DailyPlan, failureReason: String? = nil, now: Date) -> NightReview {
        let completedCriticalIDs = plan.criticalItems.filter(\.isComplete).map(\.id)
        let missedCriticalIDs = plan.criticalItems.filter { !$0.isComplete }.map(\.id)
        let completedHabitIDs = plan.items.filter { $0.kind == .habit && $0.isComplete }.map(\.id)
        let missedHabitIDs = plan.items.filter { $0.kind == .habit && !$0.isComplete }.map(\.id)

        let reason = failureReason.flatMap { $0.isEmpty ? nil : $0 }
        let excuseDetected = NightReview.detectExcuse(in: reason)
        let recovery = recoveryRecommendation(
            missedCriticalCount: missedCriticalIDs.count,
            failureReason: reason
        )

        return NightReview(
            date: now,
            completedCriticalTaskIDs: completedCriticalIDs,
            missedCriticalTaskIDs: missedCriticalIDs,
            completedHabitIDs: completedHabitIDs,
            missedHabitIDs: missedHabitIDs,
            hydrationCompleted: plan.hydrationCompleted,
            exerciseCompleted: plan.exerciseCompleted,
            sleepRoutineStarted: plan.sleepRoutineStarted,
            failureReason: reason,
            excuseDetected: excuseDetected,
            recoveryPlan: recovery,
            createdAt: now,
            updatedAt: now
        )
    }

    // MARK: - Recovery recommendation (local rule-based, no AI)

    static func recoveryRecommendation(missedCriticalCount: Int, failureReason: String?) -> String {
        switch missedCriticalCount {
        case 0:
            return "Strong execution. Maintain the standard tomorrow."
        case 1:
            if let reason = failureReason, !reason.isEmpty {
                return "One critical commitment missed. Tomorrow: address it first, before anything else. Reason logged — no repeat."
            }
            return "One critical commitment missed. Schedule it as the first action tomorrow."
        case 2:
            return "Two critical commitments missed. Review what blocked you. Tomorrow: time-block both for the morning session."
        default:
            return "Multiple critical commitments missed. This pattern requires a plan review. Identify root causes — not surface excuses. Reset tomorrow with a focused two-item critical list maximum."
        }
    }

    // MARK: - Coach nudge (local rule-based, no AI)

    static func coachNudge(for state: TodayState) -> String {
        if !state.isMorningCheckInComplete {
            return "Start with intention. Complete the Morning Check-in to lock in your commitments for today."
        }
        let criticalPending = state.pendingCriticalCount
        let progress = state.dailyPlan.progressFraction
        if criticalPending > 0 {
            let word = criticalPending == 1 ? "commitment" : "commitments"
            return "You have \(criticalPending) critical \(word) pending. Complete these first. No excuses accepted tonight."
        }
        if progress >= 1.0 {
            return "All commitments complete. Close the day with the Night Review."
        }
        if progress >= 0.75 {
            return "Strong progress. Push through the remaining commitments now — finish what you started."
        }
        if progress >= 0.5 {
            return "Halfway through. The critical commitments are done — now close out the rest."
        }
        return "The day is still open. What is blocking your commitments? Address it now, not tonight."
    }

    // MARK: - Score calculation

    static func calculateScore(from state: TodayState) -> DisciplineScore {
        let plan = state.dailyPlan
        let input = DisciplineScorePolicy.Input(
            completedCriticalTasks: plan.completedCriticalCount,
            totalCriticalTasks: plan.totalCriticalCount,
            completedHighTasks: plan.completedHighCount,
            totalHighTasks: plan.totalHighCount,
            hydrationCompleted: plan.hydrationCompleted,
            exerciseCompleted: plan.exerciseCompleted,
            sleepCompleted: plan.sleepRoutineStarted,
            contextMode: state.contextMode
        )
        let output = DisciplineScorePolicy.calculate(input)
        return DisciplineScore(
            date: state.date,
            totalScore: output.total,
            breakdown: output.breakdown,
            contextMode: state.contextMode
        )
    }

    // MARK: - Default TodayState

    static func defaultTodayState(for date: Date = Date()) -> TodayState {
        let contextMode = ContextMode.normal
        let plan = defaultDailyPlan(for: date, contextMode: contextMode)
        let initialScore = calculateScore(from: TodayState(
            date: date,
            contextMode: contextMode,
            dailyPlan: plan
        ))
        return TodayState(
            date: date,
            contextMode: contextMode,
            morningCheckIn: nil,
            dailyPlan: plan,
            nightReview: nil,
            score: initialScore
        )
    }
}
