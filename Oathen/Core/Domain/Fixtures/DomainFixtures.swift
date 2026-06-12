// Sprint 2 — DomainFixtures.
// Static sample domain data for SwiftUI previews and UI placeholder screens.
// No real user data. No persistence. Replace with real SwiftData in Sprint 3+.
// Fixed dates use timeIntervalSince1970 for determinism across runs.
import Foundation

enum DomainFixtures {

    // Reference epoch: approximately 2025-06-15 00:00 UTC
    private static let t0: TimeInterval = 1_750_000_000
    private static func t(_ offset: TimeInterval) -> Date { Date(timeIntervalSince1970: t0 + offset) }

    // MARK: - Goals

    static let physicalConditionGoal = Goal(
        id: UUID(uuidString: "F1000001-0000-0000-0000-000000000000")!,
        title: "Improve physical condition",
        description: "Build strength, endurance, and daily consistency over 90 days.",
        category: .fitness,
        targetDate: t(90 * 86_400),
        status: .active,
        priority: .high,
        progressPercent: 28,
        evidenceRequired: true,
        isPrivate: false,
        projectIDs: [],
        tags: ["fitness", "health"],
        createdAt: t(0),
        updatedAt: t(0)
    )

    static let musicGoal = Goal(
        id: UUID(uuidString: "F1000002-0000-0000-0000-000000000000")!,
        title: "Release music project",
        description: "Complete DJHQ and prepare music release.",
        category: .creative,
        targetDate: t(60 * 86_400),
        status: .active,
        priority: .high,
        progressPercent: 15,
        evidenceRequired: false,
        isPrivate: false,
        projectIDs: [],
        tags: ["music", "creative"],
        createdAt: t(0),
        updatedAt: t(0)
    )

    // MARK: - Project

    static let djhqProject = Project(
        id: UUID(uuidString: "F2000001-0000-0000-0000-000000000000")!,
        goalID: musicGoal.id,
        title: "Finish DJHQ",
        description: "Complete the DJHQ music project end-to-end.",
        status: .active,
        priority: .high,
        startDate: t(0),
        targetDate: t(60 * 86_400),
        tags: ["music", "creative"],
        taskIDs: [],
        habitIDs: [],
        createdAt: t(0),
        updatedAt: t(0)
    )

    // MARK: - Habits

    static let morningWorkoutHabit = Habit(
        id: UUID(uuidString: "F3000001-0000-0000-0000-000000000000")!,
        projectID: nil,
        title: "Morning workout",
        description: "At least 30 minutes of exercise before 10am.",
        recurrence: .daily,
        priority: .critical,
        evidenceRequirement: .required,
        currentStreak: 12,
        bestStreak: 21,
        status: .active,
        createdAt: t(0),
        updatedAt: t(0)
    )

    static let hydrationHabit = Habit(
        id: UUID(uuidString: "F3000002-0000-0000-0000-000000000000")!,
        projectID: nil,
        title: "Hydration (3L)",
        description: "Drink at least 3L of water per day.",
        recurrence: .daily,
        priority: .high,
        evidenceRequirement: .optional,
        currentStreak: 8,
        bestStreak: 15,
        status: .active,
        createdAt: t(0),
        updatedAt: t(0)
    )

    static let eveningReviewHabit = Habit(
        id: UUID(uuidString: "F3000003-0000-0000-0000-000000000000")!,
        projectID: nil,
        title: "Evening review",
        description: "10-minute night review before sleep.",
        recurrence: .daily,
        priority: .normal,
        evidenceRequirement: .none,
        currentStreak: 5,
        bestStreak: 12,
        status: .active,
        createdAt: t(0),
        updatedAt: t(0)
    )

    static let sampleHabits: [Habit] = [morningWorkoutHabit, hydrationHabit, eveningReviewHabit]

    // MARK: - Tasks

    static let criticalTask = OathenTask(
        id: UUID(uuidString: "F4000001-0000-0000-0000-000000000000")!,
        projectID: nil,
        habitID: morningWorkoutHabit.id,
        title: "Complete morning workout session",
        notes: "Photo evidence required.",
        priority: .critical,
        status: .pending,
        dueDate: t(8 * 3600),          // due in 8 hours from t0
        estimatedMinutes: 45,
        evidenceRequirement: .required,
        createdAt: t(0),
        updatedAt: t(0)
    )

    static let highPriorityTask = OathenTask(
        id: UUID(uuidString: "F4000002-0000-0000-0000-000000000000")!,
        projectID: djhqProject.id,
        habitID: nil,
        title: "Record DJHQ track structure",
        notes: nil,
        priority: .high,
        status: .pending,
        dueDate: t(24 * 3600),
        estimatedMinutes: 60,
        evidenceRequirement: .none,
        createdAt: t(0),
        updatedAt: t(0)
    )

    static let sampleTasks: [OathenTask] = [criticalTask, highPriorityTask]

    // MARK: - Routine

    static let morningCheckIn = Routine(
        id: UUID(uuidString: "F5000001-0000-0000-0000-000000000000")!,
        title: "Morning Check-in",
        type: .morningCheckIn,
        steps: [
            RoutineStep(
                id: UUID(uuidString: "F6000001-0000-0000-0000-000000000000")!,
                title: "Review critical tasks",
                description: "Identify what must happen today.",
                order: 1,
                status: .pending,
                evidenceRequirement: .none
            ),
            RoutineStep(
                id: UUID(uuidString: "F6000002-0000-0000-0000-000000000000")!,
                title: "Log sleep hours",
                description: "Enter last night's sleep duration.",
                order: 2,
                status: .pending,
                evidenceRequirement: .none
            ),
            RoutineStep(
                id: UUID(uuidString: "F6000003-0000-0000-0000-000000000000")!,
                title: "Confirm hydration goal",
                description: "Set today's water intake target.",
                order: 3,
                status: .pending,
                evidenceRequirement: .none
            )
        ],
        status: .pending,
        createdAt: t(0),
        updatedAt: t(0)
    )

    // MARK: - Discipline Score

    static let sampleDisciplineScore = DisciplineScore(
        id: UUID(uuidString: "F7000001-0000-0000-0000-000000000000")!,
        date: t(0),
        totalScore: 74,
        breakdown: ScoreBreakdown(
            criticalTaskScore: 40,
            highTaskScore: 14,
            habitScore: 12,
            hydrationScore: 4,
            exerciseScore: 3,
            sleepScore: 1
        ),
        contextMode: .normal,
        createdAt: t(0),
        updatedAt: t(0)
    )

    // MARK: - Context Mode

    static let defaultContextMode: ContextMode = .normal
}
