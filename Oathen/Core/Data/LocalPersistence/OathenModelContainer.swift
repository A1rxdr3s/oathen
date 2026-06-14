import Foundation
import SwiftData

enum OathenModelContainer {
    static func make(inMemory: Bool = false) throws -> ModelContainer {
        let schema = Schema([
            PersistentTodayState.self,
            PersistentDailyPlan.self,
            PersistentDailyPlanItem.self,
            PersistentMorningCheckIn.self,
            PersistentNightReview.self,
        ])
        let config = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: inMemory
        )
        return try ModelContainer(for: schema, configurations: [config])
    }
}
