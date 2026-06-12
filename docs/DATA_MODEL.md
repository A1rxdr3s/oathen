# DATA_MODEL.md — Oathen / Discipline OS
## Complete Data Model Reference

**Legend:**
- **Storage:** `Local` = device only | `Cloud` = Supabase sync | `Hybrid` = local default, cloud opt-in
- **Sensitivity:** `Public` = non-sensitive | `Private` = user-controlled | `Sensitive` = restricted by default | `Critical` = never auto-uploaded
- **Sync:** `Auto` = synced automatically | `OptIn` = user must enable | `Never` = never synced
- **Implementation:** `✅ Sprint 2` = pure Swift domain struct exists | `⏳ Planned` = documented, not yet implemented | `🔒 Gated` = feasibility-gated

---

## Sprint 2 Implementation Status

| Entity | Swift File | Status |
|---|---|---|
| `Goal` | `Domain/Models/Goal.swift` | ✅ Sprint 2 — pure Swift struct |
| `Project` | `Domain/Models/Project.swift` | ✅ Sprint 2 — pure Swift struct |
| `Habit` | `Domain/Models/Habit.swift` | ✅ Sprint 2 — pure Swift struct |
| `OathenTask` | `Domain/Models/OathenTask.swift` | ✅ Sprint 2 — pure Swift struct |
| `Routine` | `Domain/Models/Routine.swift` | ✅ Sprint 2 — pure Swift struct |
| `RoutineStep` | `Domain/Models/RoutineStep.swift` | ✅ Sprint 2 — pure Swift struct |
| `Evidence` | `Domain/Models/Evidence.swift` | ✅ Sprint 2 — concept only, no photo storage |
| `DisciplineScore` | `Domain/Models/DisciplineScore.swift` | ✅ Sprint 2 — shape only, no calculation engine |
| `ContextMode` | `Domain/Models/ContextMode.swift` | ✅ Sprint 2 — pure Swift enum |
| `Priority` | `Domain/ValueObjects/Priority.swift` | ✅ Sprint 2 — value object |
| `ScoreBreakdown` | `Domain/ValueObjects/ScoreBreakdown.swift` | ✅ Sprint 2 — value object |
| `RecurrenceRule` | `Domain/ValueObjects/RecurrenceRule.swift` | ✅ Sprint 2 — value object |
| `EvidenceRequirement` | `Domain/ValueObjects/EvidenceRequirement.swift` | ✅ Sprint 2 — value object |
| `DateRange` | `Domain/ValueObjects/DateRange.swift` | ✅ Sprint 2 — value object |
| `GoalStatus` / `TaskStatus` / etc. | `Domain/ValueObjects/CompletionStatus.swift` | ✅ Sprint 2 — 6 status enums |
| `User` | — | ⏳ Planned — Sprint 8 (auth) |
| `AuthProvider` | — | ⏳ Planned — Sprint 8 |
| `DailyPlan` | — | ⏳ Planned — Sprint 3 |
| `MorningCheckIn` | — | ⏳ Planned — Sprint 3 |
| `NightReview` | — | ⏳ Planned — Sprint 3 |
| `WeeklyReview` | — | ⏳ Planned — Sprint 3 |
| `HydrationLog` | — | ⏳ Planned — Sprint 5 |
| `ExerciseSession` | — | ⏳ Planned — Sprint 4 |
| `SleepLog` | — | ⏳ Planned — Sprint 4 |
| `HealthMetric` | — | ⏳ Planned — Sprint 4 |
| `BodyProgressPhoto` | — | ⏳ Planned — Sprint 5 (local-only, biometric gated) |
| `BodyMetric` | — | ⏳ Planned — Sprint 5 |
| `AICoachMessage` | — | ⏳ Planned — Sprint 7 |
| `AICoachMemory` | — | ⏳ Planned — Sprint 7 |
| `AIInsight` | — | ⏳ Planned — Sprint 7 |
| `NotificationRule` | — | ⏳ Planned — Sprint 6 |
| `EscalationRule` | — | ⏳ Planned — Sprint 6 |
| `FocusSession` | — | ⏳ Planned — Sprint 11 |
| `SyncState` | — | ⏳ Planned — Sprint 8 |
| `AccountabilityPartner` | — | ⏳ Planned — Sprint 12 |
| `PermissionPolicy` | — | ⏳ Planned — Sprint 12 |
| `DeviceActivityMonitor` | — | 🔒 Gated — Sprint 11 (entitlement required) |

