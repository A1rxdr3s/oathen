import Foundation

enum NightReviewMapper {

    // MARK: - Domain → Persistent

    @MainActor
    static func toPersistent(_ review: NightReview) -> PersistentNightReview {
        PersistentNightReview(
            domainID: review.id,
            date: review.date,
            completedCriticalTaskIDsJSON: UUIDArrayCoding.encode(review.completedCriticalTaskIDs),
            missedCriticalTaskIDsJSON: UUIDArrayCoding.encode(review.missedCriticalTaskIDs),
            completedHabitIDsJSON: UUIDArrayCoding.encode(review.completedHabitIDs),
            missedHabitIDsJSON: UUIDArrayCoding.encode(review.missedHabitIDs),
            hydrationCompleted: review.hydrationCompleted,
            exerciseCompleted: review.exerciseCompleted,
            sleepRoutineStarted: review.sleepRoutineStarted,
            failureReason: review.failureReason,
            excuseDetected: review.excuseDetected,
            recoveryPlan: review.recoveryPlan,
            completedAt: review.completedAt,
            createdAt: review.createdAt,
            updatedAt: review.updatedAt
        )
    }

    // MARK: - Persistent → Domain

    @MainActor
    static func toDomain(_ p: PersistentNightReview) -> NightReview {
        NightReview(
            id: p.domainID,
            date: p.date,
            completedCriticalTaskIDs: UUIDArrayCoding.decode(p.completedCriticalTaskIDsJSON),
            missedCriticalTaskIDs: UUIDArrayCoding.decode(p.missedCriticalTaskIDsJSON),
            completedHabitIDs: UUIDArrayCoding.decode(p.completedHabitIDsJSON),
            missedHabitIDs: UUIDArrayCoding.decode(p.missedHabitIDsJSON),
            hydrationCompleted: p.hydrationCompleted,
            exerciseCompleted: p.exerciseCompleted,
            sleepRoutineStarted: p.sleepRoutineStarted,
            failureReason: p.failureReason,
            excuseDetected: p.excuseDetected,
            recoveryPlan: p.recoveryPlan,
            completedAt: p.completedAt,
            createdAt: p.createdAt,
            updatedAt: p.updatedAt
        )
    }
}
