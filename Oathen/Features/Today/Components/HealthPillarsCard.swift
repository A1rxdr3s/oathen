// Sprint 3 — HealthPillarsCard component.
// Shows hydration, exercise, and sleep targets with toggle buttons.
// No HealthKit — local in-memory state only.
import SwiftUI

struct HealthPillarsCard: View {
    let plan: DailyPlan
    let onToggle: (UUID) -> Void

    private var hydrationItem: DailyPlanItem? {
        plan.items.first(where: { $0.kind == .hydration })
    }

    private var exerciseItem: DailyPlanItem? {
        plan.items.first(where: { $0.kind == .exercise })
    }

    private var sleepItem: DailyPlanItem? {
        plan.items.first(where: { $0.kind == .sleepRoutine })
    }

    var body: some View {
        OathenCard {
            VStack(spacing: OathenSpacing.lg) {
                pillarRow(
                    icon: "drop.fill",
                    color: OathenColors.hydration,
                    label: "Hydration",
                    detail: "\(String(format: "%.1f", plan.hydrationTargetLiters))L target",
                    item: hydrationItem
                )
                Divider()
                pillarRow(
                    icon: "figure.run",
                    color: OathenColors.exercise,
                    label: "Exercise",
                    detail: "\(plan.exerciseTargetMinutes) min target",
                    item: exerciseItem
                )
                Divider()
                pillarRow(
                    icon: "moon.fill",
                    color: OathenColors.sleep,
                    label: "Sleep",
                    detail: "\(String(format: "%.1f", plan.sleepTargetHours))h target",
                    item: sleepItem
                )
            }
        }
    }

    private func pillarRow(
        icon: String,
        color: Color,
        label: String,
        detail: String,
        item: DailyPlanItem?
    ) -> some View {
        HStack(spacing: OathenSpacing.md) {
            Image(systemName: icon)
                .foregroundStyle(item?.isComplete == true ? OathenColors.success : color)
                .font(.body)
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(OathenTypography.headingSmall)
                    .foregroundStyle(item?.isComplete == true ? .secondary : .primary)
                Text(detail)
                    .font(OathenTypography.bodySmall)
                    .foregroundStyle(.tertiary)
            }

            Spacer()

            if let item {
                Button(action: { onToggle(item.id) }) {
                    Image(systemName: item.isComplete ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(item.isComplete ? OathenColors.success : .secondary)
                        .font(.title3)
                        .animation(.easeInOut(duration: 0.2), value: item.isComplete)
                }
                .buttonStyle(.plain)
            } else {
                Text("Local target only")
                    .font(OathenTypography.bodySmall)
                    .foregroundStyle(.tertiary)
            }
        }
    }
}

#Preview {
    HealthPillarsCard(
        plan: DailyRoutinePolicy.defaultDailyPlan(for: Date()),
        onToggle: { _ in }
    )
    .padding()
    .preferredColorScheme(.dark)
}
