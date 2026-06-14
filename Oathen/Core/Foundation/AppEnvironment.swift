// Sprint 1 — App-wide environment shell.
// No real state yet. Will grow in Sprint 2+.
import SwiftUI
import Observation

@MainActor
@Observable
final class AppEnvironment {
    var selectedTab: OathenTab = .today
    var isOnline: Bool = true

    // Sprint markers (read-only)
    static let currentSprint = 3
    static let productName   = "Oathen"
    static let internalName  = "Discipline OS"
}