> **Note:** Sprint 2 establishes the domain language. The entities above that are "Planned" exist in Sprint 0 documentation and will be implemented in their respective sprints. No persistence, sync, or backend schemas exist yet.

---

## Core User Entities

### User
**Purpose:** Primary user account and preferences.

| Field | Type | Notes |
|---|---|---|
| localID | UUID | Device-generated, permanent |
| remoteID | String? | Supabase row ID after sync |
| displayName | String | Public display name |
| email | String? | From auth provider |
| timezone | String | IANA timezone identifier |
| locale | String | Locale for formatting |
| createdAt | Date | Account creation |
| updatedAt | Date | Last modification |
| privacySettingID | UUID | → PrivacySetting |
| syncStateID | UUID | → SyncState |

- **Storage:** Hybrid | **Sensitivity:** Private | **Sync:** Auto (non-sensitive fields only)
- **Relationships:** One-to-one with PrivacySetting; one-to-many with all domain entities.

---

### AuthProvider
**Purpose:** Track authentication providers linked to account.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | → User |
| provider | Enum | `.apple`, `.google` |
| providerUID | String | External provider user ID |
| email | String? | Provider email |
| linkedAt | Date | |
| isActive | Bool | |

- **Storage:** Cloud | **Sensitivity:** Private | **Sync:** Auto

---

## Goals / Projects / Habits / Tasks Hierarchy

### Goal
**Purpose:** Top-level personal commitment. An oath.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | → User |
| title | String | |
| description | String? | |
| category | Enum | `.health`, `.work`, `.creative`, `.personal`, `.fitness`, `.custom` |
| targetDate | Date? | |
| status | Enum | `.active`, `.completed`, `.paused`, `.abandoned` |
| priority | Enum | `.critical`, `.high`, `.normal`, `.low` |
| progressPercent | Double | 0-100 |
| aiSuggestedPriority | Enum? | AI-computed, user can override |
| evidenceRequired | Bool | |
| isPrivate | Bool | Hidden from accountability partner |
| createdAt | Date | |
| updatedAt | Date | |

- **Storage:** Hybrid | **Sensitivity:** Private | **Sync:** Auto
- **Relationships:** One-to-many with Project; one-to-many with AIInsight.

---

### Project
**Purpose:** Structured effort under a Goal. Examples: "Finish DJHQ", "Prepare music release".

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| goalID | UUID? | → Goal (optional, standalone project allowed) |
| templateID | UUID? | → Template if created from one |
| title | String | |
| description | String? | |
| status | Enum | `.active`, `.completed`, `.paused`, `.archived` |
| startDate | Date? | |
| targetDate | Date? | |
| priority | Enum | |
| tags | [String] | |
| createdAt | Date | |
| updatedAt | Date | |

- **Storage:** Hybrid | **Sensitivity:** Private | **Sync:** Auto
- **Relationships:** Belongs to Goal (optional); one-to-many with Habit and Task.

---

### Habit
**Purpose:** Recurring behavior tied to a Goal or Project.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| projectID | UUID? | |
| goalID | UUID? | |
| title | String | |
| description | String? | |
| frequency | Enum | `.daily`, `.weekly`, `.custom` |
| scheduledDays | [Int]? | 0=Sunday...6=Saturday for weekly |
| scheduledTime | Date? | Time-of-day only |
| duration | Int? | Minutes |
| evidenceRequired | Bool | |
| evidenceType | Enum? | `.photo`, `.metric`, `.checkmark`, `.manual` |
| isActive | Bool | |
| streakCount | Int | Current streak |
| longestStreak | Int | All-time |
| lastCompletedAt | Date? | |
| createdAt | Date | |
| updatedAt | Date | |

- **Storage:** Hybrid | **Sensitivity:** Private | **Sync:** Auto
- **Relationships:** Belongs to Project or Goal; one-to-many with Evidence.

---

