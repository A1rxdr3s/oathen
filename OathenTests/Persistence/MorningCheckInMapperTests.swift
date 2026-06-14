// Sprint 4 — MorningCheckInMapper round-trip unit tests.
// Domain and persistence sources compiled directly into OathenTests — no @testable import.
import XCTest
import SwiftData

@MainActor
final class MorningCheckInMapperTests: XCTestCase {
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
        let ids = [UUID(), UUID()]
        let original = MorningCheckIn(
            id: UUID(),
            sleepHours: 7.5,
            energyLevel: .high,
            focusLevel: .sharp,
            mood: .excellent,
            mainObstacle: "Distraction",
            selectedContextMode: .ultraStrict,
            confirmedHydrationGoal: true,
            confirmedExerciseGoal: true,
            confirmedCriticalTaskIDs: ids
        )

        let persistent = MorningCheckInMapper.toPersistent(original)
        context.insert(persistent)

        guard let restored = MorningCheckInMapper.toDomain(persistent) else {
            XCTFail("toDomain returned nil for valid input")
            return
        }

        XCTAssertEqual(restored.id, original.id)
        XCTAssertEqual(restored.sleepHours, original.sleepHours)
        XCTAssertEqual(restored.energyLevel, original.energyLevel)
        XCTAssertEqual(restored.focusLevel, original.focusLevel)
        XCTAssertEqual(restored.mood, original.mood)
        XCTAssertEqual(restored.mainObstacle, original.mainObstacle)
        XCTAssertEqual(restored.selectedContextMode, original.selectedContextMode)
        XCTAssertEqual(restored.confirmedHydrationGoal, original.confirmedHydrationGoal)
        XCTAssertEqual(restored.confirmedExerciseGoal, original.confirmedExerciseGoal)
        XCTAssertEqual(restored.confirmedCriticalTaskIDs, ids)
    }

    func testNilSleepHoursIsPreserved() throws {
        let original = MorningCheckIn(sleepHours: nil)
        let persistent = MorningCheckInMapper.toPersistent(original)
        context.insert(persistent)
        let restored = MorningCheckInMapper.toDomain(persistent)
        XCTAssertNil(restored?.sleepHours)
    }

    func testEmptyUUIDArrayPreserved() throws {
        let original = MorningCheckIn(confirmedCriticalTaskIDs: [])
        let persistent = MorningCheckInMapper.toPersistent(original)
        context.insert(persistent)
        let restored = MorningCheckInMapper.toDomain(persistent)
        XCTAssertEqual(restored?.confirmedCriticalTaskIDs, [])
    }

    func testDefaultContextModeRoundTrips() throws {
        let original = MorningCheckIn(selectedContextMode: .normal)
        let persistent = MorningCheckInMapper.toPersistent(original)
        context.insert(persistent)
        let restored = MorningCheckInMapper.toDomain(persistent)
        XCTAssertEqual(restored?.selectedContextMode, .normal)
    }

    func testCorruptRawValueReturnsNil() throws {
        let original = MorningCheckIn()
        let persistent = MorningCheckInMapper.toPersistent(original)
        context.insert(persistent)
        persistent.energyLevelRaw = "not_a_valid_case"
        XCTAssertNil(MorningCheckInMapper.toDomain(persistent))
    }
}
