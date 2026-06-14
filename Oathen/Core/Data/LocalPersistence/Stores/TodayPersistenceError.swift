import Foundation

enum TodayPersistenceError: LocalizedError {
    case saveFailed(underlying: Error)
    case loadFailed(underlying: Error)
    case deleteFailed(underlying: Error)
    case corruptData(reason: String)

    var errorDescription: String? {
        switch self {
        case .saveFailed(let e):     "Failed to save today's state: \(e.localizedDescription)"
        case .loadFailed(let e):     "Failed to load today's state: \(e.localizedDescription)"
        case .deleteFailed(let e):   "Failed to delete today's state: \(e.localizedDescription)"
        case .corruptData(let r):    "Corrupt persistence data: \(r)"
        }
    }
}
