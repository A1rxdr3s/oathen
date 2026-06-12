// Sprint 2 — Model unit tests.
// Covers: initialization, Priority display names/sort, context modes, status flags.
// Domain source files compiled directly into OathenTests — no @testable import needed.
import XCTest

final class ModelTests: XCTestCase {

    // MARK: - Priority

    func testPriorityDisplayNames() {
        XCTAssertEqual(Priority.critical.displayName, "Critical")
        XCTAssertEqual(Priority.high.displayName,     "High")
        XCTAssertEqual(Priority.normal.displayName,   "Normal")
        XCTAssertEqual(Priority.low.displayName,      "Low")
        XCTAssertEqual(Priority.blocked.displayName,  "Blocked")
    }

    func testPrioritySortOrderIsAscending() {
        let sorted = Priority.allCases.sorted { $0.sortOrder < $1.sortOrder }
        XCTAssertEqual(sorted, [.critical, .high, .normal, .low, .blocked])
    }

    func testPriorityBlockedIsNotActionable() {
        XCTAssertFalse(Priority.blocked.isActionable)
        XCTAssertTrue(Priority.critical.isActionable)
        XCTAssertTrue(Priority.low.isActionable)
    }

    // MARK: - ContextMode

    func testContextModeAllCasesHaveDisplayNames() {
        for mode in ContextMode.allCases {
            XCTAssertFalse(mode.displayName.isEmpty, "ContextMode.\(mode) has empty displayName")
            XCTAssertFalse(mode.shortDescription.isEmpty, "ContextMode.\(mode) has empty shortDescription")
        }
    }

    func testContextModeScoreMultipliers() {
        XCTAssertGreaterThan(ContextMode.ultraStrict.scoreMultiplier, 1.0)
        XCTAssertEqual(ContextMode.normal.scoreMultiplier, 1.0)
        XCTAssertLessThan(ContextMode.illnessRecovery.scoreMultiplier, 1.0)
        XCTAssertLessThan(ContextMode.vacation.scoreMultiplier, ContextMode.restDay.scoreMultiplier)
    }

    func testContextModeIsReducedFlag() {
        XCTAssertFalse(ContextMode.normal.isReduced)
        XCTAssertFalse(ContextMode.ultraStrict.isReduced)
        XCTAssertTrue(ContextMode.travel.isReduced)
        XCTAssertTrue(ContextMode.vacation.isReduced)
        XCTAssertTrue(ContextMode.illnessRecovery.isReduced)
    }

    // MARK: - Goal

    func testGoalDefaultInit() {
        let goal = Goal(title: "Test Goal")
        XCTAssertFalse(goal.id.uuidString.isEmpty)
        XCTAssertEqual(goal.title, "Test Goal")
        XCTAssertEqual(goal.status, .active)
        XCTAssertEqual(goal.priority, .normal)
        XCTAssertEqual(goal.progressPercent, 0)
        XCTAssertTrue(goal.projectIDs.isEmpty)
        XCTAssertTrue(goal.tags.isEmpty)
    }

    func testGoalProgressPercentClamped() {
        let over = Goal(title: "Over", progressPercent: 150)
        XCTAssertEqual(over.progressPercent, 100)
        let under = Goal(title: "Under", progressPercent: -10)
        XCTAssertEqual(under.progressPercent, 0)
    }

    func testGoalCategoryDisplayNames() {
        for cat in GoalCategory.allCases {
            XCTAssertFalse(cat.displayName.isEmpty)
        }
    }

    // MARK: - OathenTask

    func testOathenTaskDefaultInit() {
        let task = OathenTask(title: "Test Task")
        XCTAssertEqual(task.title, "Test Task")
        XCTAssertEqual(task.status, .pending)
        XCTAssertEqual(task.priority, .normal)
        XCTAssertNil(task.dueDate)
        XCTAssertNil(task.completedAt)
        XCTAssertFalse(task.isComplete)
    }

    func testOathenTaskEstimatedMinutesClamped() {
        let task = OathenTask(title: "T", estimatedMinutes: -5)
        XCTAssertEqual(task.estimatedMinutes, 0)
    }

    func testTaskStatusTerminalFlags() {
        XCTAssertTrue(TaskStatus.completed.isTerminal)
        XCTAssertTrue(TaskStatus.skipped.isTerminal)
        XCTAssertFalse(TaskStatus.pending.isTerminal)
        XCTAssertFalse(TaskStatus.inProgress.isTerminal)
        XCTAssertFalse(TaskStatus.blocked.isTerminal)
    }

    func testTaskStatusDisplayNames() {
        for status in TaskStatus.allCases {
            XCTAssertFalse(status.displayName.isEmpty)
        }
    }

    // MARK: - Habit

    func testHabitStreakClamped() {
        let habit = Habit(title: "H", currentStreak: -3, bestStreak: -1)
        XCTAssertEqual(habit.currentStreak, 0)
        XCTAssertEqual(habit.bestStreak, 0)
    }

    func testHabitDefaultRecurrence() {
        let habit = Habit(title: "H")
        XCTAssertEqual(habit.recurrence.frequency, .daily)
    }

