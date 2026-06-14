import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

@main
struct OathenApp: App {
    @State private var todayViewModel = TodayViewModel()

    init() {
        #if canImport(UIKit)
        // iOS 26: the floating glass tab bar may not propagate bottom safe area to scroll
        // views automatically. Force .always so every UIScrollView (including SwiftUI's
        // ScrollView) respects the tab bar height as a content inset.
        UIScrollView.appearance().contentInsetAdjustmentBehavior = .always
        #endif
    }

    var body: some Scene {
        WindowGroup {
            PlatformRouter()
                .environment(todayViewModel)
                .preferredColorScheme(.dark)
        }
        #if os(macOS)
        .defaultSize(width: 1100, height: 700)
        #endif
    }
}
