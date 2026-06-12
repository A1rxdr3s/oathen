// Sprint 2 — RecurrenceRule value object.
// Describes how a Habit or RoutineStep repeats over time.
// No scheduling engine, no notification hooks — concept only in Sprint 2.
import Foundation

enum RecurrenceFrequency: String, Codable, Equatable, Hashable, Sendable, CaseIterable {
    case daily
    case weekdays
    case weekends
    case weekly
    case custom

    var displayName: String {
        switch self {
        case .daily:    "Daily"
        case .weekdays: "Weekdays"
        case .weekends: "Weekends"
        case .weekly:   "Weekly"
        case .custom:   "Custom"
        }
    }
}

struct RecurrenceRule: Codable, Equatable, Hashable, Sendable {
    // Frequency of recurrence.
    var frequency: RecurrenceFrequency

    // Specific days of the week (1 = Monday, 7 = Sunday).
    // Empty means all days apply for the given frequency.
    var daysOfWeek: [Int]

    // How many times the habit must be performed per period.
    var timesPerPeriod: Int

    // MARK: - Presets

    static let daily = RecurrenceRule(
        frequency: .daily,
        daysOfWeek: [],
        timesPerPeriod: 1
    )

    static let weekdays = RecurrenceRule(
        frequency: .weekdays,
        daysOfWeek: [1, 2, 3, 4, 5],
        timesPerPeriod: 1
    )

    static let weekends = RecurrenceRule(
        frequency: .weekends,
        daysOfWeek: [6, 7],
        timesPerPeriod: 1
    )

    static let weekly = RecurrenceRule(
        frequency: .weekly,
        daysOfWeek: [],
        timesPerPeriod: 1
    )
}