### Task
**Purpose:** Discrete unit of work with optional evidence requirement.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| projectID | UUID? | |
| habitID | UUID? | Recurring instance |
| parentTaskID | UUID? | For subtasks |
| title | String | |
| description | String? | |
| priority | Enum | `.critical`, `.high`, `.normal`, `.low`, `.blocked` |
| aiPriority | Enum? | AI-computed |
| aiPriorityOverridden | Bool | User overrode AI suggestion |
| status | Enum | `.pending`, `.inProgress`, `.completed`, `.postponed`, `.cancelled` |
| scheduledDate | Date? | |
| deadline | Date? | |
| completedAt | Date? | |
| estimatedMinutes | Int? | |
| actualMinutes | Int? | |
| energyRequired | Enum? | `.low`, `.medium`, `.high` |
| evidenceRequired | Bool | |
| evidenceType | Enum? | |
| postponeCount | Int | AI tracks repeated postponement |
| postponeReason | String? | Last reason |
| isRecurring | Bool | |
| recurrenceRule | String? | iCal RRULE format |
| contextMode | Enum? | Required context for relevance |
| goalAssociation | UUID? | → Goal |
| createdAt | Date | |
| updatedAt | Date | |

- **Storage:** Local | **Sensitivity:** Private | **Sync:** Auto (non-sensitive fields)
- **Relationships:** Belongs to Project/Habit; one-to-many with Evidence.

---

## Routines

### Routine
**Purpose:** Named daily/weekly routine structure.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| name | String | e.g., "Morning Routine", "Night Review" |
| type | Enum | `.morning`, `.evening`, `.weekly`, `.custom` |
| scheduledTime | Date? | |
| isActive | Bool | |
| contextMode | Enum? | Which modes activate this routine |
| templateID | UUID? | If from a template |
| createdAt | Date | |
| updatedAt | Date | |

- **Storage:** Hybrid | **Sensitivity:** Private | **Sync:** Auto

---

### RoutineStep
**Purpose:** Individual step within a Routine.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| routineID | UUID | → Routine |
| order | Int | Display order |
| title | String | |
| stepType | Enum | `.task`, `.habit`, `.prompt`, `.metric`, `.review` |
| linkedEntityID | UUID? | → Task or Habit |
| durationMinutes | Int? | |
| isRequired | Bool | |
| evidenceRequired | Bool | |

- **Storage:** Local | **Sensitivity:** Private | **Sync:** Auto

---

### MorningCheckIn
**Purpose:** Daily morning review and intention-setting.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| date | Date | Day this check-in covers |
| sleepHours | Double? | Self-reported or HealthKit |
| sleepQuality | Int? | 1-5 |
| energyLevel | Int? | 1-5 |
| focusLevel | Int? | 1-5 |
| mood | Int? | 1-5 |
| mainObstacle | String? | |
| dailyIntention | String? | |
| exerciseGoalConfirmed | Bool | |
| hydrationGoalConfirmed | Bool | |
| criticalTasksReviewed | Bool | |
| contextModeSet | Enum? | Active mode for the day |
| planApproved | Bool | |
| aiPlanSuggestionID | UUID? | → AIInsight |
| completedAt | Date? | |
| duration | Int? | Minutes |

- **Storage:** Local | **Sensitivity:** Private | **Sync:** Never (journal nature)
- **Note:** Summary metrics (completed/skipped) may sync for accountability partner view.

---

### NightReview
**Purpose:** End-of-day review, score closure, and recovery planning.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| date | Date | Day reviewed |
| disciplineScore | Double | Final score for the day |
| tasksCompleted | Int | |
| tasksPostponed | Int | |
| tasksFailed | Int | |
| habitsCompleted | Int | |
| habitsSkipped | Int | |
| exerciseCompleted | Bool | |
| hydrationGoalMet | Bool | |
| sleepTargetSet | Date? | Intended sleep time |
| failureJustification | String? | Private journaling |
| excusesDetected | [String]? | AI-detected excuse patterns |
| recoveryPlanID | UUID? | → AIInsight |
| tomorrowPlanApproved | Bool | |
| aiReviewSummary | String? | AI-generated insight |
| completedAt | Date? | |
| isPrivate | Bool | Default true — not shared with accountability partner |

- **Storage:** Local | **Sensitivity:** Critical | **Sync:** Never (except non-sensitive score/counts)

---

### WeeklyReview
**Purpose:** Weekly retrospective and forward planning.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| weekStartDate | Date | Monday of the week |
| averageDisciplineScore | Double | |
| streakSummary | String? | |
| topExcusePatterns | [String]? | |
| exerciseConsistency | Double | % of goal met |
| hydrationConsistency | Double | |
| sleepConsistency | Double | |
| taskCompletionRate | Double | |
| weeklyGoalsMet | Bool | |
| aiReviewSummary | String? | |
| aiRecommendations | [String]? | |
| nextWeekPlanApproved | Bool | |
| completedAt | Date? | |
| isPrivate | Bool | |

