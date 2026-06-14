import Foundation
import SwiftData

enum DailyPlanMapper {

    // MARK: - Domain → Persistent

    @MainActor
    static func toPersistent(_ plan: DailyPlan, in context: ModelContext) -> PersistentDailyPlan {
        let persistent = PersistentDailyPlan(
            domainID: plan.id,
            date: plan.date,
            contextModeRaw: plan.contextMode.rawValue,
            hydrationTargetML: plan.hydrationTargetML,
            exerciseTargetMinutes: plan.exerciseTargetMinutes,
            sleepTargetHours: plan.sleepTargetHours,
            approvedAt: plan.approvedAt,
            createdAt: plan.createdAt,
            updatedAt: plan.updatedAt
        )
        context.insert(persistent)

        let persistentItems = plan.items.enumerated().map { idx, item in
            let p = PersistentDailyPlanItem(
                domainID: item.id,
                title: item.title,
                kindRaw: item.kind.rawValue,
                priorityRaw: item.priority.rawValue,
                statusRaw: item.status.rawValue,
                evidenceRequirementRaw: item.evidenceRequirement.rawValue,
                estimatedMinutes: item.estimatedMinutes,
                dueDate: item.dueDate,
                completedAt: item.completedAt,
                sortOrder: idx
            )
            context.insert(p)
            return p
        }
        persistent.items = persistentItems

        return persistent
    }

    // MARK: - Persistent → Domain

    @MainActor
    static func toDomain(_ p: PersistentDailyPlan) -> DailyPlan? {
        guard let contextMode = ContextMode(rawValue: p.contextModeRaw) else { return nil }

        let items = p.items
            .sorted { $0.sortOrder < $1.sortOrder }
            .compactMap { itemToDomain($0) }

        return DailyPlan(
            id: p.domainID,
            date: p.date,
            contextMode: contextMode,
            items: items,
            hydrationTargetML: p.hydrationTargetML,
            exerciseTargetMinutes: p.exerciseTargetMinutes,
            sleepTargetHours: p.sleepTargetHours,
            approvedAt: p.approvedAt,
            createdAt: p.createdAt,
            updatedAt: p.updatedAt
        )
    }

    @MainActor
    private static func itemToDomain(_ p: PersistentDailyPlanItem) -> DailyPlanItem? {
        guard
            let kind = DailyPlanItemKind(rawValue: p.kindRaw),
            let priority = Priority(rawValue: p.priorityRaw),
            let status = DailyPlanItemStatus(rawValue: p.statusRaw),
            let evidence = EvidenceRequirement(rawValue: p.evidenceRequirementRaw)
        else { return nil }

        return DailyPlanItem(
            id: p.domainID,
            title: p.title,
            kind: kind,
            priority: priority,
            status: status,
            evidenceRequirement: evidence,
            estimatedMinutes: p.estimatedMinutes,
            dueDate: p.dueDate,
            completedAt: p.completedAt
        )
    }
}
