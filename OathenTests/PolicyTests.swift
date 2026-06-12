// Sprint 2 — Policy unit tests.
// Covers: DisciplineScorePolicy calculation, TaskPriorityPolicy escalation logic.
import XCTest

final class PolicyTests: XCTestCase {

    // MARK: - DisciplineScorePolicy

    func testPerfectDayReachesMaxScore() {
        let result = DisciplineScorePolicy.calculatePerfect(contextMode: .normal)
        XCTAssertEqual(result.total, 100)
        XCTAssertEqual(result.breakdown.total, 100)
    }

    func testZeroDayScoresZero() {
        let input = DisciplineScorePolicy.Input(
            completedCriticalTasks: 0,
            totalCriticalTasks: 2,
            completedHighTasks: 0,
            totalHighTasks: 3,
            hydrationCompleted: false,
            exerciseCompleted: false,
            sleepCompleted: false,
            contextMode: .normal
        )
        let result = DisciplineScorePolicy.calculate(input)
        // habit score is full (20) because Sprint 2 has no real habit tracking
        XCTAssertEqual(result.breakdown.criticalTaskScore, 0)
        XCTAssertEqual(result.breakdown.highTaskScore, 0)
        XCTAssertEqual(result.breakdown.hydrationScore, 0)
        XCTAssertEqual(result.breakdown.exerciseScore, 0)
        XCTAssertEqual(result.breakdown.sleepScore, 0)
        XCTAssertEqual(result.breakdown.habitScore, 20)
        XCTAssertEqual(result.total, 20)
    }

    func testNoTasksGivesFullTaskScore() {
        let input = DisciplineScorePolicy.Input(
            completedCriticalTasks: 0,
            totalCriticalTasks: 0,
            completedHighTasks: 0,
            totalHighTasks: 0,
            hydrationCompleted: false,
            exerciseCompleted: false,
            sleepCompleted: false,
            contextMode: .normal
        )
        let result = DisciplineScorePolicy.calculate(input)
        // 0 tasks → full marks for tasks (40 + 20 = 60) + habit (20) = 80
        XCTAssertEqual(result.breakdown.criticalTaskScore, 40)
        XCTAssertEqual(result.breakdown.highTaskScore, 20)
        XCTAssertEqual(result.total, 80)
    }

    func testContextModeReducesScore() {
        let perfect = DisciplineScorePolicy.calculatePerfect(contextMode: .normal)
        let illness = DisciplineScorePolicy.calculatePerfect(contextMode: .illnessRecovery)
        XCTAssertLessThan(illness.total, perfect.total)
    }

    func testUltraStrictModeIncreasesScore() {
        // A perfect day hits 100 for both modes (the cap prevents the multiplier showing).
        // Use a partial day (sleep+hydration missed → raw 87) where 1.1x has visible effect.
        func partialInput(mode: ContextMode) -> DisciplineScorePolicy.Input {
            DisciplineScorePolicy.Input(
                completedCriticalTasks: 1,
                totalCriticalTasks: 1,
                completedHighTasks: 1,
                totalHighTasks: 1,
                hydrationCompleted: false,
                exerciseCompleted: true,
                sleepCompleted: false,
                contextMode: mode
            )
        }
        let normal = DisciplineScorePolicy.calculate(partialInput(mode: .normal))
        let ultra  = DisciplineScorePolicy.calculate(partialInput(mode: .ultraStrict))
        // raw = 40+20+20+0+7+0 = 87. normal→87, ultraStrict→min(100,Int(87*1.1))=95
        XCTAssertGreaterThan(ultra.total, normal.total)
    }