- **Storage:** Hybrid | **Sensitivity:** Sensitive | **Sync:** OptIn (summary only, no journal text)

---

## Evidence

### Evidence
**Purpose:** Abstract evidence record attached to a Task or Habit completion.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| entityType | Enum | `.task`, `.habit`, `.hydration`, `.exercise`, `.sleep` |
| entityID | UUID | → linked entity |
| evidenceType | Enum | `.photo`, `.metric`, `.manual`, `.aiValidated`, `.healthKit` |
| status | Enum | `.pending`, `.submitted`, `.validated`, `.rejected`, `.expired` |
| aiValidationScore | Double? | 0-1 confidence |
| aiValidationNotes | String? | |
| manualOverride | Bool | User overrode AI validation |
| submittedAt | Date | |
| expiresAt | Date? | Auto-delete policy |
| notes | String? | |

- **Storage:** Local | **Sensitivity:** Private | **Sync:** Never (metadata only on OptIn)

---

### PhotoEvidence
**Purpose:** Photo file reference for evidence.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| evidenceID | UUID | → Evidence |
| userID | UUID | |
| localFilePath | String | Device file path |
| remoteURL | String? | Supabase Storage URL if uploaded |
| thumbnailPath | String? | Local thumbnail |
| capturedAt | Date | |
| isSensitive | Bool | Body photos = true |
| uploadConsented | Bool | User explicitly consented to upload |
| retentionDays | Int? | Auto-delete after N days |
| encryptedLocally | Bool | |
| fileSize | Int | Bytes |
| mimeType | String | |

- **Storage:** Local | **Sensitivity:** Critical (if isSensitive=true) | **Sync:** Never unless uploadConsented=true
- **Retention:** Follows user-configured policy; body photos default to local-only.

---

## Health and Fitness

### HealthMetric
**Purpose:** Non-diagnostic health metric snapshot.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| metricType | Enum | `.weight`, `.bloodPressure`, `.restingHeartRate`, `.bodyFat`, `.custom` |
| value | Double | Numeric value |
| unit | String | kg, mmHg, bpm, % etc. |
| source | Enum | `.manual`, `.healthKit`, `.wearable` |
| measuredAt | Date | |
| notes | String? | |
| isOutOfRange | Bool? | AI/rule-based risk flag |
| riskFlag | String? | "Out of usual range" — non-diagnostic |
| consultSuggested | Bool | |

- **Storage:** Local | **Sensitivity:** Critical | **Sync:** Never
- **Safety:** No diagnostic language. `isOutOfRange` triggers "consider re-measuring" or "consider consulting a healthcare professional" — never a diagnosis.

---

### Medication
**Purpose:** Medication reminder and non-diagnostic tracking.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| name | String | Drug name |
| dosage | String | e.g., "10mg" |
| frequency | Enum | `.daily`, `.twiceDaily`, `.asNeeded`, `.custom` |
| scheduledTimes | [Date] | Time-of-day |
| prescribedFor | String? | Optional context note |
| startDate | Date? | |
| endDate | Date? | |
| isActive | Bool | |
| reminderEnabled | Bool | |
| notes | String? | |

- **Storage:** Local | **Sensitivity:** Critical | **Sync:** Never
- **Safety:** Oathen does not adjust dosages or advise stopping medications. Reminders only.

---

### MedicationLog
**Purpose:** Log of medication intake instances.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| medicationID | UUID | |
| userID | UUID | |
| scheduledAt | Date | |
| takenAt | Date? | Null = skipped |
| status | Enum | `.taken`, `.skipped`, `.deferred` |
| notes | String? | |

- **Storage:** Local | **Sensitivity:** Critical | **Sync:** Never

---

### ExerciseSession
**Purpose:** Workout session record (manual or HealthKit-sourced).

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| workoutType | String | HealthKit workout type string |
| source | Enum | `.manual`, `.healthKit`, `.watch` |
| healthKitID | String? | HKWorkout UUID if sourced |
| startedAt | Date | |
| endedAt | Date? | |
| durationMinutes | Double | |
| activeCalories | Double? | |
| heartRateAvg | Double? | |
| heartRateMax | Double? | |
| notes | String? | |
| goalAssociationID | UUID? | → Goal |
| evidenceID | UUID? | → Evidence |

