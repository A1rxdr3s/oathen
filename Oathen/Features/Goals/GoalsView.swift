// Sprint 1 — Goals tab: placeholder hierarchy view.
// Goal → Project → Habit → Task hierarchy will be implemented in Sprint 2.
import SwiftUI

struct GoalsView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: OathenSpacing.sectionGap) {
                    sprintNote

                    VStack(alignment: .leading, spacing: OathenSpacing.sm) {
                        OathenSectionHeader(title: "Active Goals")
                        ForEach(PlaceholderData.goalTitles, id: \.self) { title in
                            GoalRowPlaceholder(title: title)
                        }
                    }

                    VStack(alignment: .leading, spacing: OathenSpacing.sm) {
                        OathenSectionHeader(title: "Habits")
                        habitRow(title: "Morning workout", streak: 12, icon: "figure.run")
                        habitRow(title: "Hydration (3L)", streak: 8, icon: "drop.fill")
                        habitRow(title: "Evening review", streak: 5, icon: "moon.fill")
                    }
                }
                .padding(.horizontal, OathenSpacing.screenHorizontal)
                .padding(.top, OathenSpacing.tabContentTop)
                .padding(.bottom, OathenSpacing.xxxl)
            }
            .background(OathenColors.screenBackground)
            .navigationTitle("Goals")
            .largeNavigationTitle()
        }
    }

    private var sprintNote: some View {
        OathenCard {
            HStack {
                Image(systemName: "info.circle")
                    .foregroundStyle(OathenColors.accent)
                Text("Domain models (Goal, Project, Habit, Task) implement in Sprint 2.")
                    .font(OathenTypography.bodySmall)
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
    }

    private func habitRow(title: String, streak: Int, icon: String) -> some View {
        OathenCard {
            HStack(spacing: OathenSpacing.md) {
                Image(systemName: icon)
                    .foregroundStyle(OathenColors.accent)
                    .frame(width: 24)
                Text(title)
                    .font(OathenTypography.headingSmall)
                Spacer()
                HStack(spacing: OathenSpacing.xs) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(OathenColors.high)
                        .font(OathenTypography.bodySmall)
                    Text("\(streak)d")
                        .font(OathenTypography.monoData)
                        .foregroundStyle(OathenColors.high)
                }
            }
        }
    }
}

private struct GoalRowPlaceholder: View {
    let title: String

    var body: some View {
        OathenCard {
            VStack(alignment: .leading, spacing: OathenSpacing.sm) {
                HStack {
                    Text(title)
                        .font(OathenTypography.headingMedium)
                    Spacer()
                    PriorityBadge(priority: .high)
                }
                OathenProgressBar(value: Double.random(in: 0.2...0.8), color: OathenColors.accent, label: "Progress")
                Text("Goal → Project → Habit → Task hierarchy — Sprint 2")
                    .font(OathenTypography.bodySmall)
                    .foregroundStyle(.tertiary)
            }
        }
    }
}

#Preview {
    GoalsView()
        .preferredColorScheme(.dark)
}
