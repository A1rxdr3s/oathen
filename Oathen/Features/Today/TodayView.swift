// Sprint 1 — Today tab: Daily Command Center placeholder.
// No real data. No business logic. No persistence.
import SwiftUI

struct TodayView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: OathenSpacing.sectionGap) {
                    headerBanner
                    scoreSection
                    criticalSection
                    healthSection
                    coachSection
                }
                .padding(.horizontal, OathenSpacing.screenHorizontal)
                .padding(.top, OathenSpacing.tabContentTop)
                .padding(.bottom, OathenSpacing.xxxl)
            }
            .background(OathenColors.screenBackground)
            .navigationTitle("Today")
            .largeNavigationTitle()
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Label(PlaceholderData.contextMode, systemImage: "circle.fill")
                        .font(OathenTypography.bodySmall)
                        .foregroundStyle(OathenColors.accent)
                }
            }
        }
    }

    // MARK: - Sub-views

    private var headerBanner: some View {
        HStack {
            VStack(alignment: .leading, spacing: OathenSpacing.xs) {
                Text(PlaceholderData.todayDateString)
                    .font(OathenTypography.bodySmall)
                    .foregroundStyle(.secondary)
                Text("Discipline OS")
                    .font(OathenTypography.headingSmall)
                    .foregroundStyle(.tertiary)
            }
            Spacer()
            PlaceholderTag()
        }
    }

    private var scoreSection: some View {
        OathenCard {
            HStack(alignment: .center, spacing: OathenSpacing.lg) {
                VStack(alignment: .leading, spacing: OathenSpacing.xs) {
                    Text("Discipline Score")
                        .font(OathenTypography.headingSmall)
                        .foregroundStyle(.secondary)
                    Text("\(PlaceholderData.disciplineScore)")
                        .font(OathenTypography.scoreDisplay)
                        .foregroundStyle(OathenColors.accent)
                    Text("Score engine — Sprint 3")
                        .font(OathenTypography.bodySmall)
                        .foregroundStyle(.tertiary)
                }
                Spacer()
                ScoreRing(
                    progress: PlaceholderData.scoreProgress,
                    score: PlaceholderData.disciplineScore,
                    size: 80
                )
            }
        }
    }

    private var criticalSection: some View {
        VStack(alignment: .leading, spacing: OathenSpacing.sm) {
            HStack {
                OathenSectionHeader(title: "Critical")
                Spacer()
                Text("Tasks — Sprint 2")
                    .font(OathenTypography.bodySmall)
                    .foregroundStyle(.tertiary)
            }

            OathenCard {
                HStack(spacing: OathenSpacing.md) {
                    Image(systemName: "circle")
                        .foregroundStyle(OathenColors.critical)
                        .font(.body)
                    VStack(alignment: .leading, spacing: OathenSpacing.xs) {
                        Text(PlaceholderData.criticalTaskTitle)
                            .font(OathenTypography.headingSmall)
                        Text("Evidence required · Today")
                            .font(OathenTypography.bodySmall)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    PriorityBadge(priority: .critical)
                }
            }

            OathenCard {
                HStack(spacing: OathenSpacing.md) {
                    Image(systemName: "circle")
                        .foregroundStyle(OathenColors.high)
                        .font(.body)
                    VStack(alignment: .leading, spacing: OathenSpacing.xs) {
                        Text(PlaceholderData.highTaskTitle)
                            .font(OathenTypography.headingSmall)
                        Text("Estimated 45 min · Due 18:00")
                            .font(OathenTypography.bodySmall)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    PriorityBadge(priority: .high)
                }
            }
        }
    }

    private var healthSection: some View {
        VStack(alignment: .leading, spacing: OathenSpacing.sm) {
            HStack {
                OathenSectionHeader(title: "Health")
                Spacer()
                Text("HealthKit — Sprint 4")
                    .font(OathenTypography.bodySmall)
                    .foregroundStyle(.tertiary)
            }

            OathenCard {
                VStack(spacing: OathenSpacing.lg) {
                    OathenProgressBar(
                        value: PlaceholderData.hydrationProgress,
                        color: OathenColors.hydration,
                        label: "Hydration  \(PlaceholderData.hydrationCurrentStr)L / \(PlaceholderData.hydrationGoalStr)L"
                    )
                    OathenProgressBar(
                        value: PlaceholderData.exerciseProgress,
                        color: OathenColors.exercise,
                        label: "Exercise  \(PlaceholderData.exerciseMinutes) / \(PlaceholderData.exerciseGoal) min"
                    )
                    OathenProgressBar(
                        value: PlaceholderData.sleepProgress,
                        color: OathenColors.sleep,
                        label: "Sleep  \(PlaceholderData.sleepHoursStr)h / \(PlaceholderData.sleepGoalStr)h target"
                    )
                }
            }
        }
    }

    private var coachSection: some View {
        OathenCard {
            HStack(alignment: .top, spacing: OathenSpacing.md) {
                Image(systemName: "brain.head.profile")
                    .foregroundStyle(OathenColors.accent)
                    .font(.title3)
                VStack(alignment: .leading, spacing: OathenSpacing.xs) {
                    HStack(spacing: OathenSpacing.sm) {
                        Text("Coach")
                            .font(OathenTypography.headingSmall)
                            .foregroundStyle(OathenColors.accent)
                        PlaceholderTag()
                    }
                    Text(PlaceholderData.coachNudge)
                        .font(OathenTypography.bodySmall)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}

#Preview {
    TodayView()
        .preferredColorScheme(.dark)
}
