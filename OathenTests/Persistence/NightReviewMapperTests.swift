// Sprint 4 — NightReviewMapper round-trip unit tests.
import XCTest
import SwiftData

@MainActor
final class NightReviewMapperTests: XCTestCase {
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

    func testRoundTripPreservesAllFields() throws {
        let cIDs  = [UUID(), UUID()]
        let mIDs  = [UUID()]
        let chIDs = [UUID(), UUID(), UUID()]
        let mhIDs = [UUID()]

        let original = NightReview(
            id: UUID(),
            completedCriticalTaskIDs: cIDs,
            missedCriticalTaskIDs: mIDs,
            completedHabitIDs: chIDs,
            missedHabitIDs: mhIDs,
            hydrationCompleted: true,
            exerciseCompleted: false,
            sleepRoutineStarted: true,
            failureReason: "Got distracted",
            excuseDetected: true,
            recoveryPlan: "Plan tomorrow better"
        )

        let persistent = NightReviewMapper.toPersistent(original)
        context.insert(persistent)
        let restored = NightReviewMapper.toDomain(persistent)

        XCTAssertEqual(restored.id, original.id)
        XCTAssertEqual(restored.completedCriticalTaskIDs, cIDs)
        XCTAssertEqual(restored.missedCriticalTaskIDs, mIDs)
        XCTAssertEqual(restored.completedHabitIDs, chIDs)
        XCTAssertEqual(restored.missedHabitIDs, mhIDs)
        XCTAssertEqual(restored.hydrationCompleted, true)
        XCTAssertEqual(restored.exerciseCompleted, false)
        XCTAssertEqual(restored.sleepRoutineStarted, true)
        XCTAssertEqual(restored.failureReason, "Got distracted")
        XCTAssertEqual(restored.excuseDetected, true)
        XCTAssertEqual(restored.recoveryPlan, "Plan tomorrow better")
    }

    func testNilFieldsPreserved() throws {
        let original = NightReview(failureReason: nil, recoveryPlan: nil)
        let persistent = NightReviewMapper.toPersistent(original)
        context.insert(persistent)
        let restored = NightReviewMapper.toDomain(persistent)
        XCTAssertNil(restored.failureReason)
        XCTAssertNil(restored.recoveryPlan)
    }

    func testEmptyUUIDArraysPreserved() throws {
        let original = NightReview()
        let persistent = NightReviewMapper.toPersistent(original)
        context.insert(persistent)
        let restored = NightReviewMapper.toDomain(persistent)
        XCTAssertTrue(restored.completedCriticalTaskIDs.isEmpty)
        XCTAssertTrue(restored.missedCriticalTaskIDs.isEmpty)
        XCTAssertTrue(restored.completedHabitIDs.isEmpty)
        XCTAssertTrue(restored.missedHabitIDs.isEmpty)
    }
}
