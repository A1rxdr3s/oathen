import SwiftUI
import SwiftData
#if canImport(UIKit)
import UIKit
#endif

@main
struct OathenApp: App {
    private let modelContainer: ModelContainer
    @State private var todayViewModel: TodayViewModel

    init() {
        #if canImport(UIKit)
        // iOS 26: the floating glass tab bar may not propagate bottom safe area to scroll
        // views automatically. Force .always so every UIScrollView (including SwiftUI's
        // ScrollView) respects the tab bar height as a content inset.
        UIScrollView.appearance().contentInsetAdjustmentBehavior = .always
        #endif

        // Create the SwiftData container. If the persistent store can't be opened (e.g.
        // corrupt on-disk database), fall back to an in-memory container so the app
        // remains usable — state will reset on each launch instead of crashing.
        let container: ModelContainer
        do {
            container = try OathenModelContainer.make()
        } catch {
            print("[Oathen] Persistent container unavailable, using in-memory fallback: \(error)")
            // In-memory container has no disk I/O and will not throw.
            container = try! OathenModelContainer.make(inMemory: true)
        }
        modelContainer = container

        let store = TodayPersistenceStore(context: container.mainContext)
        _todayViewModel = State(initialValue: TodayViewModel(store: store))
    }

    var body: some Scene {
        WindowGroup {
            PlatformRouter()
                .environment(todayViewModel)
                .preferredColorScheme(.dark)
                .modelContainer(modelContainer)
        }
        #if os(macOS)
        .defaultSize(width: 1100, height: 700)
        #endif
    }
}
