// Sprint 2 — DateRange value object.
// Used for goal target windows, project durations, and analytics periods.
import Foundation

struct DateRange: Codable, Equatable, Hashable, Sendable {
    var start: Date
    var end: Date

    var duration: TimeInterval { end.timeIntervalSince(start) }
    var isValid: Bool { end > start }
    var isInPast: Bool { end < Date() }
    var isActive: Bool { start <= Date() && Date() <= end }

    func contains(_ date: Date) -> Bool {
        date >= start && date <= end
    }
}
