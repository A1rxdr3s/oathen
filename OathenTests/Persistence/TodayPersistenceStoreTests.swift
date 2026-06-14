// Sprint 4 — TodayPersistenceStore integration tests using an in-memory container.
import XCTest
import SwiftData

@MainActor
final class TodayPersistenceStoreTests: XCTestCase {
    private var container: ModelContainer!
    private var store: TodayPersistenceStore!

    override func setUpWithError() throws {
        container = try OathenModelContainer.make(inMemory: true)
        store = TodayPersistenceStore(context: container.mainContext)
    }

    override func tearDownWithError() throws {
        store = nil
        container = nil
    }

    // MARK: - Load

    func testLoadReturnsNilWhenNothingSaved() throws {
        let loaded = try store.loadToday(for: Date())
        XCTAssertNil(loaded)
    }

    // MARK: - Save and Load

    func testSaveAndLoadRoundTrip() throws {
        let original = DailyRoutinePolicy.defaultTodayState()
        try store.saveToday(original)

        guard let loaded = try store.loadToday(for: original.date) else {
            XCTFail("Expected saved state to be loaded")
            return
        }

        XCTAssertEqual(loaded.contextMode, original.contextMode)
        XCTAssertEqual(loaded.dailyPlan.items.count, original.dailyPlan.items.count)
        XCTAssertNil(loaded.morningCheckIn)
        XCTAssertNil(loaded.nightReview)
    }

    func testSaveOverwritesExistingRecord() throws {
        var state = DailyRoutinePolicy.defaultTodayState()
        try store.saveToday(state)

        // Simulate completing morning check-in
        state.morningCheckIn = MorningCheckIn(sleepHours: 8.0, energyLevel: .high)
        try store.saveToday(state)

        guard let loaded = try store.loadToday(for: state.date) else {
            XCTFail("Expected saved state to be loaded")
            return
        }

        XCTAssertNotNil(loaded.morningCheckIn)
        XCTAssertEqual(loaded.morningCheckIn?.sleepHours, 8.0)
    }

    func testSavePreservesItemToggleState() throws {
        var state = DailyRoutinePolicy.defaultTodayState()
        guard let firstItem = state.dailyPlan.items.first else {
            return  // No items — policy may produce empty plan in this context
        }

        // Toggle first item to completed
        let idx = state.dailyPlan.items.firstIndex(where: { $0.id == firstItem.id })!
        state.dailyPlan.items[idx] = firstItem.toggled(at: Date())
        try store.saveToday(state)

        guard let loaded = try store.loadToday(for: state.date) else {
            XCTFail("Expected saved state to be loaded")
            return
        }

        let loadedItem = loaded.dailyPlan.items.first(where: { $0.id == firstItem.id })
        XCTAssertEqual(loadedItem?.status, .completed)
    }

    // MARK: - Delete

    func testDeleteRemovesRecord() throws {
        let state = DailyRoutinePolicy.defaultTodayState()
        try store.saveToday(state)
        try store.deleteToday(for: state.date)

        let loaded = try store.loadToday(for: state.date)
        XCTAssertNil(loaded)
    }

    func testDeleteNonexistentIsNoOp() throws {
        XCTAssertNoThrow(try store.deleteToday(for: Date()))
    }

    // MARK: - Reset

    func testResetReturnsDefaultState() throws {
        var state = DailyRoutinePolicy.defaultTodayState()
        state.morningCheckIn = MorningCheckIn(sleepHours: 6.0)
        try store.saveToday(state)

        let reset = try store.resetToday()
        XCTAssertNil(reset.morningCheckIn)
        XCTAssertNil(try store.loadToday(for: Date()))
    }
}
