import Foundation

enum MorningCheckInMapper {

    // MARK: - Domain → Persistent

    @MainActor
    static func toPersistent(_ checkIn: MorningCheckIn) -> PersistentMorningCheckIn {
        PersistentMorningCheckIn(
            domainID: checkIn.id,
            date: checkIn.date,
            sleepHours: checkIn.sleepHours,
            energyLevelRaw: checkIn.energyLevel.rawValue,
            focusLevelRaw: checkIn.focusLevel.rawValue,
            moodRaw: checkIn.mood.rawValue,
            mainObstacle: checkIn.mainObstacle,
            selectedContextModeRaw: checkIn.selectedContextMode.rawValue,
            confirmedHydrationGoal: checkIn.confirmedHydrationGoal,
            confirmedExerciseGoal: checkIn.confirmedExerciseGoal,
            confirmedCriticalTaskIDsJSON: UUIDArrayCoding.encode(checkIn.confirmedCriticalTaskIDs),
            completedAt: checkIn.completedAt,
            createdAt: checkIn.createdAt,
            updatedAt: checkIn.updatedAt
        )
    }

    // MARK: - Persistent → Domain

    @MainActor
    static func toDomain(_ p: PersistentMorningCheckIn) -> MorningCheckIn? {
        guard
            let energy = EnergyLevel(rawValue: p.energyLevelRaw),
            let focus = FocusLevel(rawValue: p.focusLevelRaw),
            let mood = MoodLevel(rawValue: p.moodRaw),
            let contextMode = ContextMode(rawValue: p.selectedContextModeRaw)
        else { return nil }

        return MorningCheckIn(
            id: p.domainID,
            date: p.date,
            sleepHours: p.sleepHours,
            energyLevel: energy,
            focusLevel: focus,
            mood: mood,
            mainObstacle: p.mainObstacle,
            selectedContextMode: contextMode,
            confirmedHydrationGoal: p.confirmedHydrationGoal,
            confirmedExerciseGoal: p.confirmedExerciseGoal,
            confirmedCriticalTaskIDs: UUIDArrayCoding.decode(p.confirmedCriticalTaskIDsJSON),
            completedAt: p.completedAt,
            createdAt: p.createdAt,
            updatedAt: p.updatedAt
        )
    }
}
