import SwiftUI

@main
struct OathenApp: App {
    var body: some Scene {
        WindowGroup {
            PlatformRouter()
        }
        #if os(macOS)
        // Set a stable default launch size so the NavigationSplitView columns
        // are not compressed on first open. Sprint 1 shell only.
        .defaultSize(width: 1100, height: 700)
        #endif
    }
}
