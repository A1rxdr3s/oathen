// Sprint 3 — DailyRoutineTests.
// Tests for Sprint 3 domain models and DailyRoutinePolicy.
// No @testable import — domain source compiled directly into test bundle.
import XCTest

final class DailyRoutineTests: XCTestCase {

    // MARK: - Fixed test date

    private let t0 = Date(timeIntervalSince1970: 1_750_000_000)  // ≈ 2025-06-15

    // MARK: - MorningCheckIn

    func testMorningCheckInDefaults() {
        let checkIn = MorningCheckIn(date: t0)
        XCTAssertNil(checkIn.sleepHours)
        XCTAssertEqual(checkIn.energyLevel, .moderate)
        XCTAssertEqual(checkIn.focusLevel, .moderate)
        XCTAssertEqual(checkIn.mood, .neutral)
        XCTAssertEqual(checkIn.mainObstacle, "")
        XCTAssertEqual(checkIn.selectedContextMode, .normal)
        XCTAssertFalse(checkIn.confirmedHydrationGoal)
        XCTAssertFalse(checkIn.confirmedExerciseGoal)
        XCTAssertNil(checkIn.completedAt)
        XCTAssertFalse(checkIn.isComplete)
    }

    func testMorningCheckInIsComplete() {
        var checkIn = MorningCheckIn(date: t0)
        XCTAssertFalse(checkIn.isComplete)
        checkIn.completedAt = t0
        XCTAssertTrue(checkIn.isComplete)
    }

    func testMorningCheckInSleepHoursClamped() {
        let under = MorningCheckIn(date: t0, sleepHours: -1)
        XCTAssertEqual(under.sleepHours, 0)
        let over = MorningCheckIn(date: t0, sleepHours: 30)
        XCTAssertEqual(over.sleepHours, 24)
        let valid = MorningCheckIn(date: t0, sleepHours: 7.5)
        XCTAssertEqual(valid.sleepHours, 7.5)
    }

    func testMorningCheckInSleepQualityLabels() {
        let wellRested = MorningCheckIn(date: t0, sleepHours: 8.5)
        XCTAssertEqual(wellRested.sleepQualityLabel, "Well rested")
        let adequate = MorningCheckIn(date: t0, sleepHours: 7.2)
        XCTAssertEqual(adequate.sleepQualityLabel, "Adequate")
        let light = MorningCheckIn(date: t0, sleepHours: 6.2)
        XCTAssertEqual(light.sleepQualityLabel, "Light")
        let deprived = MorningCheckIn(date: t0, sleepHours: 4.0)
        XCTAssertEqual(deprived.sleepQualityLabel, "Sleep deprived")
        let noRecord = MorningCheckIn(date: t0, sleepHours: nil)
        XCTAssertEqual(noRecord.sleepQualityLabel, "Not recorded")
    }

    func testEnergyLevelAllCasesHaveDisplayNames() {
        for level in EnergyLevel.allCases {
            XCTAssertFalse(level.displayName.isEmpty)
            XCTAssertFalse(level.icon.isEmpty)
        }
    }

    func testFocusLevelAllCasesHaveDisplayNames() {
        for level in FocusLevel.allCases {
            XCTAssertFalse(level.displayName.isEmpty)
            XCTAssertFalse(level.icon.isEmpty)
        }
    }

    func testMoodLevelAllCasesHaveDisplayNames() {
        for level in MoodLevel.allCases {
            XCTAssertFalse(level.displayName.isEmpty)
            XCTAssertFalse(level.icon.isEmpty)
        }
    }

    // MARK: - NightReview

    func testNightReviewDefaults() {
        let review = NightReview(date: t0)
        XCTAssertTrue(review.completedCriticalTaskIDs.isEmpty)
        XCTAssertTrue(review.missedCriticalTaskIDs.isEmpty)
        XCTAssertFalse(review.hydrationCompleted)
        XCTAssertFalse(review.exerciseCompleted)
        XCTAssertFalse(review.sleepRoutineStarted)
        XCTAssertNil(review.failureReason)
        XCTAssertFalse(review.excuseDetected)
        XCTAssertNil(review.completedAt)
        XCTAssertFalse(review.isComplete)
    }

    func testNightReviewIsComplete() {
        var review = NightReview(date: t0)
        XCTAssertFalse(review.isComplete)
        review.completedAt = t0
        XCTAssertTrue(review.isComplete)
    }

    func testNightReviewCounts() {
        let id1 = UUID()
        let id2 = UUID()
        let id3 = UUID()
        let review = NightReview(
            date: t0,
            completedCriticalTaskIDs: [id1, id2],
            missedCriticalTaskIDs: [id3]
        )
        XCTAssertEqual(review.completedCriticalCount, 2)
        XCTAssertEqual(review.missedCriticalCount, 1)
        XCTAssertEqual(review.totalCriticalCount, 3)
    }