- **Storage:** Hybrid | **Sensitivity:** Private | **Sync:** OptIn (aggregates only)

---

### HydrationLog
**Purpose:** Single hydration intake record.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| amountML | Double | |
| loggedAt | Date | |
| evidenceID | UUID? | Photo evidence if required |
| source | Enum | `.manual`, `.siri`, `.widget`, `.watch` |
| notes | String? | |

- **Storage:** Local | **Sensitivity:** Private | **Sync:** OptIn

---

### SleepLog
**Purpose:** Sleep session record.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| source | Enum | `.manual`, `.healthKit`, `.watch` |
| bedtime | Date | |
| wakeTime | Date | |
| durationHours | Double | Calculated |
| qualityScore | Int? | 1-5 from Watch or manual |
| deepSleepMinutes | Int? | From HealthKit if available |
| remSleepMinutes | Int? | From HealthKit if available |
| awakeningCount | Int? | |
| heartRateAvg | Double? | |
| notes | String? | |
| impactOnScore | Double? | How this affects today's capacity |

- **Storage:** Hybrid | **Sensitivity:** Private | **Sync:** OptIn (aggregates only)

---

### BodyProgressPhoto
**Purpose:** Body progress photo for transformation tracking.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| capturedAt | Date | |
| angle | Enum | `.front`, `.side`, `.back`, `.custom` |
| localFilePath | String | Device only |
| thumbnailPath | String? | Local thumbnail (blurred by default in UI) |
| encryptionKey | String? | Local encryption key reference |
| aiAnalysisConsented | Bool | Default false — explicit opt-in required |
| aiAnalysisSummary | String? | If consented and processed |
| notes | String? | |
| isBiometricLocked | Bool | Default true |

- **Storage:** Local | **Sensitivity:** Critical | **Sync:** Never
- **AI:** Analysis only if `aiAnalysisConsented = true`. Never forced by Ultra Strict Mode.
- **UI:** Thumbnails blurred by default; require biometric to reveal.

---

### BodyMetric
**Purpose:** Numeric body measurement entry.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| metricType | Enum | `.weight`, `.bodyFat`, `.waistCM`, `.chestCM`, `.armCM`, `.custom` |
| value | Double | |
| unit | String | |
| measuredAt | Date | |
| notes | String? | |

- **Storage:** Local | **Sensitivity:** Critical | **Sync:** Never

---

## AI Entities

### AIInsight
**Purpose:** AI-generated analysis, suggestion, or plan.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| insightType | Enum | `.dailyPlan`, `.weeklyReview`, `.excuseDetection`, `.goalSuggestion`, `.recoveryPlan`, `.trendAlert`, `.templateSuggestion` |
| title | String | |
| body | String | Full insight text |
| confidence | Double? | 0-1 |
| provider | Enum | `.openAI`, `.claude`, `.gemini`, `.onDevice`, `.rulesBased` |
| modelVersion | String? | |
| generatedAt | Date | |
| userApproved | Bool? | Null = not acted on |
| approvedAt | Date? | |
| linkedEntityType | String? | Entity type this relates to |
| linkedEntityID | UUID? | |
| expiresAt | Date? | |
| tokenCost | Int? | Prompt + completion tokens |
| costEventID | UUID? | → CostEvent |

- **Storage:** Hybrid | **Sensitivity:** Private | **Sync:** OptIn (summary only)

---

### AICoachMessage
**Purpose:** Message in a conversation with the AI Coach.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| sessionID | UUID | Groups messages in a session |
| role | Enum | `.user`, `.coach` |
| content | String | Message text |
| sentAt | Date | |
| provider | Enum | |
| modelVersion | String? | |
| tokenCost | Int? | |
| containsSensitiveData | Bool | Flagged if health/medication mentioned |
| redactedForSync | Bool | |

- **Storage:** Local | **Sensitivity:** Sensitive | **Sync:** Never (full conversations never synced)
- **Accountability Partner:** Never visible. Summary metrics only (e.g., "Had 3 Coach sessions this week").

---

### AICoachMemory
**Purpose:** Persistent memory context for the AI Coach across sessions.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| memoryType | Enum | `.preference`, `.pattern`, `.goal`, `.excuse`, `.context`, `.risk` |
| key | String | Memory key/topic |
| value | String | Memory value/content |
| confidence | Double | How certain the AI is |
| firstObservedAt | Date | |
| lastConfirmedAt | Date | |
| isActive | Bool | |
| source | Enum | `.observed`, `.userConfirmed`, `.aiInferred` |

