import SwiftUI

/// Routes to the platform-appropriate root view.
/// iPhone → OathenRootView (TabView)
/// macOS  → MacDashboardView (NavigationSplitView)
struct PlatformRouter: View {
    var body: some View {
        #if os(macOS)
        MacDashboardView()
        #else
        OathenRootView()
        #endif
    }
}
