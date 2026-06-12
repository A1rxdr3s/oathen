// Sprint 1 — Health tab: placeholder health pillar overview.
// HealthKit integration: Sprint 4. No permission requests. Static placeholder data only.
import SwiftUI

struct HealthView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: OathenSpacing.sectionGap) {
                    sprintNote

                    VStack(alignment: .leading, spacing: OathenSpacing.sm) {
                        OathenSectionHeader(title: "Pillars")
                        pillarCard(
                            title: "Hydration",
                            value: "\(PlaceholderData.hydrationCurrentStr)L",
                            goal: "\(PlaceholderData.hydrationGoalStr)L target",
                            progress: PlaceholderData.hydrationProgress,
                            color: OathenColors.hydration,
                            icon: "drop.fill"
                        )
                        pillarCard(
                            title: "Exercise",
                            value: "\(PlaceholderData.exerciseMinutes) min",
                            goal: "\(PlaceholderData.exerciseGoal) min target",
                            progress: PlaceholderData.exerciseProgress,
                            color: OathenColors.exercise,
                            icon: "figure.run"
                        )
                        pillarCard(
                            title: "Sleep",
                            value: "\(PlaceholderData.sleepHoursStr)h",
                            goal: "\(PlaceholderData.sleepGoalStr)h target",
                            progress: PlaceholderData.sleepProgress,
                            color: OathenColors.sleep,
                            icon: "moon.fill"
                        )
                    }

                    VStack(alignment: .leading, spacing: OathenSpacing.sm) {
                        OathenSectionHeader(title: "Coming in Sprint 4")
                        comingCard(title: "Resting Heart Rate", icon: "heart.fill")
                        comingCard(title: "HRV", icon: "waveform.path.ecg")
                        comingCard(title: "Steps", icon: "figure.walk")
                        comingCard(title: "Body Weight", icon: "scalemass.fill")
                    }
                }
                .padding(.horizontal, OathenSpacing.screenHorizontal)
                .padding(.top, OathenSpacing.tabContentTop)
                .padding(.bottom, OathenSpacing.xxxl)
            }
            .background(OathenColors.screenBackground)
            .navigationTitle("Health")
            .largeNavigationTitle()
        }
    }

    private var sprintNote: some View {
        OathenCard {
            HStack {
                Image(systemName: "info.circle")
                    .foregroundStyle(OathenColors.hydration)
                Text("HealthKit integration (Sprint 4). Non-diagnostic only. All values are placeholders.")
                    .font(OathenTypography.bodySmall)
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
    }

    private func pillarCard(
        title: String,
        value: String,
        goal: String,
        progress: Double,
        color: Color,
        icon: String
    ) -> some View {
        OathenCard {
            VStack(alignment: .leading, spacing: OathenSpacing.sm) {
                HStack(spacing: OathenSpacing.sm) {
                    Image(systemName: icon)
                        .foregroundStyle(color)
                        .frame(width: 20)
                    Text(title)
                        .font(OathenTypography.headingSmall)
                    Spacer()
                    Text(value)
                        .font(OathenTypography.metricDisplay.monospacedDigit())
                        .foregroundStyle(color)
                        .minimumScaleFactor(0.7)
                }
                OathenProgressBar(value: progress, color: color, label: goal)
            }
        }
    }

    private func comingCard(title: String, icon: String) -> some View {
        OathenCard {
            HStack(spacing: OathenSpacing.md) {
                Image(systemName: icon)
                    .foregroundStyle(.tertiary)
                    .frame(width: 20)
                Text(title)
                    .font(OathenTypography.headingSmall)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("Sprint 4")
                    .font(OathenTypography.bodySmall)
                    .foregroundStyle(.tertiary)
            }
        }
    }
}

#Preview {
    HealthView()
        .preferredColorScheme(.dark)
}
