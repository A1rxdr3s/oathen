// Sprint 2 — Status enums for all major domain entities.
// Each entity type has its own status vocabulary.
// No UIKit, no SwiftUI, no persistence.
import Foundation

// MARK: - Goal

enum GoalStatus: String, Codable, Equatable, Hashable, Sendable, CaseIterable {
    case active
    case completed
    case paused
    case abandoned

    var displayName: String {
        switch self {
        case .active:    "Active"
        case .completed: "Completed"
        case .paused:    "Paused"
        case .abandoned: "Abandoned"
        }
    }

    var isTerminal: Bool { self == .completed || self == .abandoned }
}

// MARK: - Project

enum ProjectStatus: String, Codable, Equatable, Hashable, Sendable, CaseIterable {
    case active
    case completed
    case paused
    case archived

    var displayName: String {
        switch self {
        case .active:    "Active"
        case .completed: "Completed"
        case .paused:    "Paused"
        case .archived:  "Archived"
        }
    }

    var isTerminal: Bool { self == .completed || self == .archived }
}

// MARK: - Habit

enum HabitStatus: String, Codable, Equatable, Hashable, Sendable, CaseIterable {
    case active
    case paused
    case archived

    var displayName: String {
        switch self {
        case .active:   "Active"
        case .paused:   "Paused"
        case .archived: "Archived"
        }
    }
}

// MARK: - Task

enum TaskStatus: String, Codable, Equatable, Hashable, Sendable, CaseIterable {
    case pending
    case inProgress
    case completed
    case skipped
    case blocked
    case deferred

    var displayName: String {
        switch self {
        case .pending:    "Pending"
        case .inProgress: "In Progress"
        case .completed:  "Completed"
        case .skipped:    "Skipped"
        case .blocked:    "Blocked"
        case .deferred:   "Deferred"
        }
    }

    var isTerminal: Bool {
        switch self {
        case .completed, .skipped: true
        default:                   false
        }
    }

    var isOpen: Bool { !isTerminal }
}

// MARK: - Routine

enum RoutineStatus: String, Codable, Equatable, Hashable, Sendable, CaseIterable {
    case pending
    case inProgress
    case completed
    case skipped

    var displayName: String {
        switch self {
        case .pending:    "Pending"
        case .inProgress: "In Progress"
        case .completed:  "Completed"
        case .skipped:    "Skipped"
        }
    }

    var isTerminal: Bool { self == .completed || self == .skipped }
}

// MARK: - RoutineStep

enum RoutineStepStatus: String, Codable, Equatable, Hashable, Sendable, CaseIterable {
    case pending
    case completed
    case skipped

    var displayName: String {
        switch self {
        case .pending:   "Pending"
        case .completed: "Completed"
        case .skipped:   "Skipped"
        }
    }
}