    // MARK: - Routine

    func testRoutineProgressFraction() {
        var routine = Routine(title: "Morning", type: .morningCheckIn)
        XCTAssertEqual(routine.progressFraction, 0)

        routine.steps = [
            RoutineStep(title: "A", order: 1, status: .completed),
            RoutineStep(title: "B", order: 2, status: .pending),
            RoutineStep(title: "C", order: 3, status: .completed)
        ]
        XCTAssertEqual(routine.completedStepCount, 2)
        XCTAssertEqual(routine.totalStepCount, 3)
        XCTAssertEqual(routine.progressFraction, 2.0 / 3.0, accuracy: 0.001)
    }

    func testRoutineTypeDisplayNames() {
        for type in RoutineType.allCases {
            XCTAssertFalse(type.displayName.isEmpty)
        }
    }

    // MARK: - DisciplineScore

    func testDisciplineScoreTotalClamped() {
        let score = DisciplineScore(totalScore: 150)
        XCTAssertEqual(score.totalScore, 100)
        let negative = DisciplineScore(totalScore: -10)
        XCTAssertEqual(negative.totalScore, 0)
    }

    func testDisciplineScoreLabels() {
        XCTAssertEqual(DisciplineScore(totalScore: 95).label, "Exceptional")
        XCTAssertEqual(DisciplineScore(totalScore: 80).label, "Strong")
        XCTAssertEqual(DisciplineScore(totalScore: 65).label, "Adequate")
        XCTAssertEqual(DisciplineScore(totalScore: 50).label, "Weak")
        XCTAssertEqual(DisciplineScore(totalScore: 20).label, "Critical")
    }

    // MARK: - ScoreBreakdown

    func testScoreBreakdownTotal() {
        let breakdown = ScoreBreakdown(
            criticalTaskScore: 40,
            highTaskScore: 20,
            habitScore: 20,
            hydrationScore: 7,
            exerciseScore: 7,
            sleepScore: 6
        )
        XCTAssertEqual(breakdown.total, 100)
        XCTAssertEqual(ScoreBreakdown.zero.total, 0)
        XCTAssertEqual(ScoreBreakdown.perfect.total, 100)
    }

    // MARK: - EvidenceRequirement

    func testEvidenceRequirementFlags() {
        XCTAssertTrue(EvidenceRequirement.required.isRequired)
        XCTAssertFalse(EvidenceRequirement.optional.isRequired)
        XCTAssertFalse(EvidenceRequirement.none.isRequired)
        XCTAssertTrue(EvidenceRequirement.optional.isOptionalOrRequired)
        XCTAssertTrue(EvidenceRequirement.required.isOptionalOrRequired)
        XCTAssertFalse(EvidenceRequirement.none.isOptionalOrRequired)
    }

    // MARK: - Evidence

    func testEvidenceDefaultLocalOnly() {
        let e = Evidence(
            linkedEntityID: UUID(),
            linkedEntityType: .task,
            type: .manual
        )
        XCTAssertTrue(e.localOnly)
        XCTAssertEqual(e.validationStatus, .pending)
        XCTAssertFalse(e.isResolved)
        XCTAssertFalse(e.isAccepted)
    }

    func testEvidenceTypeFlags() {
        XCTAssertTrue(EvidenceType.aiValidated.requiresAI)
        XCTAssertFalse(EvidenceType.photo.requiresAI)
        XCTAssertFalse(EvidenceType.aiValidated.isSafeForLocalOnly)
        XCTAssertTrue(EvidenceType.photo.isSafeForLocalOnly)
    }

    func testEvidenceValidationStatusResolved() {
        XCTAssertFalse(EvidenceValidationStatus.pending.isResolved)
        XCTAssertTrue(EvidenceValidationStatus.accepted.isResolved)
        XCTAssertTrue(EvidenceValidationStatus.rejected.isResolved)
        XCTAssertTrue(EvidenceValidationStatus.manualOverride.isResolved)
    }

    // MARK: - RecurrenceRule

    func testRecurrenceRulePresets() {
        XCTAssertEqual(RecurrenceRule.daily.frequency, .daily)
        XCTAssertEqual(RecurrenceRule.weekdays.daysOfWeek, [1, 2, 3, 4, 5])
        XCTAssertEqual(RecurrenceRule.weekends.daysOfWeek, [6, 7])
        XCTAssertEqual(RecurrenceRule.daily.timesPerPeriod, 1)
    }

    // MARK: - DateRange

    func testDateRangeIsValid() {
        let start = Date(timeIntervalSince1970: 1_000_000)
        let end   = Date(timeIntervalSince1970: 2_000_000)
        let range = DateRange(start: start, end: end)
        XCTAssertTrue(range.isValid)
        XCTAssertFalse(DateRange(start: end, end: start).isValid)
    }

    func testDateRangeDuration() {
        let start = Date(timeIntervalSince1970: 0)
        let end   = Date(timeIntervalSince1970: 3600)
        XCTAssertEqual(DateRange(start: start, end: end).duration, 3600)
    }
}