- **Storage:** Local | **Sensitivity:** Critical | **Sync:** Never
- **Note:** Structured memory prevents full conversation history from being re-sent each time; reduces AI cost.

---

## Scores and Gamification

### DisciplineScore
**Purpose:** Calculated daily/weekly discipline score.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| date | Date | Day this score covers |
| score | Double | 0-100 |
| previousScore | Double? | |
| trend | Enum | `.improving`, `.stable`, `.declining` |
| breakdown | JSON | Component scores (exercise, hydration, tasks, etc.) |
| activeMode | Enum | Context mode active this day |
| ultraStrictActive | Bool | |
| adjustmentReason | String? | AI note if score was adjusted |
| calculatedAt | Date | |

- **Storage:** Hybrid | **Sensitivity:** Private | **Sync:** Auto (score value, not breakdown detail)
- **Accountability Partner:** Score trend visible if user enables it.

---

### Streak
**Purpose:** Track consecutive completion streaks.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| entityType | Enum | `.habit`, `.exercise`, `.hydration`, `.disciplineScore`, `.custom` |
| entityID | UUID? | |
| currentStreak | Int | |
| longestStreak | Int | |
| lastCompletedDate | Date | |
| startDate | Date | Current streak start |
| isBroken | Bool | |
| brokenAt | Date? | |
| freezesUsed | Int | Vacation/travel streak freezes used |

- **Storage:** Hybrid | **Sensitivity:** Private | **Sync:** Auto

---

### Achievement
**Purpose:** Serious milestone reached by the user.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| achievementKey | String | e.g., "30_day_hydration_streak" |
| title | String | |
| description | String | |
| category | Enum | `.discipline`, `.health`, `.focus`, `.consistency`, `.ultraStrict` |
| earnedAt | Date | |
| evidenceID | UUID? | Supporting evidence |
| isPersonalRecord | Bool | |
| sharedWithPartner | Bool | Default false |

- **Storage:** Hybrid | **Sensitivity:** Private | **Sync:** Auto

---

## Context and Modes

### ContextMode
**Purpose:** Active operational mode that adjusts expectations.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| modeType | Enum | `.normal`, `.travel`, `.tourWork`, `.vacation`, `.illness`, `.restDay`, `.ultraStrict`, `.postTravelRecovery` |
| startDate | Date | |
| endDate | Date? | Open-ended for ongoing |
| isManuallySet | Bool | |
| aiSuggested | Bool | |
| adjustmentSummary | String? | What changed |
| approvedByUser | Bool | |

- **Storage:** Hybrid | **Sensitivity:** Private | **Sync:** Auto

---

### TravelContext
**Purpose:** Travel-specific context detected from calendar or email.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| contextModeID | UUID | → ContextMode |
| destination | String? | |
| departureDate | Date | |
| returnDate | Date? | |
| source | Enum | `.calendar`, `.gmail`, `.wallet`, `.manual` |
| flightInfo | String? | Non-sensitive summary |
| hotelInfo | String? | |
| aiSuggestions | [String]? | Suggested task adjustments |
| userApproved | Bool | |

- **Storage:** Hybrid | **Sensitivity:** Private | **Sync:** OptIn

---

## Notifications

### NotificationRule
**Purpose:** Configured notification rule for a domain event.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| entityType | Enum | `.task`, `.habit`, `.hydration`, `.exercise`, `.checkIn`, `.review` |
| entityID | UUID? | |
| triggerType | Enum | `.scheduled`, `.overdue`, `.streak`, `.escalation` |
| scheduledTime | Date? | |
| leadMinutes | Int? | Alert N minutes before |
| isEnabled | Bool | |
| watchEnabled | Bool | |
| liveActivityEnabled | Bool | |
| soundEnabled | Bool | |
| contextModeOverrides | JSON? | Different behavior per mode |

- **Storage:** Local | **Sensitivity:** Public | **Sync:** OptIn

---

### EscalationRule
**Purpose:** Progressive notification escalation configuration.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| notificationRuleID | UUID | → NotificationRule |
| intervals | [Int] | Minutes between escalations |
| maxEscalations | Int | |
| escalationBehavior | JSON | Per-escalation configuration |
| stopOnAcknowledgement | Bool | Default true |
| ultraStrictOverride | JSON? | More aggressive in Ultra Strict Mode |

