// Sprint 4 — DailyPlanMapper round-trip unit tests.
import XCTest
import SwiftData

@MainActor
final class DailyPlanMapperTests: XCTestCase {
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

    func testRoundTripPreservesScalarFields() throws {
        let original = DailyPlan(
            id: UUID(),
            contextMode: .ultraStrict,
            hydrationTargetML: 2500,
            exerciseTargetMinutes: 60,
            sleepTargetHours: 8.0
        )

        let persistent = DailyPlanMapper.toPersistent(original, in: context)

        guard let restored = DailyPlanMapper.toDomain(persistent) else {
            XCTFail("toDomain returned nil")
            return
        }

        XCTAssertEqual(restored.id, original.id)
        XCTAssertEqual(restored.contextMode, original.contextMode)
        XCTAssertEqual(restored.hydrationTargetML, 2500)
        XCTAssertEqual(restored.exerciseTargetMinutes, 60)
        XCTAssertEqual(restored.sleepTargetHours, 8.0)
    }

    func testItemsRoundTripWithOrderPreserved() throws {
        let items = [
            DailyPlanItem(title: "First", kind: .criticalTask, priority: .critical),
            DailyPlanItem(title: "Second", kind: .habit, priority: .high),
            DailyPlanItem(title: "Third", kind: .hydration),
        ]
        let original = DailyPlan(items: items)

        let persistent = DailyPlanMapper.toPersistent(original, in: context)

        guard let restored = DailyPlanMapper.toDomain(persistent) else {
            XCTFail("toDomain returned nil")
            return
        }

        XCTAssertEqual(restored.items.count, 3)
        XCTAssertEqual(restored.items[0].title, "First")
        XCTAssertEqual(restored.items[1].title, "Second")
        XCTAssertEqual(restored.items[2].title, "Third")
        XCTAssertEqual(restored.items[0].priority, .critical)
    }

    func testItemStatusCompletedPreserved() throws {
        let completedAt = Date()
        var item = DailyPlanItem(title: "Done", kind: .exercise)
        item = item.toggled(at: completedAt)

        let original = DailyPlan(items: [item])
        let persistent = DailyPlanMapper.toPersistent(original, in: context)

        guard let restored = DailyPlanMapper.toDomain(persistent) else {
            XCTFail("toDomain returned nil")
            return
        }

        XCTAssertEqual(restored.items.first?.status, .completed)
        XCTAssertNotNil(restored.items.first?.completedAt)
    }

    func testEmptyItemsPreserved() throws {
        let original = DailyPlan(items: [])
        let persistent = DailyPlanMapper.toPersistent(original, in: context)
        let restored = DailyPlanMapper.toDomain(persistent)
        XCTAssertEqual(restored?.items.count, 0)
    }
}