    func testNightReviewExecutionSummary() {
        let id1 = UUID()
        let allDone = NightReview(date: t0, completedCriticalTaskIDs: [id1])
        XCTAssertEqual(allDone.executionSummary, "All 1 critical commitments completed.")
        let partial = NightReview(date: t0, completedCriticalTaskIDs: [id1], missedCriticalTaskIDs: [UUID()])
        XCTAssertTrue(partial.executionSummary.contains("1/2"))
        let none = NightReview(date: t0)
        XCTAssertEqual(none.executionSummary, "No critical commitments today.")
    }

    func testNightReviewExcuseDetection() {
        XCTAssertTrue(NightReview.detectExcuse(in: "I didn't have time today"))
        XCTAssertTrue(NightReview.detectExcuse(in: "I was too tired to do it"))
        XCTAssertTrue(NightReview.detectExcuse(in: "I just forgot about it"))
        XCTAssertFalse(NightReview.detectExcuse(in: "Power outage at home"))
        XCTAssertFalse(NightReview.detectExcuse(in: nil))
        XCTAssertFalse(NightReview.detectExcuse(in: ""))
    }

    // MARK: - DailyPlanItem

    func testDailyPlanItemDefaults() {
        let item = DailyPlanItem(title: "Test", kind: .criticalTask)
        XCTAssertEqual(item.priority, .normal)
        XCTAssertEqual(item.status, .pending)
        XCTAssertEqual(item.evidenceRequirement, .none)
        XCTAssertNil(item.estimatedMinutes)
        XCTAssertNil(item.dueDate)
        XCTAssertNil(item.completedAt)
        XCTAssertFalse(item.isComplete)
    }

    func testDailyPlanItemToggled() {
        let item = DailyPlanItem(title: "T", kind: .criticalTask)
        XCTAssertFalse(item.isComplete)

        let completed = item.toggled(at: t0)
        XCTAssertTrue(completed.isComplete)
        XCTAssertEqual(completed.status, .completed)
        XCTAssertEqual(completed.completedAt, t0)

        let pending = completed.toggled(at: t0)
        XCTAssertFalse(pending.isComplete)
        XCTAssertEqual(pending.status, .pending)
        XCTAssertNil(pending.completedAt)
    }

    func testDailyPlanItemKindAllCasesHaveDisplayNamesAndIcons() {
        for kind in DailyPlanItemKind.allCases {
            XCTAssertFalse(kind.displayName.isEmpty)
            XCTAssertFalse(kind.icon.isEmpty)
        }
    }

    func testDailyPlanItemKindHealthPillar() {
        XCTAssertTrue(DailyPlanItemKind.hydration.isHealthPillar)
        XCTAssertTrue(DailyPlanItemKind.exercise.isHealthPillar)
        XCTAssertTrue(DailyPlanItemKind.sleepRoutine.isHealthPillar)
        XCTAssertFalse(DailyPlanItemKind.criticalTask.isHealthPillar)
        XCTAssertFalse(DailyPlanItemKind.review.isHealthPillar)
    }

    func testDailyPlanItemStatusFlags() {
        XCTAssertTrue(DailyPlanItemStatus.completed.isTerminal)
        XCTAssertTrue(DailyPlanItemStatus.skipped.isTerminal)
        XCTAssertFalse(DailyPlanItemStatus.pending.isTerminal)
        XCTAssertTrue(DailyPlanItemStatus.completed.isComplete)
        XCTAssertFalse(DailyPlanItemStatus.skipped.isComplete)
    }

    // MARK: - DailyPlan

    func testDailyPlanDefaults() {
        let plan = DailyPlan(date: t0)
        XCTAssertTrue(plan.items.isEmpty)
        XCTAssertEqual(plan.contextMode, .normal)
        XCTAssertEqual(plan.hydrationTargetML, 3000)
        XCTAssertEqual(plan.exerciseTargetMinutes, 45)
        XCTAssertEqual(plan.sleepTargetHours, 7.5)
        XCTAssertNil(plan.approvedAt)
        XCTAssertEqual(plan.completedCount, 0)
        XCTAssertEqual(plan.totalCount, 0)
        XCTAssertEqual(plan.progressFraction, 0.0)
    }