- **Storage:** Local | **Sensitivity:** Public | **Sync:** OptIn

---

## Focus Engine

### FocusSession
**Purpose:** Timed deep work or focus session.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| taskID | UUID? | → Task being focused on |
| plannedMinutes | Int | |
| actualMinutes | Int? | |
| startedAt | Date | |
| endedAt | Date? | |
| status | Enum | `.active`, `.completed`, `.abandoned`, `.interrupted` |
| distractionCount | Int | |
| preChecklistCompleted | Bool | |
| postChecklistCompleted | Bool | |
| abandonReason | String? | |
| penaltyApplied | Bool | Score penalty if abandoned |

- **Storage:** Local | **Sensitivity:** Private | **Sync:** OptIn (aggregates)

---

### DistractionRule
**Purpose:** App/category distraction configuration.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| category | Enum | `.socialMedia`, `.streaming`, `.messaging`, `.browser`, `.games`, `.custom` |
| appBundleIDs | [String]? | Specific apps |
| customName | String? | |
| strategy | Enum | `.block`, `.warn`, `.track`, `.report` |
| enabledInModes | [Enum] | Which context modes activate this |
| feasibilityNote | String? | DeviceActivity vs Focus Mode fallback |

- **Storage:** Local | **Sensitivity:** Private | **Sync:** Never
- **Feasibility note:** App blocking requires DeviceActivity/FamilyControls. Fallback is Focus Modes and accountability reporting.

---

## Accountability

### AccountabilityPartner
**Purpose:** Accountability partner linked account.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| ownerUserID | UUID | → primary user |
| partnerUserID | UUID? | → partner account (if they have Oathen) |
| partnerEmail | String? | Invite email |
| status | Enum | `.invited`, `.active`, `.paused`, `.removed` |
| invitedAt | Date | |
| acceptedAt | Date? | |
| permissionPolicyID | UUID | → PermissionPolicy |
| nudgesEnabled | Bool | Partner can send nudges |
| weeklyDigestEnabled | Bool | Partner receives weekly digest |
| criticalAlertsEnabled | Bool | Partner notified on critical failures |

- **Storage:** Cloud | **Sensitivity:** Private | **Sync:** Auto

---

### PermissionPolicy
**Purpose:** Granular permissions for what the accountability partner can see.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| partnerID | UUID | → AccountabilityPartner |
| canViewDisciplineScore | Bool | Default true |
| canViewStreaks | Bool | Default true |
| canViewOnTrackStatus | Bool | Default true |
| canViewExerciseSummary | Bool | Default true |
| canViewHydrationSummary | Bool | Default true |
| canViewTaskCount | Bool | Default true |
| canViewAchievements | Bool | Default false |
| canViewBodyPhotos | Bool | Default false — never auto-on |
| canViewWeight | Bool | Default false |
| canViewBloodPressure | Bool | Default false |
| canViewMedication | Bool | Default false |
| canViewLocation | Bool | Default false |
| canViewJournal | Bool | Default false |
| canViewAIConversations | Bool | Default false |
| canViewClinicalMetrics | Bool | Default false |
| canViewFailureDetails | Bool | Default false |
| receivesCriticalAlerts | Bool | Default false |
| receivesWeeklyDigest | Bool | Default false |

- **Storage:** Cloud | **Sensitivity:** Sensitive | **Sync:** Auto

---

## Templates

### Template
**Purpose:** Reusable plan structure for common scenarios.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| createdByUserID | UUID? | Null = system template |
| title | String | |
| description | String | |
| category | Enum | `.weeklyRoutine`, `.travel`, `.vacation`, `.transformation`, `.productivitySprint`, `.creative`, `.recovery`, `.custom` |
| duration | String? | e.g., "45 days", "1 week" |
| isSystemTemplate | Bool | |
| isAIGenerated | Bool | |
| userApproved | Bool | AI templates must be approved |
| tags | [String] | |
| createdAt | Date | |

- **Storage:** Hybrid | **Sensitivity:** Public (system) / Private (custom) | **Sync:** OptIn

---

### TemplateInstance
**Purpose:** Active use of a Template by a user.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| templateID | UUID | |
| activatedAt | Date | |
| targetEndDate | Date? | |
| status | Enum | `.active`, `.completed`, `.abandoned` |
| progressPercent | Double | |
| abandonReason | String? | |

