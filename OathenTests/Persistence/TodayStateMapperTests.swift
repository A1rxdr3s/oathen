// Sprint 4 — TodayStateMapper round-trip unit tests.
import XCTest
import SwiftData

@MainActor
final class TodayStateMapperTests: XCTestCase {
    private var container: ModelContainer!
    private var context: ModelContext!

    override func setUpWithError() throws {
        container = try OathenModelContainer.make(inMemory: true)
        context = container.mainContext
    }

    override func tearDownWithError() throws {
        container = nil
        context = nil
    }

    func testRoundTripDefaultStatePreservesContextMode() throws {
        let original = DailyRoutinePolicy.defaultTodayState()

        let persistent = TodayStateMapper.toPersistent(original, in: context)
        guard let restored = TodayStateMapper.toDomain(persistent) else {
            XCTFail("toDomain returned nil for default state")
            return
        }

        XCTAssertEqual(restored.contextMode, original.contextMode)
        XCTAssertEqual(restored.dailyPlan.items.count, original.dailyPlan.items.count)
    }

    func testRoundTripWithMorningCheckIn() throws {
        var original = DailyRoutinePolicy.defaultTodayState()
        original.morningCheckIn = MorningCheckIn(
            sleepHours: 6.5,
            energyLevel: .moderate,
            focusLevel: .scattered,
            mood: .neutral
        )

        let persistent = TodayStateMapper.toPersistent(original, in: context)
        guard let restored = TodayStateMapper.toDomain(persistent) else {
            XCTFail("toDomain returned nil")
            return
        }

        XCTAssertNotNil(restored.morningCheckIn)
        XCTAssertEqual(restored.morningCheckIn?.sleepHours, 6.5)
        XCTAssertEqual(restored.morningCheckIn?.energyLevel, .moderate)
    }

    func testRoundTripWithNightReview() throws {
        var original = DailyRoutinePolicy.defaultTodayState()
        let now = Date()
        var review = DailyRoutinePolicy.nightReview(
            from: original.dailyPlan,
            failureReason: "Test reason",
            now: now
        )
        review.completedAt = now
        original.nightReview = review

        let persistent = TodayStateMapper.toPersistent(original, in: context)
        guard let restored = TodayStateMapper.toDomain(persistent) else {
            XCTFail("toDomain returned nil")
            return
        }

        XCTAssertNotNil(restored.nightReview)
        XCTAssertNotNil(restored.nightReview?.completedAt)
    }

    func testNilCheckInAndReviewPreserved() throws {
        let original = DailyRoutinePolicy.defaultTodayState()
        XCTAssertNil(original.morningCheckIn)
        XCTAssertNil(original.nightReview)

        let persistent = TodayStateMapper.toPersistent(original, in: context)
        let restored = TodayStateMapper.toDomain(persistent)

        XCTAssertNil(restored?.morningCheckIn)
        XCTAssertNil(restored?.nightReview)
    }

    func testScoreIsRecalculatedOnLoad() throws {
        var original = DailyRoutinePolicy.defaultTodayState()
        original.score = DisciplineScore()  // zero score

        let persistent = TodayStateMapper.toPersistent(original, in: context)
        guard let restored = TodayStateMapper.toDomain(persistent) else {
            XCTFail("toDomain returned nil")
            return
        }

        // Score is always recalculated from plan state on load.
        let expected = DailyRoutinePolicy.calculateScore(from: restored)
        XCTAssertEqual(restored.score.totalScore, expected.totalScore)
    }
}