    func testDailyPlanProgressFraction() {
        let items = [
            DailyPlanItem(title: "A", kind: .criticalTask, status: .completed),
            DailyPlanItem(title: "B", kind: .criticalTask, status: .pending),
            DailyPlanItem(title: "C", kind: .habit, status: .completed),
            DailyPlanItem(title: "D", kind: .habit, status: .pending),
        ]
        let plan = DailyPlan(date: t0, items: items)
        XCTAssertEqual(plan.completedCount, 2)
        XCTAssertEqual(plan.totalCount, 4)
        XCTAssertEqual(plan.progressFraction, 0.5, accuracy: 0.001)
    }

    func testDailyPlanCriticalFilter() {
        let items = [
            DailyPlanItem(title: "Critical", kind: .criticalTask, priority: .critical),
            DailyPlanItem(title: "High", kind: .criticalTask, priority: .high),
            DailyPlanItem(title: "Normal", kind: .habit, priority: .normal),
        ]
        let plan = DailyPlan(date: t0, items: items)
        XCTAssertEqual(plan.criticalItems.count, 1)
        XCTAssertEqual(plan.criticalItems[0].title, "Critical")
        XCTAssertEqual(plan.highItems.count, 1)
    }

    func testDailyPlanHealthPillarFlags() {
        let items = [
            DailyPlanItem(title: "Water", kind: .hydration, status: .completed),
            DailyPlanItem(title: "Run", kind: .exercise, status: .pending),
            DailyPlanItem(title: "Sleep", kind: .sleepRoutine, status: .completed),
        ]
        let plan = DailyPlan(date: t0, items: items)
        XCTAssertTrue(plan.hydrationCompleted)
        XCTAssertFalse(plan.exerciseCompleted)
        XCTAssertTrue(plan.sleepRoutineStarted)
        XCTAssertEqual(plan.hydrationTargetLiters, 3.0, accuracy: 0.001)
    }

    // MARK: - TodayState

    func testTodayStateDefaults() {
        let plan = DailyPlan(date: t0)
        let state = TodayState(date: t0, dailyPlan: plan)
        XCTAssertFalse(state.isMorningCheckInComplete)
        XCTAssertFalse(state.isNightReviewComplete)
        XCTAssertEqual(state.pendingCriticalCount, 0)
        XCTAssertFalse(state.isFullyComplete)
    }

    func testTodayStateCompletionSummary() {
        let items = [
            DailyPlanItem(title: "A", kind: .criticalTask, status: .completed),
            DailyPlanItem(title: "B", kind: .criticalTask, status: .pending),
        ]
        let plan = DailyPlan(date: t0, items: items)
        let state = TodayState(date: t0, dailyPlan: plan)
        XCTAssertEqual(state.completionSummary, "1/2 commitments complete")
    }

    func testTodayStateMorningCheckInFlag() {
        let plan = DailyPlan(date: t0)
        var state = TodayState(date: t0, dailyPlan: plan)
        XCTAssertFalse(state.isMorningCheckInComplete)

        var checkIn = MorningCheckIn(date: t0)
        checkIn.completedAt = t0
        state.morningCheckIn = checkIn
        XCTAssertTrue(state.isMorningCheckInComplete)
    }

    func testTodayStateNightReviewFlag() {
        let plan = DailyPlan(date: t0)
        var state = TodayState(date: t0, dailyPlan: plan)
        XCTAssertFalse(state.isNightReviewComplete)

        var review = NightReview(date: t0)
        review.completedAt = t0
        state.nightReview = review
        XCTAssertTrue(state.isNightReviewComplete)
    }

    // MARK: - DailyRoutinePolicy

    func testDefaultDailyPlanHasItems() {
        let plan = DailyRoutinePolicy.defaultDailyPlan(for: t0)
        XCTAssertFalse(plan.items.isEmpty)
        XCTAssertTrue(plan.items.contains(where: { $0.priority == .critical }))
        XCTAssertTrue(plan.items.contains(where: { $0.kind == .hydration }))
        XCTAssertTrue(plan.items.contains(where: { $0.kind == .exercise }))
        XCTAssertTrue(plan.items.contains(where: { $0.kind == .sleepRoutine }))
    }

    func testDefaultMorningCheckInIsNotComplete() {
        let checkIn = DailyRoutinePolicy.defaultMorningCheckIn(for: t0)
        XCTAssertFalse(checkIn.isComplete)
        XCTAssertNil(checkIn.completedAt)
    }

    func testProgressFraction() {
        let plan = DailyRoutinePolicy.defaultDailyPlan(for: t0)
        XCTAssertEqual(DailyRoutinePolicy.progressFraction(for: plan), 0.0, accuracy: 0.001)
    }

