// Sprint 3 — MorningCheckIn domain model.
// Represents the morning start-of-day commitment review.
// Pure Swift struct. No SwiftData, no Supabase, no persistence.
import Foundation

// MARK: - Supporting enums

enum EnergyLevel: String, Codable, Equatable, Hashable, Sendable, CaseIterable {
    case low, moderate, high

    var displayName: String {
        switch self {
        case .low:      "Low"
        case .moderate: "Moderate"
        case .high:     "High"
        }
    }

    var icon: String {
        switch self {
        case .low:      "battery.25"
        case .moderate: "battery.50"
        case .high:     "battery.100"
        }
    }
}

enum FocusLevel: String, Codable, Equatable, Hashable, Sendable, CaseIterable {
    case scattered, moderate, sharp

    var displayName: String {
        switch self {
        case .scattered: "Scattered"
        case .moderate:  "Moderate"
        case .sharp:     "Sharp"
        }
    }

    var icon: String {
        switch self {
        case .scattered: "antenna.radiowaves.left.and.right"
        case .moderate:  "circle.dotted"
        case .sharp:     "scope"
        }
    }
}

enum MoodLevel: String, Codable, Equatable, Hashable, Sendable, CaseIterable {
    case low, neutral, good, excellent

    var displayName: String {
        switch self {
        case .low:       "Low"
        case .neutral:   "Neutral"
        case .good:      "Good"
        case .excellent: "Excellent"
        }
    }

    var icon: String {
        switch self {
        case .low:       "cloud.rain"
        case .neutral:   "cloud"
        case .good:      "sun.max"
        case .excellent: "sparkles"
        }
    }
}

// MARK: - MorningCheckIn

struct MorningCheckIn: Identifiable, Codable, Equatable, Hashable, Sendable {
    let id: UUID
    var date: Date
    var sleepHours: Double?             // nil if not entered
    var energyLevel: EnergyLevel
    var focusLevel: FocusLevel
    var mood: MoodLevel
    var mainObstacle: String            // empty string = none identified
    var selectedContextMode: ContextMode
    var confirmedHydrationGoal: Bool
    var confirmedExerciseGoal: Bool
    var confirmedCriticalTaskIDs: [UUID]
    var completedAt: Date?
    let createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        sleepHours: Double? = nil,
        energyLevel: EnergyLevel = .moderate,
        focusLevel: FocusLevel = .moderate,
        mood: MoodLevel = .neutral,
        mainObstacle: String = "",
        selectedContextMode: ContextMode = .normal,
        confirmedHydrationGoal: Bool = false,
        confirmedExerciseGoal: Bool = false,
        confirmedCriticalTaskIDs: [UUID] = [],
        completedAt: Date? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.date = date
        self.sleepHours = sleepHours.map { max(0, min(24, $0)) }
        self.energyLevel = energyLevel
        self.focusLevel = focusLevel
        self.mood = mood
        self.mainObstacle = mainObstacle
        self.selectedContextMode = selectedContextMode
        self.confirmedHydrationGoal = confirmedHydrationGoal
        self.confirmedExerciseGoal = confirmedExerciseGoal
        self.confirmedCriticalTaskIDs = confirmedCriticalTaskIDs
        self.completedAt = completedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var isComplete: Bool { completedAt != nil }

    var sleepQualityLabel: String {
        guard let h = sleepHours else { return "Not recorded" }
        switch h {
        case 8...:   return "Well rested"
        case 7..<8:  return "Adequate"
        case 6..<7:  return "Light"
        default:     return "Sleep deprived"
        }
    }
}