    func testPartialCriticalTasksScore() {
        let input = DisciplineScorePolicy.Input(
            completedCriticalTasks: 1,
            totalCriticalTasks: 2,
            completedHighTasks: 2,
            totalHighTasks: 2,
            hydrationCompleted: true,
            exerciseCompleted: true,
            sleepCompleted: true,
            contextMode: .normal
        )
        let result = DisciplineScorePolicy.calculate(input)
        XCTAssertEqual(result.breakdown.criticalTaskScore, 20)  // 1/2 × 40
        XCTAssertEqual(result.breakdown.highTaskScore, 20)       // 2/2 × 20
        XCTAssertEqual(result.breakdown.hydrationScore, 7)
        XCTAssertEqual(result.breakdown.exerciseScore, 7)
        XCTAssertEqual(result.breakdown.sleepScore, 6)
    }

    func testScoreCappedAt100() {
        // ultraStrict multiplier > 1, but total can't exceed 100
        let result = DisciplineScorePolicy.calculatePerfect(contextMode: .ultraStrict)
        XCTAssertLessThanOrEqual(result.total, 100)
    }

    // MARK: - TaskPriorityPolicy

    func testBlockedAlwaysWins() {
        let result = TaskPriorityPolicy.suggestedPriority(
            assigned: .low,
            dueDate: Date(timeIntervalSince1970: 0),  // overdue
            isBlocked: true,
            evidenceRequired: true
        )
        XCTAssertEqual(result, .blocked)
    }

    func testNoDueDateReturnsAssigned() {
        let result = TaskPriorityPolicy.suggestedPriority(
            assigned: .normal,
            dueDate: nil,
            isBlocked: false,
            evidenceRequired: false
        )
        XCTAssertEqual(result, .normal)
    }

    func testOverdueEscalatesFromLow() {
        let overdueDate = Date(timeIntervalSince1970: 1_000)  // in the past
        let result = TaskPriorityPolicy.suggestedPriority(
            assigned: .low,
            dueDate: overdueDate,
            isBlocked: false,
            evidenceRequired: false,
            now: Date(timeIntervalSince1970: 2_000_000)
        )
        XCTAssertEqual(result, .normal)
    }

    func testOverdueEscalatesFromNormal() {
        let overdueDate = Date(timeIntervalSince1970: 1_000)
        let result = TaskPriorityPolicy.suggestedPriority(
            assigned: .normal,
            dueDate: overdueDate,
            isBlocked: false,
            evidenceRequired: false,
            now: Date(timeIntervalSince1970: 2_000_000)
        )
        XCTAssertEqual(result, .high)
    }

    func testCriticalDoesNotEscalateBeyondCritical() {
        let overdueDate = Date(timeIntervalSince1970: 1_000)
        let result = TaskPriorityPolicy.suggestedPriority(
            assigned: .critical,
            dueDate: overdueDate,
            isBlocked: false,
            evidenceRequired: false,
            now: Date(timeIntervalSince1970: 2_000_000)
        )
        XCTAssertEqual(result, .critical)
    }

    func testDueWithin4HoursEscalates() {
        let now = Date(timeIntervalSince1970: 1_750_000_000)
        let dueDate = now.addingTimeInterval(2 * 3600)  // 2 hours
        let result = TaskPriorityPolicy.suggestedPriority(
            assigned: .low,
            dueDate: dueDate,
            isBlocked: false,
            evidenceRequired: false,
            now: now
        )
        XCTAssertEqual(result, .normal)
    }

    func testDueWithin24HoursWithEvidenceEscalates() {
        let now = Date(timeIntervalSince1970: 1_750_000_000)
        let dueDate = now.addingTimeInterval(12 * 3600)  // 12 hours
        let result = TaskPriorityPolicy.suggestedPriority(
            assigned: .normal,
            dueDate: dueDate,
            isBlocked: false,
            evidenceRequired: true,
            now: now
        )
        XCTAssertEqual(result, .high)
    }

    func testFutureDueNoEvidenceKeepsAssigned() {
        let now = Date(timeIntervalSince1970: 1_750_000_000)
        let dueDate = now.addingTimeInterval(48 * 3600)  // 2 days
        let result = TaskPriorityPolicy.suggestedPriority(
            assigned: .normal,
            dueDate: dueDate,
            isBlocked: false,
            evidenceRequired: false,
            now: now
        )
        XCTAssertEqual(result, .normal)
    }
}