- **Storage:** Hybrid | **Sensitivity:** Private | **Sync:** Auto

---

## Infrastructure and Observability

### SyncState
**Purpose:** Track sync lifecycle of each entity.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| entityType | String | |
| entityID | UUID | |
| localVersion | Int | Increment on each local change |
| remoteVersion | Int? | Last known remote version |
| status | Enum | `.localOnly`, `.pendingUpload`, `.synced`, `.conflict`, `.error` |
| lastSyncAttempt | Date? | |
| lastSyncSuccess | Date? | |
| errorMessage | String? | |

- **Storage:** Local | **Sensitivity:** Public | **Sync:** N/A

---

### PrivacySetting
**Purpose:** User's privacy configuration.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| biometricProtection | Enum | `.wholeApp`, `.sensitiveAreasOnly`, `.off` |
| evidenceStorageMode | Enum | `.localOnly`, `.localAndSync`, `.localAndAIValidation` |
| aiProcessingConsent | JSON | Per-category consent flags |
| retentionDaysByCategory | JSON | Auto-delete rules per evidence type |
| localOnlyMode | Bool | No cloud sync at all |
| shareHealthDataWithAI | Bool | Default false |
| shareBodyPhotosWithAI | Bool | Default false — explicit opt-in only |
| analyticsEnabled | Bool | Crash/usage analytics |

- **Storage:** Hybrid | **Sensitivity:** Private | **Sync:** Auto (preferences, not consent details for sensitive)

---

### AuditLog
**Purpose:** Log of significant data access and sharing events.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| eventType | Enum | `.dataAccess`, `.dataShare`, `.aiProcessing`, `.partnerView`, `.export`, `.delete`, `.sync` |
| entityType | String | |
| entityID | UUID? | |
| actor | Enum | `.user`, `.aiCoach`, `.accountabilityPartner`, `.system` |
| description | String | Human-readable event summary |
| ipAddress | String? | Remote events only |
| occurredAt | Date | |
| sensitivityLevel | Enum | `.public`, `.private`, `.sensitive`, `.critical` |

- **Storage:** Local (critical events), Cloud (sharing events) | **Sensitivity:** Private | **Sync:** Partial

---

### CostEvent
**Purpose:** Track AI usage costs per user.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| provider | Enum | |
| modelVersion | String | |
| promptTokens | Int | |
| completionTokens | Int | |
| estimatedCostUSD | Double | |
| featureTag | String | e.g., "coach_message", "weekly_summary" |
| occurredAt | Date | |

- **Storage:** Cloud | **Sensitivity:** Private | **Sync:** Auto

---

### AIUsageLog
**Purpose:** Aggregate AI usage for quota enforcement and billing.

| Field | Type | Notes |
|---|---|---|
| id | UUID | |
| userID | UUID | |
| periodStart | Date | |
| periodEnd | Date | |
| totalTokens | Int | |
| totalCostUSD | Double | |
| messageCount | Int | |
| summaryCount | Int | |
| evidenceValidationCount | Int | |
| quotaExceeded | Bool | |
| quotaLimitTokens | Int | |

- **Storage:** Cloud | **Sensitivity:** Private | **Sync:** Auto

---

## Entity Relationship Summary

```
User
├── Goal[]
│   └── Project[]
│       ├── Habit[]
│       │   └── Evidence[]
│       └── Task[]
│           └── Evidence[]
│               └── PhotoEvidence[]
├── Routine[]
│   └── RoutineStep[]
├── MorningCheckIn[]
├── NightReview[]
├── WeeklyReview[]
├── ExerciseSession[]
├── HydrationLog[]
├── SleepLog[]
├── HealthMetric[]
├── Medication[]
│   └── MedicationLog[]
├── BodyProgressPhoto[]
├── BodyMetric[]
├── DisciplineScore[]
├── Streak[]
├── Achievement[]
├── ContextMode[]
│   └── TravelContext[]
├── NotificationRule[]
│   └── EscalationRule[]
├── FocusSession[]
├── DistractionRule[]
├── AIInsight[]
├── AICoachMessage[]
├── AICoachMemory[]
├── AccountabilityPartner[]
│   └── PermissionPolicy
├── Template[]
│   └── TemplateInstance[]
├── PrivacySetting
├── SyncState[] (one per synced entity)
├── AuditLog[]
├── CostEvent[]
└── AIUsageLog[]
```
