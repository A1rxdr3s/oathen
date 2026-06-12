import SwiftUI

/// iPhone root — 5-tab shell.
/// Sprint 1: placeholder content only.
struct OathenRootView: View {
    @State private var selectedTab: OathenTab = .today

    var body: some View {
        TabView(selection: $selectedTab) {
            TodayView()
                .tabItem { Label(OathenTab.today.rawValue, systemImage: OathenTab.today.icon) }
                .tag(OathenTab.today)

            GoalsView()
                .tabItem { Label(OathenTab.goals.rawValue, systemImage: OathenTab.goals.icon) }
                .tag(OathenTab.goals)

            CoachView()
                .tabItem { Label(OathenTab.coach.rawValue, systemImage: OathenTab.coach.icon) }
                .tag(OathenTab.coach)

            HealthView()
                .tabItem { Label(OathenTab.health.rawValue, systemImage: OathenTab.health.icon) }
                .tag(OathenTab.health)

            YouView()
                .tabItem { Label(OathenTab.you.rawValue, systemImage: OathenTab.you.icon) }
                .tag(OathenTab.you)
        }
    }
}
