// Sprint 2 — DisciplineScore domain model.
// Represents the user's daily discipline score — the core metric of Oathen.
// Calculation engine: Sprint 3. This sprint defines the data shape only.
// Pure Swift struct. No SwiftData, no Supabase, no persistence.
import Foundation

struct DisciplineScore: Identifiable, Codable, Equatable, Hashable, Sendable {
    let id: UUID
    // The calendar day this score represents (time component should be ignored)
    var date: Date
    // 0 – 100 (after context mode multiplier)
    var totalScore: Int
    var breakdown: ScoreBreakdown
    var contextMode: ContextMode
    let createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        totalScore: Int = 0,
        breakdown: ScoreBreakdown = .zero,
        contextMode: ContextMode = .normal,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.date = date
        self.totalScore = max(0, min(100, totalScore))
        self.breakdown = breakdown
        self.contextMode = contextMode
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    // Qualitative label for display — thresholds TBD in Sprint 3
    var label: String {
        switch totalScore {
        case 90...100: "Exceptional"
        case 75..<90:  "Strong"
        case 60..<75:  "Adequate"
        case 40..<60:  "Weak"
        default:       "Critical"
        }
    }
}
