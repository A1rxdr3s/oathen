// Sprint 3 — Today tab: Daily Command Center.
// Connected to TodayViewModel for live in-memory state.
// No persistence, no HealthKit, no AI, no Supabase.
import SwiftUI

struct TodayView: View {
    @Environment(TodayViewModel.self) private var viewModel

    var body: some View {
        @Bindable var vm = viewModel
        ScrollView {
            VStack(alignment: .leading, spacing: OathenSpacing.sectionGap) {
                // Header: date + daily-plan context button share one row
                HStack(alignment: .top) {
                    headerBanner
                    Spacer()
                    Button(action: { vm.isShowingDailyPlan = true }) {
                        Label(viewModel.contextMode.displayName, systemImage: "list.bullet.clipboard")
                            .font(OathenTypography.bodySmall)
                            .foregroundStyle(OathenColors.accent)
                    }
                }
                DisciplineScoreCard(score: viewModel.score, contextMode: viewModel.contextMode)
                checkInSection
                progressSection
                criticalSection
                healthSection
                coachSection
                nightReviewSection
            }
            .padding(.horizontal, OathenSpacing.screenHorizontal)
            .padding(.top, OathenSpacing.tabContentTop)
            .padding(.bottom, OathenSpacing.tabScrollBottom)
        }
        .background(OathenColors.screenBackground.ignoresSafeArea())
        .sheet(isPresented: $vm.isShowingMorningCheckIn) {
            MorningCheckInView { sleep, energy, focus, mood, obstacle, mode in
                viewModel.completeMorningCheckIn(
                    sleepHours: sleep,
                    energyLevel: energy,
                    focusLevel: focus,
                    mood: mood,
                    mainObstacle: obstacle,
                    contextMode: mode
                )
            }
        }
        .sheet(isPresented: $vm.isShowingNightReview) {
            NightReviewView(state: viewModel.todayState) { reason in
                viewModel.completeNightReview(failureReason: reason)
            }
        }
        .sheet(isPresented: $vm.isShowingDailyPlan) {
            DailyPlanView(plan: viewModel.dailyPlan) { id in
                viewModel.toggleItem(id: id)
            }
        }
    }

    // MARK: - Sub-views

    private var headerBanner: some View {
        VStack(alignment: .leading, spacing: OathenSpacing.xs) {
            Text(formattedDate)
                .font(OathenTypography.bodySmall)
                .foregroundStyle(.secondary)
            Text("Discipline OS")
                .font(OathenTypography.headingSmall)
                .foregroundStyle(.tertiary)
        }
    }

    private var checkInSection: some View {
        VStack(alignment: .leading, spacing: OathenSpacing.sm) {
            OathenSectionHeader(title: "Morning")
            MorningCheckInCard(
                checkIn: viewModel.todayState.morningCheckIn,
                onTap: { viewModel.isShowingMorningCheckIn = true }
            )
        }
    }

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: OathenSpacing.sm) {
            OathenSectionHeader(title: "Day Progress")
            TodayProgressCard(state: viewModel.todayState)
        }
    }

    private var criticalSection: some View {
        VStack(alignment: .leading, spacing: OathenSpacing.sm) {
            HStack {
                OathenSectionHeader(title: "Critical")
                Spacer()
                Button(action: { viewModel.isShowingDailyPlan = true }) {
                    Text("See all")
                        .font(OathenTypography.bodySmall)
                        .foregroundStyle(OathenColors.accent)
                }
            }
            DailyPlanCard(
                items: viewModel.dailyPlan.items,
                onToggle: { viewModel.toggleItem(id: $0) }
            )
        }
    }

    private var healthSection: some View {
        VStack(alignment: .leading, spacing: OathenSpacing.sm) {
            HStack {
                OathenSectionHeader(title: "Health Pillars")
                Spacer()
                Text("Local target")
                    .font(OathenTypography.bodySmall)
                    .foregroundStyle(.tertiary)
            }
            HealthPillarsCard(
                plan: viewModel.dailyPlan,
                onToggle: { viewModel.toggleItem(id: $0) }
            )
        }
    }

    private var coachSection: some View {
        OathenCard {
            HStack(alignment: .top, spacing: OathenSpacing.md) {
                Image(systemName: "brain.head.profile")
                    .foregroundStyle(OathenColors.accent)
                    .font(.title3)
                VStack(alignment: .leading, spacing: OathenSpacing.xs) {
                    Text("Coach")
                        .font(OathenTypography.headingSmall)
                        .foregroundStyle(OathenColors.accent)
                    Text(viewModel.coachNudge)
                        .font(OathenTypography.bodySmall)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    private var nightReviewSection: some View {
        VStack(alignment: .leading, spacing: OathenSpacing.sm) {
            OathenSectionHeader(title: "Night")
            NightReviewCard(
                review: viewModel.todayState.nightReview,
                state: viewModel.todayState,
                onTap: { viewModel.isShowingNightReview = true }
            )
        }
    }

    // MARK: - Helpers

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: Date())
    }
}

#Preview {
    TodayView()
        .environment(TodayViewModel())
        .preferredColorScheme(.dark)
}
