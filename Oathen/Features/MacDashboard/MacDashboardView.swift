// Sprint 3 — Mac dashboard: NavigationSplitView with live Today state.
// macOS 14+. Not Mac Catalyst. Not a stretched iPhone layout.
// Today module now connected to TodayViewModel in-memory state.
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

    var subtitle: String {
        switch self {
        case .today:   return "Daily accountability loop"
        case .goals:   return "Long-term commitments — not active yet"
        case .coach:   return "Strict, context-aware accountability — coming later"
        case .health:  return "Exercise, hydration, and sleep — local targets now"
        case .you:     return "Profile, privacy, and settings — coming later"
        }
    }
}

struct MacDashboardView: View {
    @Environment(TodayViewModel.self) private var todayViewModel
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
        .navigationSplitViewColumnWidth(min: 380, ideal: 440)
    }

    // MARK: - Sidebar Score Widget

    private var scoreWidget: some View {
        HStack(alignment: .center, spacing: OathenSpacing.sm) {
            ScoreRing(
                progress: Double(todayViewModel.score.totalScore) / 100.0,
                score: todayViewModel.score.totalScore,
                size: 36
            )
            VStack(alignment: .leading, spacing: 2) {
                Text("Discipline Score")
                    .font(OathenTypography.bodySmall)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Text("\(todayViewModel.score.totalScore)")
                    .font(OathenTypography.headingMedium)
                    .foregroundStyle(OathenColors.accent)
                    .contentTransition(.numericText())
                    .animation(.easeInOut(duration: 0.3), value: todayViewModel.score.totalScore)
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
                } else {
                    macPlaceholderContent(for: item)
                }
            }
            .padding(OathenSpacing.lg)
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
                        .lineLimit(1)
                    Text(item.subtitle)
                        .font(OathenTypography.bodySmall)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                .layoutPriority(1)
            }
        }
    }

    // MARK: - Non-Today Placeholder Content

    @ViewBuilder
    private func macPlaceholderContent(for item: MacSidebarItem) -> some View {
        switch item {
        case .goals:
            macGoalsPlaceholder
        case .coach:
            macCoachPlaceholder
        case .health:
            macHealthPlaceholder
        case .you:
            macYouPlaceholder
        default:
            EmptyView()
        }
    }

    private var macGoalsPlaceholder: some View {
        VStack(alignment: .leading, spacing: OathenSpacing.sm) {
            OathenSectionHeader(title: "Primary Commitment")
            OathenCard {
                VStack(alignment: .leading, spacing: OathenSpacing.sm) {
                    HStack {
                        Text("Improve physical condition")
                            .font(OathenTypography.headingMedium)
                        Spacer()
                        PriorityBadge(priority: .critical)
                    }
                    Text("Daily actions connect back to this goal.")
                        .font(OathenTypography.bodySmall)
                        .foregroundStyle(.secondary)
                }
            }
            OathenCard {
                VStack(alignment: .leading, spacing: OathenSpacing.sm) {
                    HStack {
                        Text("Finish DJHQ")
                            .font(OathenTypography.headingMedium)
                        Spacer()
                        PriorityBadge(priority: .high)
                    }
                    Text("Daily actions connect back to this goal.")
                        .font(OathenTypography.bodySmall)
                        .foregroundStyle(.secondary)
                }
            }

            OathenSectionHeader(title: "Projects")
                .padding(.top, OathenSpacing.xs)
            macInfoCard(
                icon: "folder.fill",
                title: "Projects will live here",
                detail: "Each goal breaks into projects, habits, and critical tasks."
            )

            OathenSectionHeader(title: "Habits")
                .padding(.top, OathenSpacing.xs)
            macInfoCard(
                icon: "repeat.circle.fill",
                title: "Recurring habits connect to goals",
                detail: "Habits tracked daily in Today will roll up to goal progress here."
            )

            macNotActiveNote("Goals are not editable yet. Today is active first.")
        }
    }

    private var macCoachPlaceholder: some View {
        VStack(alignment: .leading, spacing: OathenSpacing.sm) {
            OathenSectionHeader(title: "Accountability Coach")
            macInfoCard(
                icon: "brain.head.profile",
                title: "Not a generic chatbot",
                detail: "The Coach is strict and context-aware. It confronts excuses, detects weak patterns, and generates recovery plans."
            )
            macInfoCard(
                icon: "exclamationmark.bubble.fill",
                title: "Patterns and excuses",
                detail: "Repeated rationalizations will be flagged. The Coach will not accept 'too tired' without a plan."
            )
            macInfoCard(
                icon: "brain",
                title: "Local rule-based nudges active now",
                detail: "Today already shows rule-based coach nudges. AI coaching connects after the daily routine is stable."
            )
            macNotActiveNote("AI Coach connection comes later. Today uses local rules.")
        }
    }

    private var macHealthPlaceholder: some View {
        VStack(alignment: .leading, spacing: OathenSpacing.sm) {
            OathenSectionHeader(title: "Health Pillars")
            macInfoCard(
                icon: "drop.fill",
                title: "Hydration target",
                detail: "3L daily target. Logged manually in Today for now."
            )
            macInfoCard(
                icon: "figure.run",
                title: "Exercise target",
                detail: "45 min daily target. Logged manually in Today for now."
            )
            macInfoCard(
                icon: "moon.fill",
                title: "Sleep target",
                detail: "7.5h nightly target. Logged during Night Review."
            )
            macInfoCard(
                icon: "applewatch",
                title: "HealthKit connects later",
                detail: "Apple Watch and HealthKit validation arrives after the daily routine is stable."
            )
            macNotActiveNote("Health data is local-only. HealthKit integration comes later.")
        }
    }

    private var macYouPlaceholder: some View {
        VStack(alignment: .leading, spacing: OathenSpacing.sm) {
            OathenSectionHeader(title: "Profile")
            macInfoCard(
                icon: "person.fill",
                title: "Profile",
                detail: "Name, timezone, and accountability preferences will live here."
            )
            OathenSectionHeader(title: "Privacy")
                .padding(.top, OathenSpacing.xs)
            macInfoCard(
                icon: "lock.shield.fill",
                title: "Privacy controls",
                detail: "All data is local-first by default. Cloud sync is opt-in per category."
            )
            macInfoCard(
                icon: "person.2.fill",
                title: "Accountability settings",
                detail: "Configure what your accountability partner can see — nothing by default."
            )
            macNotActiveNote("Profile and settings are not active yet.")
        }
    }

    private func macInfoCard(icon: String, title: String, detail: String) -> some View {
        OathenCard {
            HStack(alignment: .top, spacing: OathenSpacing.md) {
                Image(systemName: icon)
                    .foregroundStyle(OathenColors.accent.opacity(0.7))
                    .font(.body)
                    .frame(width: 20)
                VStack(alignment: .leading, spacing: OathenSpacing.xs) {
                    Text(title)
                        .font(OathenTypography.headingSmall)
                    Text(detail)
                        .font(OathenTypography.bodySmall)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    private func macNotActiveNote(_ text: String) -> some View {
        HStack(spacing: OathenSpacing.xs) {
            Image(systemName: "info.circle")
                .font(OathenTypography.bodySmall)
                .foregroundStyle(.tertiary)
            Text(text)
                .font(OathenTypography.bodySmall)
                .foregroundStyle(.tertiary)
        }
        .padding(.top, OathenSpacing.xs)
    }

    // MARK: - Today Content (Mac-adapted, not stretched iPhone)

    private var macTodayContent: some View {
        VStack(alignment: .leading, spacing: OathenSpacing.sectionGap) {
            macCheckInBar
            macDailyPlanSection
            macHealthPillars
            macCoachNudge
        }
    }

    private var macCheckInBar: some View {
        OathenCard {
            HStack(spacing: OathenSpacing.lg) {
                checkInPill(
                    label: "Morning Check-in",
                    icon: "sun.horizon.fill",
                    complete: todayViewModel.isMorningCheckInComplete
                )
                Divider().frame(height: 24)
                checkInPill(
                    label: "Night Review",
                    icon: "moon.stars.fill",
                    complete: todayViewModel.isNightReviewComplete
                )
                Spacer()
                Text(todayViewModel.contextMode.displayName)
                    .font(OathenTypography.bodySmall)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, OathenSpacing.sm)
                    .padding(.vertical, 4)
                    .background(OathenColors.tertiaryFill)
                    .clipShape(Capsule())
            }
        }
    }

    private func checkInPill(label: String, icon: String, complete: Bool) -> some View {
        HStack(spacing: OathenSpacing.xs) {
            Image(systemName: complete ? "checkmark.circle.fill" : icon)
                .foregroundStyle(complete ? OathenColors.success : .secondary)
                .font(.body)
            Text(label)
                .font(OathenTypography.bodySmall)
                .foregroundStyle(complete ? .primary : .secondary)
        }
    }

    private var macDailyPlanSection: some View {
        VStack(alignment: .leading, spacing: OathenSpacing.sm) {
            OathenSectionHeader(title: "Today's Commitments")
            VStack(spacing: OathenSpacing.xs) {
                ForEach(todayViewModel.dailyPlan.items.filter {
                    $0.kind == .criticalTask || $0.kind == .habit
                }) { item in
                    macPlanItemRow(item)
                }
            }
        }
    }

    private func macPlanItemRow(_ item: DailyPlanItem) -> some View {
        OathenCard {
            HStack(spacing: OathenSpacing.md) {
                Image(systemName: item.isComplete ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(item.isComplete ? OathenColors.success : itemPriorityColor(item.priority))
                    .font(.body)
                Text(item.title)
                    .font(OathenTypography.bodyMedium)
                    .strikethrough(item.isComplete, color: .secondary)
                    .foregroundStyle(item.isComplete ? .secondary : .primary)
                Spacer()
                Text(item.priority.displayName.uppercased())
                    .font(OathenTypography.priorityLabel)
                    .foregroundStyle(.white)
                    .padding(.horizontal, OathenSpacing.sm)
                    .padding(.vertical, OathenSpacing.xs)
                    .background(itemPriorityColor(item.priority))
                    .clipShape(Capsule())
            }
        }
    }

    private func itemPriorityColor(_ priority: Priority) -> Color {
        switch priority {
        case .critical: OathenColors.critical
        case .high:     OathenColors.high
        default:        OathenColors.normal
        }
    }

    private var macHealthPillars: some View {
        VStack(alignment: .leading, spacing: OathenSpacing.sm) {
            OathenSectionHeader(title: "Health Pillars")
            OathenCard {
                VStack(spacing: OathenSpacing.lg) {
                    let plan = todayViewModel.dailyPlan
                    macPillarRow(
                        label: "Hydration",
                        target: "\(String(format: "%.1f", plan.hydrationTargetLiters)) L",
                        complete: plan.hydrationCompleted,
                        color: OathenColors.hydration
                    )
                    Divider()
                    macPillarRow(
                        label: "Exercise",
                        target: "\(plan.exerciseTargetMinutes) min",
                        complete: plan.exerciseCompleted,
                        color: OathenColors.exercise
                    )
                    Divider()
                    macPillarRow(
                        label: "Sleep",
                        target: "\(String(format: "%.1f", plan.sleepTargetHours)) h",
                        complete: plan.sleepRoutineStarted,
                        color: OathenColors.sleep
                    )
                }
            }
        }
    }

    private func macPillarRow(label: String, target: String, complete: Bool, color: Color) -> some View {
        HStack {
            Image(systemName: complete ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(complete ? OathenColors.success : color)
            Text(label)
                .font(OathenTypography.bodyMedium)
                .foregroundStyle(complete ? .secondary : .primary)
            Spacer()
            Text(target)
                .font(OathenTypography.monoData)
                .foregroundStyle(.secondary)
        }
    }

    private var macCoachNudge: some View {
        OathenCard {
            HStack(alignment: .top, spacing: OathenSpacing.md) {
                Image(systemName: "brain.head.profile")
                    .foregroundStyle(OathenColors.accent)
                    .font(.title3)
                VStack(alignment: .leading, spacing: OathenSpacing.xs) {
                    Text("Coach")
                        .font(OathenTypography.headingSmall)
                        .foregroundStyle(OathenColors.accent)
                    Text(todayViewModel.coachNudge)
                        .font(OathenTypography.bodySmall)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
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
            Text("Detail panel")
                .font(OathenTypography.headingMedium)
                .foregroundStyle(.secondary)
            Text("Select an item to inspect goals, routines, evidence, or accountability details once those modules are active.")
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
        .environment(TodayViewModel())
        .frame(minWidth: 1000, minHeight: 660)
        .preferredColorScheme(.dark)
}
#endif
