// Sprint 3 — DailyPlanCard component.
// Renders critical and high priority daily plan items with completion toggles.
import SwiftUI

struct DailyPlanCard: View {
    let items: [DailyPlanItem]
    let onToggle: (UUID) -> Void

    private var criticalItems: [DailyPlanItem] {
        items.filter { $0.priority == .critical }
    }

    private var highItems: [DailyPlanItem] {
        items.filter { $0.priority == .high && $0.kind == .criticalTask || $0.kind == .habit && $0.priority == .high }
    }

    var body: some View {
        VStack(spacing: OathenSpacing.xs) {
            ForEach(items.filter { $0.priority == .critical || $0.priority == .high }
                .filter { $0.kind == .criticalTask || $0.kind == .habit }) { item in
                itemRow(item)
            }
        }
    }

    private func itemRow(_ item: DailyPlanItem) -> some View {
        OathenCard {
            HStack(spacing: OathenSpacing.md) {
                Button(action: { onToggle(item.id) }) {
                    Image(systemName: item.isComplete ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(item.isComplete ? OathenColors.success : priorityColor(item.priority))
                        .font(.title3)
                        .animation(.easeInOut(duration: 0.2), value: item.isComplete)
                }
                .buttonStyle(.plain)

                VStack(alignment: .leading, spacing: OathenSpacing.xs) {
                    Text(item.title)
                        .font(OathenTypography.headingSmall)
                        .strikethrough(item.isComplete, color: .secondary)
                        .foregroundStyle(item.isComplete ? .secondary : .primary)
                        .animation(.easeInOut(duration: 0.15), value: item.isComplete)

                    HStack(spacing: OathenSpacing.xs) {
                        if let mins = item.estimatedMinutes {
                            Text("\(mins) min")
                                .font(OathenTypography.bodySmall)
                                .foregroundStyle(.tertiary)
                        }
                        if item.evidenceRequirement.isOptionalOrRequired {
                            Text("·")
                                .font(OathenTypography.bodySmall)
                                .foregroundStyle(.tertiary)
                            Text("Evidence \(item.evidenceRequirement == .required ? "required" : "optional")")
                                .font(OathenTypography.bodySmall)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }

                Spacer()
                priorityBadge(item.priority)
            }
        }
    }

    private func priorityColor(_ priority: Priority) -> Color {
        switch priority {
        case .critical: OathenColors.critical
        case .high:     OathenColors.high
        default:        OathenColors.normal
        }
    }

    @ViewBuilder
    private func priorityBadge(_ priority: Priority) -> some View {
        Text(priority.displayName.uppercased())
            .font(OathenTypography.priorityLabel)
            .foregroundStyle(.white)
            .padding(.horizontal, OathenSpacing.sm)
            .padding(.vertical, OathenSpacing.xs)
            .background(priorityColor(priority))
            .clipShape(Capsule())
    }
}

#Preview {
    DailyPlanCard(
        items: DailyRoutinePolicy.defaultDailyPlan(for: Date()).items,
        onToggle: { _ in }
    )
    .padding()
    .preferredColorScheme(.dark)
}
