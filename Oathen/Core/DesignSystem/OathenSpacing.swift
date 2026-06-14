// Sprint 1 — Design tokens: spacing (8pt grid)
import SwiftUI

enum OathenSpacing {
    static let xs:   CGFloat = 4    // space.1
    static let sm:   CGFloat = 8    // space.2
    static let md:   CGFloat = 12   // space.3
    static let lg:   CGFloat = 16   // space.4
    static let xl:   CGFloat = 20   // space.5
    static let xxl:  CGFloat = 24   // space.6
    static let xxxl: CGFloat = 32   // space.8
    static let huge: CGFloat = 40   // space.10

    // Layout
    static let screenHorizontal: CGFloat = 16
    static let cardH:            CGFloat = 16
    static let cardV:            CGFloat = 12
    static let sectionGap:       CGFloat = 24
    static let tabContentTop:    CGFloat = 16   // top inset below status bar for bare ScrollView tabs
    static let tabScrollBottom:  CGFloat = 140 // clearance above iOS 26 floating glass tab bar
}
