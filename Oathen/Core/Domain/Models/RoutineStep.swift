// Sprint 2 — RoutineStep domain model.
// A single step within a Routine (Morning Check-in, Night Review, etc.).
// Pure Swift struct. No SwiftData, no Supabase, no persistence.
import Foundation

struct RoutineStep: Identifiable, Codable, Equatable, Hashable, Sendable {
    let id: UUID
    var title: String
    var description: String?
    // Position within the parent Routine. Lower = earlier.
    var order: Int
    var status: RoutineStepStatus
    var evidenceRequirement: EvidenceRequirement

    init(
        id: UUID = UUID(),
        title: String,
        description: String? = nil,
        order: Int = 0,
        status: RoutineStepStatus = .pending,
        evidenceRequirement: EvidenceRequirement = .none
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.order = order
        self.status = status
        self.evidenceRequirement = evidenceRequirement
    }
}
