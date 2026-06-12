import SwiftUI

enum OathenTab: String, CaseIterable {
    case today  = "Today"
    case goals  = "Goals"
    case coach  = "Coach"
    case health = "Health"
    case you    = "You"

    var icon: String {
        switch self {
        case .today:  "circle.grid.cross.fill"
        case .goals:  "target"
        case .coach:  "brain.head.profile"
        case .health: "heart.fill"
        case .you:    "person.fill"
        }
    }
}
