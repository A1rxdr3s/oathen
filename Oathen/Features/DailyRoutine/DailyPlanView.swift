// Sprint 3 — DailyPlanView.
// Full daily plan list with priority grouping and item completion toggles.
// No persistence, no AI, no HealthKit.
import SwiftUI

struct DailyPlanView: View {
    @Environment(\.dismiss) private var dismiss

    let plan: DailyPlan
    var onToggle: (UUID) -> Void

    var body: some View {
        NavigationStack {
            List {
                if !plan.criticalItems.isEmpty {
                    Section("Critical") {
                        ForEach(plan.criticalItems) { item in
                            itemRow(item)
                        }
                    }
                }

                if !plan.highItems.isEmpty {
                    Section("High Priority") {
                        ForEach(plan.highItems) { item in
                            itemRow(item)
                        }
                    }
                }

                let normalItems = plan.items.filter {
                    $0.priority != .critical && $0.priority != .high
                        && $0.kind != .hydration && $0.kind != .exercise && $0.kind != .sleepRoutine
                }
                if !normalItems.isEmpty {
                    Section("Other") {
                        ForEach(normalItems) { item in
                            itemRow(item)
                        }
                    }
                }

                Section("Health Pillars") {
                    ForEach(plan.healthPillarItems) { item in
                        itemRow(item)
                    }
                }

                Section("Today Targets") {
                    HStack {
                        Text("Hydration")
                        Spacer()
                        Text("\(String(format: "%.1f", plan.hydrationTargetLiters)) L")
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    }
                    HStack {
                        Text("Exercise")
                        Spacer()
                        Text("\(plan.exerciseTargetMinutes) min")
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    }
                    HStack {
                        Text("Sleep")
                        Spacer()
                        Text("\(String(format: "%.1f", plan.sleepTargetHours)) h")
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    }
                }
            }
            .navigationTitle("Daily Plan")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func itemRow(_ item: DailyPlanItem) -> some View {
        HStack(spacing: OathenSpacing.md) {
            Button(action: { onToggle(item.id) }) {
                Image(systemName: item.isComplete ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(item.isComplete ? OathenColors.success : itemColor(item))
                    .font(.title3)
                    .animation(.easeInOut(duration: 0.2), value: item.isComplete)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(OathenTypography.bodyMedium)
                    .strikethrough(item.isComplete, color: .secondary)
                    .foregroundStyle(item.isComplete ? .secondary : .primary)
                HStack(spacing: OathenSpacing.xs) {
                    Text(item.kind.displayName)
                        .font(OathenTypography.bodySmall)
                        .foregroundStyle(.tertiary)
                    if let mins = item.estimatedMinutes {
                        Text("· \(mins) min")
                            .font(OathenTypography.bodySmall)
                            .foregroundStyle(.tertiary)
                    }
                }
            }
        }
        .padding(.vertical, 2)
    }

    private func itemColor(_ item: DailyPlanItem) -> Color {
        switch item.priority {
        case .critical: OathenColors.critical
        case .high:     OathenColors.high
        default:        OathenColors.accent
        }
    }
}

#Preview {
    DailyPlanView(
        plan: DailyRoutinePolicy.defaultDailyPlan(for: Date()),
        onToggle: { _ in }
    )
    .preferredColorScheme(.dark)
}
