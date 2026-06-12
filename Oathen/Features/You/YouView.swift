// Sprint 1 — You tab: profile, streak, settings, account placeholder.
// Authentication (Supabase + Sign in with Apple): Sprint 5.
// Account / profile management: Sprint 5.
import SwiftUI

struct YouView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: OathenSpacing.sectionGap) {
                    profileSection
                    streakSection
                    settingsSection
                    versionFooter
                }
                .padding(.horizontal, OathenSpacing.screenHorizontal)
                .padding(.top, OathenSpacing.tabContentTop)
                .padding(.bottom, OathenSpacing.xxxl)
            }
            .background(OathenColors.screenBackground)
            .navigationTitle("You")
            .largeNavigationTitle()
        }
    }

    private var profileSection: some View {
        OathenCard {
            HStack(spacing: OathenSpacing.lg) {
                ZStack {
                    Circle()
                        .fill(OathenColors.accent.opacity(0.15))
                        .frame(width: 64, height: 64)
                    Image(systemName: "person.fill")
                        .font(.title)
                        .foregroundStyle(OathenColors.accent)
                }
                VStack(alignment: .leading, spacing: OathenSpacing.xs) {
                    Text("Placeholder User")
                        .font(OathenTypography.headingMedium)
                    Text("Account: Sprint 5 (Sign in with Apple / Google)")
                        .font(OathenTypography.bodySmall)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                PlaceholderTag()
            }
        }
    }

    private var streakSection: some View {
        OathenCard {
            HStack(spacing: OathenSpacing.lg) {
                VStack(alignment: .leading, spacing: OathenSpacing.xs) {
                    Text("Current Streak")
                        .font(OathenTypography.headingSmall)
                        .foregroundStyle(.secondary)
                    HStack(alignment: .firstTextBaseline, spacing: OathenSpacing.xs) {
                        Text("\(PlaceholderData.streakDays)")
                            .font(OathenTypography.metricDisplay)
                            .foregroundStyle(OathenColors.high)
                        Text("days")
                            .font(OathenTypography.headingSmall)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                Image(systemName: "flame.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(OathenColors.high)
            }
        }
    }

    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: OathenSpacing.sm) {
            OathenSectionHeader(title: "Settings")
            settingsRow(title: "Notifications", icon: "bell.fill", sprint: 6)
            settingsRow(title: "Apple Watch", icon: "applewatch", sprint: 6)
            settingsRow(title: "Privacy", icon: "lock.shield.fill", sprint: 5)
            settingsRow(title: "Ultra Strict Mode", icon: "bolt.shield.fill", sprint: 3)
            settingsRow(title: "Accountability Partner", icon: "person.2.fill", sprint: 8)
            settingsRow(title: "Data Export", icon: "square.and.arrow.up", sprint: 10)
        }
    }

    private func settingsRow(title: String, icon: String, sprint: Int) -> some View {
        OathenCard {
            HStack(spacing: OathenSpacing.md) {
                Image(systemName: icon)
                    .foregroundStyle(OathenColors.accent)
                    .frame(width: 24)
                Text(title)
                    .font(OathenTypography.headingSmall)
                Spacer()
                Text("Sprint \(sprint)")
                    .font(OathenTypography.bodySmall)
                    .foregroundStyle(.tertiary)
                Image(systemName: "chevron.right")
                    .font(OathenTypography.bodySmall)
                    .foregroundStyle(.quaternary)
            }
        }
    }

    private var versionFooter: some View {
        VStack(spacing: OathenSpacing.xs) {
            Text("Oathen · Discipline OS")
                .font(OathenTypography.bodySmall)
                .foregroundStyle(.quaternary)
            Text("Sprint \(AppEnvironment.currentSprint) Shell · v1.0.0 (1)")
                .font(OathenTypography.bodySmall)
                .foregroundStyle(.quaternary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, OathenSpacing.sm)
    }
}

#Preview {
    YouView()
        .preferredColorScheme(.dark)
}
