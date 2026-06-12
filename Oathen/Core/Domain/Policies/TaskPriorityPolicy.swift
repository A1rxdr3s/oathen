// Sprint 2 — TaskPriorityPolicy.
// Deterministic priority suggestion helper. No AI, no external services.
// Considers due date proximity, blocked state, and evidence requirement.
import Foundation

enum TaskPriorityPolicy {

    // Returns the suggested effective priority for a task at `now`.
    // The manually assigned priority is the baseline; urgency can only escalate it.
    static func suggestedPriority(
        assigned: Priority,
        dueDate: Date?,
        isBlocked: Bool,
        evidenceRequired: Bool,
        now: Date = Date()
    ) -> Priority {
        // Blocked always wins regardless of due date.
        if isBlocked { return .blocked }

        guard let due = dueDate else { return assigned }

        let hoursUntilDue = due.timeIntervalSince(now) / 3600

        if hoursUntilDue < 0 {
            // Overdue — escalate one level regardless of evidence
            return escalate(assigned)
        }

        if hoursUntilDue <= 4 {
            // Due within 4 hours — escalate
            return escalate(assigned)
        }

        if hoursUntilDue <= 24 && evidenceRequired {
            // Due today AND needs evidence — collecting evidence takes time, bump up
            return escalate(assigned)
        }

        return assigned
    }

    // Returns the number of tasks that are considered overdue given a list.
    static func overdueCount(in tasks: [OathenTask], now: Date = Date()) -> Int {
        tasks.filter { $0.isOverdue }.count
    }

    // MARK: - Private

    private static func escalate(_ priority: Priority) -> Priority {
        switch priority {
        case .low:      .normal
        case .normal:   .high
        case .high:     .critical
        case .critical: .critical
        case .blocked:  .blocked
        }
    }
}