    func testNightReviewDerivation() {
        var plan = DailyRoutinePolicy.defaultDailyPlan(for: t0)
        // Complete the critical items
        for i in plan.items.indices where plan.items[i].priority == .critical {
            plan.items[i] = plan.items[i].toggled(at: t0)
        }
        let review = DailyRoutinePolicy.nightReview(from: plan, failureReason: nil, now: t0)
        XCTAssertFalse(review.completedCriticalTaskIDs.isEmpty)
        XCTAssertTrue(review.missedCriticalTaskIDs.isEmpty)
    }

    func testRecoveryRecommendationZeroMissed() {
        let rec = DailyRoutinePolicy.recoveryRecommendation(missedCriticalCount: 0, failureReason: nil)
        XCTAssertFalse(rec.isEmpty)
        XCTAssertTrue(rec.lowercased().contains("strong") || rec.lowercased().contains("maintain"))
    }

    func testRecoveryRecommendationOneMissed() {
        let rec = DailyRoutinePolicy.recoveryRecommendation(missedCriticalCount: 1, failureReason: nil)
        XCTAssertFalse(rec.isEmpty)
        XCTAssertTrue(rec.lowercased().contains("one critical") || rec.lowercased().contains("missed"))
    }

    func testRecoveryRecommendationManyMissed() {
        let rec = DailyRoutinePolicy.recoveryRecommendation(missedCriticalCount: 5, failureReason: nil)
        XCTAssertFalse(rec.isEmpty)
    }

    func testCalculateScoreFromDefaultState() {
        let state = DailyRoutinePolicy.defaultTodayState(for: t0)
        let score = DailyRoutinePolicy.calculateScore(from: state)
        // Default state: no items complete → critical tasks get full marks (policy: 0 tasks = 40 pts)
        // Actually, we have critical tasks defined but none complete → ratio = 0/2 = 0 pts
        // High tasks: 0 pts from tasks, but high items include hydration (high priority, not criticalTask kind)
        XCTAssertGreaterThanOrEqual(score.totalScore, 0)
        XCTAssertLessThanOrEqual(score.totalScore, 100)
    }

    func testCalculateScoreIncreasesWhenItemsComplete() {
        var state = DailyRoutinePolicy.defaultTodayState(for: t0)
        let baseScore = state.score.totalScore

        // Complete all critical items
        for i in state.dailyPlan.items.indices where state.dailyPlan.items[i].priority == .critical {
            state.dailyPlan.items[i] = state.dailyPlan.items[i].toggled(at: t0)
        }
        let newScore = DailyRoutinePolicy.calculateScore(from: state)
        XCTAssertGreaterThan(newScore.totalScore, baseScore)
    }

    func testCoachNudgeBeforeMorningCheckIn() {
        let state = DailyRoutinePolicy.defaultTodayState(for: t0)
        let nudge = DailyRoutinePolicy.coachNudge(for: state)
        XCTAssertFalse(nudge.isEmpty)
        XCTAssertTrue(nudge.lowercased().contains("morning") || nudge.lowercased().contains("intention"))
    }

    func testCoachNudgeAfterMorningCheckIn() {
        var state = DailyRoutinePolicy.defaultTodayState(for: t0)
        var checkIn = DailyRoutinePolicy.defaultMorningCheckIn(for: t0)
        checkIn.completedAt = t0
        state.morningCheckIn = checkIn

        let nudge = DailyRoutinePolicy.coachNudge(for: state)
        XCTAssertFalse(nudge.isEmpty)
        // With critical items pending, coach should mention them
        XCTAssertTrue(nudge.lowercased().contains("critical") || nudge.lowercased().contains("commitment"))
    }

    func testDefaultTodayStateStructure() {
        let state = DailyRoutinePolicy.defaultTodayState(for: t0)
        XCTAssertNil(state.morningCheckIn)
        XCTAssertNil(state.nightReview)
        XCTAssertEqual(state.contextMode, .normal)
        XCTAssertFalse(state.dailyPlan.items.isEmpty)
        XCTAssertGreaterThanOrEqual(state.score.totalScore, 0)
    }

    func testIsMorningCheckInCompleteHelper() {
        var checkIn = MorningCheckIn(date: t0)
        XCTAssertFalse(DailyRoutinePolicy.isMorningCheckInComplete(checkIn))
        checkIn.completedAt = t0
        XCTAssertTrue(DailyRoutinePolicy.isMorningCheckInComplete(checkIn))
    }

    func testIsNightReviewCompleteHelper() {
        var review = NightReview(date: t0)
        XCTAssertFalse(DailyRoutinePolicy.isNightReviewComplete(review))
        review.completedAt = t0
        XCTAssertTrue(DailyRoutinePolicy.isNightReviewComplete(review))
    }
}
