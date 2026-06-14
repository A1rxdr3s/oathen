// Sprint 3 — DailyRoutineCodableTests.
// JSON round-trip tests for all Sprint 3 domain models.
// No @testable import — domain source compiled directly into test bundle.
import XCTest

final class DailyRoutineCodableTests: XCTestCase {

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let t0 = Date(timeIntervalSince1970: 1_750_000_000)

    // MARK: - MorningCheckIn

    func testMorningCheckInRoundTrip() throws {
        let original = MorningCheckIn(
            id: UUID(uuidString: "A1000001-0000-0000-0000-000000000001")!,
            date: t0,
            sleepHours: 7.5,
            energyLevel: .high,
            focusLevel: .sharp,
            mood: .excellent,
            mainObstacle: "Early meeting",
            selectedContextMode: .ultraStrict,
            confirmedHydrationGoal: true,
            confirmedExerciseGoal: true,
            confirmedCriticalTaskIDs: [UUID(uuidString: "F4000001-0000-0000-0000-000000000001")!],
            completedAt: t0,
            createdAt: t0,
            updatedAt: t0
        )
        let data = try encoder.encode(original)
        let decoded = try decoder.decode(MorningCheckIn.self, from: data)
        XCTAssertEqual(original, decoded)
    }

    func testMorningCheckInRoundTripWithNilFields() throws {
        let original = MorningCheckIn(date: t0, sleepHours: nil, completedAt: nil)
        let data = try encoder.encode(original)
        let decoded = try decoder.decode(MorningCheckIn.self, from: data)
        XCTAssertNil(decoded.sleepHours)
        XCTAssertNil(decoded.completedAt)
        XCTAssertEqual(original, decoded)
    }

    func testEnergyLevelCodable() throws {
        for level in EnergyLevel.allCases {
            let data = try encoder.encode(level)
            let decoded = try decoder.decode(EnergyLevel.self, from: data)
            XCTAssertEqual(level, decoded)
        }
    }

    func testFocusLevelCodable() throws {
        for level in FocusLevel.allCases {
            let data = try encoder.encode(level)
            let decoded = try decoder.decode(FocusLevel.self, from: data)
            XCTAssertEqual(level, decoded)
        }
    }

    func testMoodLevelCodable() throws {
        for level in MoodLevel.allCases {
            let data = try encoder.encode(level)
            let decoded = try decoder.decode(MoodLevel.self, from: data)
            XCTAssertEqual(level, decoded)
        }
    }

    // MARK: - NightReview

    func testNightReviewRoundTrip() throws {
        let id1 = UUID(uuidString: "F4000001-0000-0000-0000-000000000001")!
        let id2 = UUID(uuidString: "F4000002-0000-0000-0000-000000000002")!
        let original = NightReview(
            id: UUID(uuidString: "B1000001-0000-0000-0000-000000000001")!,
            date: t0,
            completedCriticalTaskIDs: [id1],
            missedCriticalTaskIDs: [id2],
            completedHabitIDs: [],
            missedHabitIDs: [],
            hydrationCompleted: true,
            exerciseCompleted: false,
            sleepRoutineStarted: true,
            failureReason: "Meeting ran long",
            excuseDetected: false,
            recoveryPlan: "Schedule it first tomorrow.",
            completedAt: t0,
            createdAt: t0,
            updatedAt: t0
        )
        let data = try encoder.encode(original)
        let decoded = try decoder.decode(NightReview.self, from: data)
        XCTAssertEqual(original, decoded)
    }

    func testNightReviewRoundTripWithNilFields() throws {
        let original = NightReview(date: t0)
        let data = try encoder.encode(original)
        let decoded = try decoder.decode(NightReview.self, from: data)
        XCTAssertNil(decoded.failureReason)
        XCTAssertNil(decoded.recoveryPlan)
        XCTAssertNil(decoded.completedAt)
        XCTAssertEqual(original, decoded)
    }

    // MARK: - DailyPlanItem

