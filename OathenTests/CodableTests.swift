// Sprint 2 — Codable round-trip tests.
// Verifies that key domain models encode and decode without data loss.
import XCTest

final class CodableTests: XCTestCase {

    private func roundTrip<T: Codable & Equatable>(_ value: T) throws -> T {
        let data = try JSONEncoder().encode(value)
        return try JSONDecoder().decode(T.self, from: data)
    }

    // MARK: - Goal

    func testGoalCodableRoundTrip() throws {
        let original = DomainFixtures.physicalConditionGoal
        let decoded = try roundTrip(original)
        XCTAssertEqual(original, decoded)
    }

    func testGoalWithOptionalFieldsCodable() throws {
        let goal = Goal(title: "Minimal Goal")
        XCTAssertNil(goal.targetDate)
        let decoded = try roundTrip(goal)
        XCTAssertEqual(goal.title, decoded.title)
        XCTAssertNil(decoded.targetDate)
    }

    // MARK: - OathenTask

    func testOathenTaskCodableRoundTrip() throws {
        let original = DomainFixtures.criticalTask
        let decoded = try roundTrip(original)
        XCTAssertEqual(original, decoded)
    }

    func testOathenTaskWithNilOptionals() throws {
        let task = OathenTask(title: "Simple")
        let decoded = try roundTrip(task)
        XCTAssertNil(decoded.dueDate)
        XCTAssertNil(decoded.completedAt)
        XCTAssertNil(decoded.notes)
    }

    // MARK: - Habit

    func testHabitCodableRoundTrip() throws {
        let original = DomainFixtures.morningWorkoutHabit
        let decoded = try roundTrip(original)
        XCTAssertEqual(original, decoded)
    }

    // MARK: - Routine (with nested steps)

    func testRoutineCodableRoundTrip() throws {
        let original = DomainFixtures.morningCheckIn
        let decoded = try roundTrip(original)
        XCTAssertEqual(original, decoded)
        XCTAssertEqual(decoded.steps.count, original.steps.count)
    }

    // MARK: - DisciplineScore (with nested breakdown)

    func testDisciplineScoreCodableRoundTrip() throws {
        let original = DomainFixtures.sampleDisciplineScore
        let decoded = try roundTrip(original)
        XCTAssertEqual(original, decoded)
        XCTAssertEqual(decoded.breakdown.total, original.breakdown.total)
    }

    // MARK: - Evidence

    func testEvidenceCodableRoundTrip() throws {
        let original = Evidence(
            linkedEntityID: UUID(uuidString: "AAAAAAAA-0000-0000-0000-000000000001")!,
            linkedEntityType: .task,
            type: .photo,
            localOnly: true,
            notes: "Test note"
        )
        let decoded = try roundTrip(original)
        XCTAssertEqual(original, decoded)
        XCTAssertEqual(decoded.notes, "Test note")
    }

    // MARK: - Priority enum

    func testPriorityCodableAllCases() throws {
        for priority in Priority.allCases {
            let decoded = try roundTrip(priority)
            XCTAssertEqual(priority, decoded)
        }
    }

    // MARK: - ContextMode enum

    func testContextModeCodableAllCases() throws {
        for mode in ContextMode.allCases {
            let decoded = try roundTrip(mode)
            XCTAssertEqual(mode, decoded)
        }
    }

    // MARK: - RecurrenceRule

    func testRecurrenceRuleCodable() throws {
        let rule = RecurrenceRule.weekdays
        let decoded = try roundTrip(rule)
        XCTAssertEqual(rule, decoded)
        XCTAssertEqual(decoded.daysOfWeek, [1, 2, 3, 4, 5])
    }

    // MARK: - ScoreBreakdown

    func testScoreBreakdownCodable() throws {
        let original = ScoreBreakdown.perfect
        let decoded = try roundTrip(original)
        XCTAssertEqual(original, decoded)
        XCTAssertEqual(decoded.total, 100)
    }

    // MARK: - Project

    func testProjectCodableRoundTrip() throws {
        let original = DomainFixtures.djhqProject
        let decoded = try roundTrip(original)
        XCTAssertEqual(original, decoded)
        XCTAssertEqual(decoded.goalID, original.goalID)
    }
}
