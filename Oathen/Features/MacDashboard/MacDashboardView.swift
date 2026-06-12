// Sprint 1 — Mac dashboard shell: NavigationSplitView.
// macOS 14+. Not Mac Catalyst. Not a stretched iPhone layout.
// Real module content: Sprint 2+.
// Sprint 1.1: Column widths stabilized; window default size added to OathenApp.swift.
#if os(macOS)
import SwiftUI

enum MacSidebarItem: String, CaseIterable, Identifiable {
    case today       = "Today"
    case goals       = "Goals"
    case coach       = "Coach"
    case health      = "Health"
    case you         = "You"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .today:   return "sun.max.fill"
        case .goals:   return "target"
        case .coach:   return "brain.head.profile"
        case .health:  return "heart.fill"
        case .you:     return "person.fill"
        }
    }

    var sprintLabel: String {
        switch self {
        case .today:   return "Sprint 1 (shell)"
        case .goals:   return "Sprint 2"
        case .coach:   return "Sprint 7"
        case .health:  return "Sprint 4"
        case .you:     return "Sprint 5"
        }
    }
}

struct MacDashboardView: View {
    @State private var selection: MacSidebarItem? = .today

    var body: some View {
        NavigationSplitView {
            sidebarColumn
        } content: {
            contentColumn
        } detail: {
            detailPane
        }
    }

    // MARK: - Sidebar Column

    private var sidebarColumn: some View {
        VStack(spacing: 0) {
            List(MacSidebarItem.allCases, selection: $selection) { item in
                Label(item.rawValue, systemImage: item.icon)
                    .tag(item)
            }
            .listStyle(.sidebar)

            Divider()

            scoreWidget
                .padding(.horizontal, OathenSpacing.md)
                .padding(.vertical, OathenSpacing.sm)
        }
        .navigationTitle("Discipline OS")
        // Minimum 200 keeps sidebar readable; ideal 220 is the natural resting width.
        .navigationSplitViewColumnWidth(min: 200, ideal: 220)
    }

    // MARK: - Content Column

    private var contentColumn: some View {
        Group {
            if let selected = selection {
                contentPane(for: selected)
                    .navigationTitle(selected.rawValue)
            } else {
                emptyContent
                    .navigationTitle("Discipline OS")
            }
        }
        // Minimum 380 prevents title/card text from wrapping at normal window sizes.
        .navigationSplitViewColumnWidth(min: 380, ideal: 440)
    }

    // MARK: - Sidebar Score Widget

    private var scoreWidget: some View {
        HStack(alignment: .center, spacing: OathenSpacing.sm) {
            ScoreRing(
                progress: PlaceholderData.scoreProgress,
                score: PlaceholderData.disciplineScore,
                size: 36
            )
            VStack(alignment: .leading, spacing: 2) {
                Text("Discipline Score")
                    .font(OathenTypography.bodySmall)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Text("\(PlaceholderData.disciplineScore)")
                    .font(OathenTypography.headingMedium)
                    .foregroundStyle(OathenColors.accent)
            }
            .layoutPriority(1)
        }
    }

    // MARK: - Content Pane

    private func contentPane(for item: MacSidebarItem) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: OathenSpacing.sectionGap) {
                moduleHeaderCard(for: item)

                if item == .today {
                    macTodayContent
                }

                Text("Select an item from the list to view detail (Sprint 2+).")
                    .font(OathenTypography.bodySmall)
                    .foregroundStyle(.tertiary)
            }
            .padding(OathenSpacing.lg)
            // Ensure content always expands to the full column width.
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func moduleHeaderCard(for item: MacSidebarItem) -> some View {
        OathenCard {
            HStack(spacing: OathenSpacing.md) {
                Image(systemName: item.icon)
                    .foregroundStyle(OathenColors.accent)
                    .font(.title2)
                    .frame(width: 28, alignment: .center)

                VStack(alignment: .leading, spacing: OathenSpacing.xs) {
                    Text(item.rawValue)
                        .font(OathenTypography.headingLarge)
                        // One line: module names (Today, Goals…) never need to wrap.
                        .lineLimit(1)
                    Text(item.sprintLabel)
                        .font(OathenTypography.bodySmall)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                .layoutPriority(1)
            }
        }
    }

    private var macTodayContent: some View {
        VStack(alignment: .leading, spacing: OathenSpacing.sm) {
            OathenSectionHeader(title: "Health Pillars")
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

    // MARK: - Detail Pane

    private var detailPane: some View {
        VStack(spacing: OathenSpacing.lg) {
            Image(systemName: "rectangle.3.group")
                .font(.system(size: 48))
                .foregroundStyle(OathenColors.accent.opacity(0.3))
            Text("Detail panel — Sprint 2+")
                .font(OathenTypography.headingMedium)
                .foregroundStyle(.secondary)
            Text("Select an item in the content column to view its detail here.")
                .font(OathenTypography.bodySmall)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 300)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Empty State

    private var emptyContent: some View {
        VStack(spacing: OathenSpacing.lg) {
            Image(systemName: "sidebar.left")
                .font(.system(size: 48))
                .foregroundStyle(.tertiary)
            Text("Select a module")
                .font(OathenTypography.headingMedium)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    MacDashboardView()
        .frame(minWidth: 1000, minHeight: 660)
        .preferredColorScheme(.dark)
}
#endif