    func testDailyPlanItemRoundTrip() throws {
        let original = DailyPlanItem(
            id: UUID(uuidString: "C1000001-0000-0000-0000-000000000001")!,
            title: "Physical conditioning",
            kind: .criticalTask,
            priority: .critical,
            status: .completed,
            evidenceRequirement: .optional,
            estimatedMinutes: 60,
            dueDate: t0,
            completedAt: t0
        )
        let data = try encoder.encode(original)
        let decoded = try decoder.decode(DailyPlanItem.self, from: data)
        XCTAssertEqual(original, decoded)
    }

    func testDailyPlanItemKindAllCasesCodable() throws {
        for kind in DailyPlanItemKind.allCases {
            let data = try encoder.encode(kind)
            let decoded = try decoder.decode(DailyPlanItemKind.self, from: data)
            XCTAssertEqual(kind, decoded)
        }
    }

    func testDailyPlanItemStatusAllCasesCodable() throws {
        for status in DailyPlanItemStatus.allCases {
            let data = try encoder.encode(status)
            let decoded = try decoder.decode(DailyPlanItemStatus.self, from: data)
            XCTAssertEqual(status, decoded)
        }
    }

    // MARK: - DailyPlan

    func testDailyPlanRoundTrip() throws {
        let items = [
            DailyPlanItem(title: "Critical A", kind: .criticalTask, priority: .critical),
            DailyPlanItem(title: "Hydration", kind: .hydration, priority: .high),
        ]
        let original = DailyPlan(
            id: UUID(uuidString: "D1000001-0000-0000-0000-000000000001")!,
            date: t0,
            contextMode: .travel,
            items: items,
            hydrationTargetML: 2500,
            exerciseTargetMinutes: 30,
            sleepTargetHours: 7.0,
            approvedAt: t0,
            createdAt: t0,
            updatedAt: t0
        )
        let data = try encoder.encode(original)
        let decoded = try decoder.decode(DailyPlan.self, from: data)
        XCTAssertEqual(original, decoded)
        XCTAssertEqual(decoded.items.count, 2)
        XCTAssertEqual(decoded.contextMode, .travel)
    }

    func testDailyPlanDefaultRoundTrip() throws {
        let plan = DailyRoutinePolicy.defaultDailyPlan(for: t0)
        let data = try encoder.encode(plan)
        let decoded = try decoder.decode(DailyPlan.self, from: data)
        XCTAssertEqual(plan.items.count, decoded.items.count)
        XCTAssertEqual(plan.hydrationTargetML, decoded.hydrationTargetML)
    }

    // MARK: - TodayState

    func testTodayStateRoundTrip() throws {
        var state = DailyRoutinePolicy.defaultTodayState(for: t0)
        // Add morning check-in
        var checkIn = DailyRoutinePolicy.defaultMorningCheckIn(for: t0)
        checkIn.completedAt = t0
        state.morningCheckIn = checkIn
        // Complete one item
        if !state.dailyPlan.items.isEmpty {
            state.dailyPlan.items[0] = state.dailyPlan.items[0].toggled(at: t0)
        }

        let data = try encoder.encode(state)
        let decoded = try decoder.decode(TodayState.self, from: data)
        XCTAssertEqual(state.contextMode, decoded.contextMode)
        XCTAssertEqual(state.dailyPlan.items.count, decoded.dailyPlan.items.count)
        XCTAssertNotNil(decoded.morningCheckIn)
        XCTAssertTrue(decoded.morningCheckIn?.isComplete == true)
    }

    func testTodayStateWithNightReviewRoundTrip() throws {
        var state = DailyRoutinePolicy.defaultTodayState(for: t0)
        var review = DailyRoutinePolicy.nightReview(from: state.dailyPlan, now: t0)
        review.completedAt = t0
        state.nightReview = review

        let data = try encoder.encode(state)
        let decoded = try decoder.decode(TodayState.self, from: data)
        XCTAssertNotNil(decoded.nightReview)
        XCTAssertTrue(decoded.nightReview?.isComplete == true)
    }
}
