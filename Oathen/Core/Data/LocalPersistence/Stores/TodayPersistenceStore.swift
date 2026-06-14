import Foundation
import SwiftData

/// Persists and restores TodayState using SwiftData.
/// Always called from the main actor via ModelContext.mainContext.
@MainActor
final class TodayPersistenceStore {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Load

    /// Returns the saved TodayState for the given calendar day, or nil if none exists.
    func loadToday(for date: Date) throws -> TodayState? {
        let dayStart = Calendar.current.startOfDay(for: date)
        let descriptor = FetchDescriptor<PersistentTodayState>(
            predicate: #Predicate { $0.dayStart == dayStart }
        )
        do {
            let results = try context.fetch(descriptor)
            guard let record = results.first else { return nil }
            return TodayStateMapper.toDomain(record)
        } catch {
            throw TodayPersistenceError.loadFailed(underlying: error)
        }
    }

    // MARK: - Save

    /// Saves the given TodayState, replacing any existing record for the same calendar day.
    func saveToday(_ state: TodayState) throws {
        // Remove stale record (cascade deletes child objects).
        try deleteToday(for: state.date)
        // Insert fresh record.
        _ = TodayStateMapper.toPersistent(state, in: context)
        do {
            try context.save()
        } catch {
            throw TodayPersistenceError.saveFailed(underlying: error)
        }
    }

    // MARK: - Delete

    /// Deletes the stored TodayState for the given calendar day, if any.
    func deleteToday(for date: Date) throws {
        let dayStart = Calendar.current.startOfDay(for: date)
        let descriptor = FetchDescriptor<PersistentTodayState>(
            predicate: #Predicate { $0.dayStart == dayStart }
        )
        do {
            let results = try context.fetch(descriptor)
            for record in results {
                context.delete(record)
            }
        } catch {
            throw TodayPersistenceError.deleteFailed(underlying: error)
        }
    }

    // MARK: - Reset

    /// Deletes today's saved state and resets to the policy default.
    func resetToday() throws -> TodayState {
        try deleteToday(for: Date())
        do {
            try context.save()
        } catch {
            throw TodayPersistenceError.deleteFailed(underlying: error)
        }
        return DailyRoutinePolicy.defaultTodayState()
    }
}
