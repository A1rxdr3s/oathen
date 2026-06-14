# ARCHITECTURE.md — Oathen / Discipline OS
## Technical Architecture Reference

---

## 1. Architecture Philosophy

Oathen is built on five architectural principles:

1. **Local-first** — data lives on-device by default; cloud is synchronization, not the source of truth.
2. **Privacy-by-design** — sensitive data is never uploaded unless the user explicitly consents.
3. **Apple-native** — every platform (iPhone, Watch, Mac) uses native APIs and feels like Apple-built software.
4. **Modular boundaries** — each domain (tasks, health, AI, notifications) is isolated; modules depend on interfaces, not implementations.
5. **SaaS-ready** — the data model and API abstraction are structured for future multi-user commercial use without contaminating the MVP personal experience.

---

## 2. High-Level Architecture Diagram (Text)

```
┌─────────────────────────────────────────────────────────┐
│                     Oathen Clients                      │
│                                                         │
│  ┌────────────┐  ┌────────────┐  ┌────────────────┐   │
│  │  iPhone    │  │  Apple     │  │  Mac (iPad     │   │
│  │  (Primary) │  │  Watch     │  │  optional)     │   │
│  └─────┬──────┘  └─────┬──────┘  └────────┬───────┘   │
│        │               │                   │            │
│  ┌─────▼───────────────▼───────────────────▼────────┐  │
│  │           Shared Swift Package (Core Logic)       │  │
│  │  DomainModels │ UseCases │ Repositories │ Events  │  │
│  └────────────────────────┬──────────────────────────┘  │
│                           │                             │
│  ┌────────────────────────▼──────────────────────────┐  │
│  │              Local Persistence Layer               │  │
│  │   SwiftData / Core Data + Keychain + File System  │  │
│  └────────────────────────┬──────────────────────────┘  │
│                           │ (sync when authorized)      │
└───────────────────────────┼─────────────────────────────┘
                            │
          ┌─────────────────▼─────────────────┐
          │         Supabase Backend           │
          │  Auth │ Postgres │ Storage │       │
          │  Edge Functions │ Realtime         │
          └─────────────────┬─────────────────┘
                            │
          ┌─────────────────▼─────────────────┐
          │         AI Abstraction Layer       │
          │  OpenAI │ Claude │ Gemini │        │
          │  Apple Intelligence │ On-device    │
          └───────────────────────────────────┘
```

---

## 3. App Architecture Pattern

**Pattern: MVVM + Clean Architecture with feature-based modules**

### Sprint 2 Actual Structure (as built)

```
Oathen/                              # Multiplatform target (iOS 17+ / macOS 14+)
├── App/
│   ├── OathenApp.swift
│   └── Root/
│       ├── PlatformRouter.swift
│       ├── OathenTab.swift
│       └── OathenRootView.swift
├── Core/
│   ├── Domain/                      # ← Sprint 2: Pure Swift domain layer
│   │   ├── Models/
│   │   │   ├── Goal.swift           # Major personal commitment (an oath)
│   │   │   ├── Project.swift        # Structured workstream under a Goal
│   │   │   ├── Habit.swift          # Recurring discipline behaviour
│   │   │   ├── OathenTask.swift     # Concrete action item (OathenTask avoids Swift Task conflict)
│   │   │   ├── Routine.swift        # Morning/Night/Weekly/Custom check-in
│   │   │   ├── RoutineStep.swift    # Individual step within a Routine
│   │   │   ├── Evidence.swift       # Proof concept (no storage/AI in Sprint 2)
│   │   │   ├── DisciplineScore.swift # Daily score (shape only; engine: Sprint 3)
│   │   │   └── ContextMode.swift   # Operational mode (Normal, Travel, UltraStrict, etc.)
│   │   ├── ValueObjects/
│   │   │   ├── Priority.swift       # Critical/High/Normal/Low/Blocked
│   │   │   ├── CompletionStatus.swift # Status enums for all entity types
│   │   │   ├── EvidenceRequirement.swift # None/Optional/Required
│   │   │   ├── RecurrenceRule.swift # Habit recurrence (daily/weekdays/custom)
│   │   │   ├── ScoreBreakdown.swift # Component scores summing to DisciplineScore total
│   │   │   └── DateRange.swift      # Start/end date pair with helpers
│   │   ├── Policies/
│   │   │   ├── DisciplineScorePolicy.swift # Rule-based placeholder scorer (real: Sprint 3)
│   │   │   └── TaskPriorityPolicy.swift    # Deterministic priority escalation helper
│   │   └── Fixtures/
│   │       └── DomainFixtures.swift # Sample domain data for previews
│   ├── DesignSystem/
│   │   ├── OathenColors.swift
│   │   ├── OathenTypography.swift
│   │   ├── OathenSpacing.swift
│   │   ├── OathenRadius.swift
│   │   └── OathenComponents.swift
│   └── Foundation/
│       ├── AppEnvironment.swift
│       └── PlaceholderData.swift    # Sprint 1 static preview data (replace in Sprint 3)
├── Features/
│   ├── Today/TodayView.swift
│   ├── Goals/GoalsView.swift
│   ├── Coach/CoachView.swift
│   ├── Health/HealthView.swift
│   ├── You/YouView.swift
│   └── MacDashboard/MacDashboardView.swift
└── Assets.xcassets/

OathenWatch/                         # watchOS 10+ target
├── OathenWatchApp.swift
├── WatchHomeView.swift
└── Assets.xcassets/

OathenTests/                         # macOS unit test bundle (Sprint 2)
├── ModelTests.swift                 # Initialization, flags, display names
├── PolicyTests.swift                # DisciplineScorePolicy, TaskPriorityPolicy
└── CodableTests.swift               # JSON round-trip for all key models

scripts/
├── validate_sprint1.sh
└── validate_sprint2.sh

validation/
├── sprint1_validation_report.md
└── sprint2_validation_report.md
```

### Domain Layer Responsibilities (Sprint 2)

| Layer | Contents | Rules |
|---|---|---|
| `Domain/Models/` | Core business entities (structs) | `Identifiable`, `Codable`, `Equatable`, `Sendable`. No UIKit/SwiftUI. No persistence annotations. |
| `Domain/ValueObjects/` | Shared enums and value structs | Same conformances. `CaseIterable` on enums where useful. |
| `Domain/Policies/` | Pure function helpers | `static func` only. No stored state. No external dependencies. Deterministic. |
| `Domain/Fixtures/` | Sample data for previews | Fixed UUID and date values for determinism. Not for production use. |

### Sprint 3 Actual Structure (as built — additions only)

```
Oathen/
├── App/
│   └── OathenApp.swift              # @State private var todayViewModel = TodayViewModel()
│                                    # .environment(todayViewModel) injected to PlatformRouter
├── Core/
│   └── Domain/
│       ├── Models/
│       │   ├── MorningCheckIn.swift # Start-of-day commitment review + EnergyLevel/FocusLevel/MoodLevel enums
│       │   ├── NightReview.swift    # End-of-day closure + excuse detection (local, no AI)
│       │   ├── DailyPlanItem.swift  # Single day action + DailyPlanItemKind + DailyPlanItemStatus
│       │   ├── DailyPlan.swift      # Daily commitment set + progress computation
│       │   └── TodayState.swift     # In-memory aggregate of the full day state (resets on restart)
│       └── Policies/
│           └── DailyRoutinePolicy.swift # defaultDailyPlan, coachNudge, calculateScore, etc. (10 helpers)
├── Features/
│   ├── Today/
│   │   ├── TodayView.swift          # UPDATED — full daily command center, connected to TodayViewModel
│   │   ├── TodayViewModel.swift     # NEW — @Observable @MainActor in-memory state owner
│   │   └── Components/              # NEW directory
│   │       ├── DisciplineScoreCard.swift   # Live score ring + label + context mode
│   │       ├── MorningCheckInCard.swift    # Status + "Start" button → sheet
│   │       ├── DailyPlanCard.swift         # Critical/high items with completion toggles
│   │       ├── HealthPillarsCard.swift     # Hydration/exercise/sleep local checkboxes
│   │       ├── TodayProgressCard.swift     # Progress bar + morning/night status pills
│   │       └── NightReviewCard.swift       # Status + "Review" button → sheet
│   ├── DailyRoutine/                # NEW directory
│   │   ├── MorningCheckInView.swift  # Sheet: Form-based check-in (sleep, energy, focus, mood, mode)
│   │   ├── NightReviewView.swift     # Sheet: Day summary + failure reason + recovery plan
│   │   └── DailyPlanView.swift       # Sheet: Priority-grouped full plan list
│   └── MacDashboard/
│       └── MacDashboardView.swift   # UPDATED — Today: live check-in bar + commitments + health + coach

OathenTests/
├── DailyRoutineTests.swift          # NEW — 44 tests for Sprint 3 models + DailyRoutinePolicy
└── DailyRoutineCodableTests.swift   # NEW — 20 JSON round-trip tests

scripts/
└── validate_sprint3.sh              # NEW — 12 goals, 74/74 checks
```

### Daily Routine Data Flow (Sprint 3)

```
OathenApp (@State TodayViewModel)
    ↓ .environment(todayViewModel)
PlatformRouter
    ↓
OathenRootView (iOS)          MacDashboardView (macOS)
    ↓                                ↓
TodayView                    Today content pane
    ↓ @Environment(TodayViewModel)
  ├── DisciplineScoreCard     ← score (computed live)
  ├── MorningCheckInCard      → isShowingMorningCheckIn = true
  │       ↓ sheet
  │   MorningCheckInView      → viewModel.completeMorningCheckIn(...)
  ├── TodayProgressCard       ← TodayState.progressFraction
  ├── DailyPlanCard           → viewModel.toggleItem(id:) → recalculateScore()
  ├── HealthPillarsCard       → viewModel.toggleItem(id:) → recalculateScore()
  ├── Coach nudge             ← DailyRoutinePolicy.coachNudge(for: state)
  └── NightReviewCard         → isShowingNightReview = true
          ↓ sheet
      NightReviewView         → viewModel.completeNightReview(failureReason:)
```

### In-Memory State Boundary (Sprint 3)

| What is in-memory | What happens on restart | When it changes |
|---|---|---|
| `TodayState` | Resets to fixture defaults | Sprint 4 adds SwiftData |
| `TodayViewModel` | Re-created by `@State` in OathenApp | Persistent in Sprint 4+ |
| `DisciplineScore` (today) | Recalculated from fresh state | Real calc in Sprint 3; HealthKit in Sprint 4 |

### How Sprint 3 Prepares for Future Persistence

- `TodayState`, `DailyPlan`, `MorningCheckIn`, `NightReview` are all `Codable` — JSON round-trip tested
- All models use `UUID` IDs — map to Postgres primary keys
- `completedAt: Date?` and `approvedAt: Date?` mirror Supabase timestamp patterns
- `DailyPlan.date` is calendar-day scoped — maps cleanly to `date` column in persistence
- `DailyRoutinePolicy.calculateScore(from:)` takes a pure value — no ViewModel dependency, safe to call from persistence layer
- `TodayViewModel.resetToDefaults()` makes test isolation trivial — same pattern works for SwiftData reset

### How Sprint 2 Prepares for Future Persistence (Without Implementing It)

- All models use `UUID` for `id` — maps cleanly to Postgres `uuid` primary keys
- `createdAt` / `updatedAt` fields match Supabase auto-timestamp columns
- All models are `Codable` — JSON encode/decode tested; SwiftData `@Model` can wrap them in Sprint 3 with minimal changes
- `GoalStatus`, `TaskStatus`, etc. are `String` raw values — map directly to Postgres enum or varchar columns
- `localOnly: Bool` on `Evidence` and the `isPrivate: Bool` on `Goal` encode the sync-boundary concept without implementing sync
- No references to `@Model`, `NSManagedObject`, or any persistence layer — the domain is decoupled by design

### Sprint 1 Actual Structure (as built)

Project generated by XcodeGen 2.45.4 from `project.yml`. Never handcraft `.pbxproj` (see D-019).

```
Oathen/                              # Multiplatform target (iOS 17+ / macOS 14+)
├── App/
│   ├── OathenApp.swift              # @main entry point
│   └── Root/
│       ├── PlatformRouter.swift     # iOS → OathenRootView, macOS → MacDashboardView
│       ├── OathenTab.swift          # Tab enum (today/goals/coach/health/you)
│       └── OathenRootView.swift     # TabView (iOS only)
├── Core/
│   ├── DesignSystem/
│   │   ├── OathenColors.swift       # Color tokens (accent, status, health, adaptive surfaces)
│   │   ├── OathenTypography.swift   # Font scale (scoreDisplay → tagLabel)
│   │   ├── OathenSpacing.swift      # 8pt grid + layout constants
│   │   ├── OathenRadius.swift       # Corner radius tokens
│   │   └── OathenComponents.swift   # OathenCard, PriorityBadge, ScoreRing, etc.
│   └── Foundation/
│       ├── AppEnvironment.swift     # @Observable @MainActor app state shell
│       └── PlaceholderData.swift    # Static Sprint 1 preview data
├── Features/
│   ├── Today/TodayView.swift        # Daily command center placeholder
│   ├── Goals/GoalsView.swift        # Goal hierarchy placeholder
│   ├── Coach/CoachView.swift        # AI Coach conversation placeholder
│   ├── Health/HealthView.swift      # Health pillars placeholder
│   ├── You/YouView.swift            # Profile / settings placeholder
│   └── MacDashboard/
│       └── MacDashboardView.swift   # Mac NavigationSplitView shell
└── Assets.xcassets/                 # Template icon only (no custom branding)

OathenWatch/                         # watchOS 10+ target
├── OathenWatchApp.swift             # @main Watch entry point
├── WatchHomeView.swift              # Score ring + next action + hydration stub
└── Assets.xcassets/

scripts/
└── validate_sprint1.sh              # Automated 10-goal validation script

validation/
└── sprint1_validation_report.md     # Generated by validate_sprint1.sh
```

### Target Architecture (full — Sprint 2+ evolves this)

```
Oathen/Core/                 # Sprint 2+: Domain, Data, Common layers
│   ├── Domain/
│   │   ├── Models/          # Pure value types (structs), no dependencies
│   │   ├── UseCases/        # Business logic, input→output
│   │   └── Repositories/   # Protocol interfaces only
│   ├── Data/
│   │   ├── Local/           # SwiftData / CoreData implementations
│   │   ├── Remote/          # Supabase client implementations
│   │   └── AI/              # AI provider implementations
│   └── Common/
│       ├── Extensions/
│       ├── Utilities/
│       └── Constants/
│
Oathen/Features/             # Sprint 2+: expand each module
│   ├── Today/               # Sprint 3: real data
│   ├── Goals/               # Sprint 2: domain models
│   ├── Coach/               # Sprint 7: AI integration
│   ├── Health/              # Sprint 4: HealthKit
│   ├── You/                 # Sprint 5: auth + settings
│   ├── MacDashboard/        # Sprint 10: full Mac layout
│   ├── DailyRoutine/        # Sprint 3
│   ├── Notifications/       # Sprint 6
│   ├── FocusEngine/         # Sprint 11
│   └── Accountability/      # Sprint 12
```

### Layer Rules

| Layer | Rule |
|---|---|
| Domain Models | Pure structs, no UIKit/SwiftUI imports, no external dependencies |
| Use Cases | One business operation each, depend only on Repository protocols |
| Repository Protocols | Defined in Domain layer, implemented in Data layer |
| ViewModels | `@Observable` or `ObservableObject`, call Use Cases, never touch data layer directly |
| Views | Pure SwiftUI, depend only on ViewModels |
| Feature modules | Import Core package; do not import other Feature modules directly |

---

## 4. Apple Platform Architecture

> **Apple API Feasibility Note:** All Apple system frameworks listed below are API-supported capabilities subject to user permission, entitlement availability, platform version requirements, and App Store Review. Assume nothing is unconditionally available. Build with graceful degradation for every system API.

### iPhone (Primary Platform)

- **SwiftUI** as the UI framework throughout.
- **Navigation:** `NavigationStack` with typed navigation paths; no global router.
- **State:** `@Observable` (Swift 5.9+) for ViewModels; `@AppStorage` for lightweight user defaults; SwiftData `@Query` for local data.
- **Background tasks:** `BackgroundTasks` framework for sync and score calculation — API-supported, subject to OS scheduling limits and background execution constraints.
- **Live Activities:** `ActivityKit` — API-supported, subject to user permission, entitlement availability, and dynamic island presence on supported devices only.
- **Widgets:** `WidgetKit` with `AppIntentTimelineProvider` — API-supported, subject to user permission and widget placement.

### Apple Watch

- **Separate WatchOS target** within the same Xcode project.
- Communicates with iPhone via `WatchConnectivity` — API-supported, subject to Watch reachability and pairing state.
- Independent local store for offline operation during workouts.
- Complications via `ClockKit` (legacy) + `WidgetKit` complications (watchOS 9+) — API-supported, subject to Watch face configuration by user.
- Independent health data access via HealthKit on Watch — API-supported, subject to Watch HealthKit permission grants.

### Mac

- **Multiplatform SwiftUI target** sharing core logic.
- Mac-specific layouts using `NavigationSplitView` for three-column command center.
- Mac is the strategic planning center (Goals, Weekly Planning, Analytics, Templates).
- Not just a larger iPhone screen — distinct Mac-idiomatic UX.
- Mac Catalyst is **not** the approach; native multiplatform SwiftUI is preferred.

---

## 5. Local-First Architecture

### Data Residency by Default

```
Device (iPhone / Watch / Mac)
├── All Tasks, Goals, Habits, Routines          → Local only by default
├── Morning/Night/Weekly Check-ins               → Local only by default
├── Hydration, Sleep, Exercise logs              → Local, HealthKit, opt-in cloud
├── Evidence photos (non-sensitive)              → Local, opt-in cloud
├── Body progress photos                         → Local ONLY, never auto-uploaded
├── HealthMetrics, Medications                   → Local ONLY
├── AICoachMemory, AIInsights                    → Local summary, redacted cloud sync
├── Journal / failure explanations               → Local ONLY
└── DisciplineScore, Streaks, Achievements       → Local + cloud sync (non-sensitive)
```

### SwiftData Schema (Conceptual)

- All entities have a `localID: UUID` generated on-device.
- Cloud entities also have a `remoteID: String?` (Supabase row ID) set after sync.
- `syncState: SyncState` tracks: `.localOnly`, `.pendingUpload`, `.synced`, `.conflict`.
- Conflict resolution strategy: **device wins by timestamp for user-generated content**; server wins for AI-generated content.

### Keychain Storage

- Auth tokens, API keys stored in Keychain with `kSecAttrAccessibleAfterFirstUnlock`.
- Biometric-gated entries for sensitive metadata use `kSecAccessControlBiometryCurrentSet`.

---

## 6. Supabase Backend Architecture

### Services Used

| Service | Purpose |
|---|---|
| Supabase Auth | Sign in with Apple, Google OAuth |
| Postgres | Primary cloud data store |
| Row Level Security | Per-user data isolation |
| Supabase Storage | Evidence photos (opt-in), body progress (opt-in), reports |
| Edge Functions | AI orchestration, weekly summaries, evidence validation |
| Realtime | Accountability partner updates, cross-device sync signals |
| Vault | Encrypted secrets for AI API keys |

### Database Design Principles

- **Row Level Security (RLS)** enabled on all tables — users can only access their own data.
- Accountability partner access controlled via `permission_policy` table, not table-level grants.
- `audit_log` table captures all data access events for sensitive entities.
- Soft deletes (`deleted_at`) on most entities; hard deletes for sensitive evidence on explicit user request.
- All timestamps stored as UTC in Postgres; timezone stored separately on User entity.

### Edge Functions

| Function | Trigger | Responsibility |
|---|---|---|
| `ai-coach-message` | Client call | Route to AI provider, inject context, return Coach response |
| `weekly-summary` | Scheduled (weekly) | Generate weekly review summary via AI |
| `evidence-validate` | Client call | Route photo to vision AI for validation |
| `score-calculate` | Event-driven | Recalculate DisciplineScore after daily events |
| `accountability-notify` | Event-driven | Send push notification to accountability partner |
| `travel-context-detect` | Client call | Analyze calendar/email context for travel mode suggestion |

### Auth Strategy

- **Sign in with Apple** — primary, privacy-first.
- **Google Sign-In** — secondary, for users who prefer Google ecosystem.
- No email/password in MVP.
- JWT tokens issued by Supabase, stored in iOS Keychain.
- Refresh handled transparently by Supabase Swift SDK.

---

## 7. Sync and Conflict Resolution

### Sync Architecture

```
Event on device
    ↓
Mark entity syncState = .pendingUpload
    ↓
SyncEngine polls / observes network
    ↓
Upload batch to Supabase via REST
    ↓
Mark syncState = .synced (set remoteID)
    ↓
Pull remote changes (delta sync, not full fetch)
    ↓
Conflict detection: compare updatedAt timestamps
    ↓
Resolve: device wins for user content, server wins for AI content
```

### Conflict Rules

| Entity Type | Winner |
|---|---|
| User-created tasks, goals, habits | Last write wins (device timestamp) |
| AI-generated insights, suggestions | Server/AI version preferred |
| Score, streaks | Recalculated, not directly merged |
| Evidence (photos) | Device is source of truth; server is backup |
| Sync metadata | Server timestamp authoritative |

### Offline Queue

- All write operations are queued locally when offline.
- Queue is a persistent ordered list processed on reconnection.
- Idempotent operations (upsert with localID) ensure no duplicates.

---

## 8. AI Abstraction Layer

See `AI_SYSTEM.md` for full AI architecture.

### Interface Summary

> **Conceptual Pseudocode — Not a Swift source file.** The following snippet illustrates design intent only. It is not compilable Swift and does not represent the final implementation. Real Swift source code will be created in Sprint 7.

```
// CONCEPTUAL DESIGN INTENT — NOT PRODUCTION CODE
// Protocol — all AI providers implement this
AIProvider {
    complete(prompt, context) → AIResponse
    validateEvidence(image, type) → EvidenceValidation
    generateSummary(period, data) → String
}

// Router — selects provider based on task
AIRouter {
    selectProvider(for task) → AIProvider
}
```

### Provider Routing (Design Intent)

| Task | Preferred Provider | Fallback |
|---|---|---|
| AI Coach conversation | OpenAI GPT-4o or Claude | Other cloud model |
| Long planning/analysis | Claude | OpenAI |
| Photo evidence validation | Gemini Vision / OpenAI Vision | Manual fallback |
| Sensitive local insights | Apple Intelligence (on-device) | Redacted cloud |
| Weekly summary | Claude or OpenAI | Cached last summary |
| Health trend interpretation | On-device or privacy-gated cloud | No AI, rule-based |

---

## 9. Module Boundaries

| Module | Owns | Depends On |
|---|---|---|
| DailyRoutine | Check-in flows, score trigger | Tasks, Health, Goals |
| Tasks | Task CRUD, evidence, priorities | Goals, Notifications |
| Goals | Goal/Project/Habit hierarchy | Tasks |
| Health | HealthKit reads, exercise, sleep, hydration | — |
| AICoach | Coach messages, memory, insights | All domain modules (read-only) |
| Score | Discipline score calculation | All domain modules (read-only) |
| Notifications | Scheduling, escalation, Watch alerts | Tasks, Health, Score |
| FocusEngine | Timer, distraction rules, Focus Modes | Tasks, Notifications |
| Accountability | Partner permissions, summaries, nudges | Score, Goals, Notifications |
| Sync | Supabase push/pull, conflict resolution | All domain modules |
| Settings | Privacy, biometric, preferences | All modules (configuration) |

No module imports another feature module directly. Cross-module communication uses domain events (notifications, published properties) or shared domain models from the Core package.

---

## 10. Security Architecture

See `SECURITY_PRIVACY.md` for full detail.

### Summary

- **Transport:** TLS 1.3 for all network calls.
- **At rest (device):** iOS file encryption (Data Protection API, `.completeFileProtection` for sensitive files).
- **At rest (cloud):** Supabase encryption at rest (AES-256).
- **Auth tokens:** Keychain with biometric access control where configured.
- **Sensitive data minimization:** Body photos, health metrics, medications never leave device without explicit consent.
- **AI processing:** User must consent to each category of data before it is sent to cloud AI.
- **Biometric gates:** Configurable — whole app, sensitive sections only, or off.
- **Audit log:** Local audit of all significant actions; cloud audit of sync and accountability events.

---

## 11. HealthKit Integration Strategy

> All HealthKit integrations are API-supported capabilities requiring explicit user permission grants. Permission denial must degrade gracefully to manual entry. HealthKit availability also varies by device (e.g., blood pressure requires a paired compatible device; sleep data quality depends on Apple Watch usage patterns).

| Data Type | HealthKit API | Feasibility | Notes |
|---|---|---|---|
| Activity / Calories | HKActivitySummary | API-supported (user permission required) | Read after permission; no Watch required |
| Exercise minutes | HKWorkout | API-supported (user permission required) | Read + optional write |
| Steps | HKQuantityType.stepCount | API-supported (user permission required) | Read |
| Resting heart rate | HKQuantityType.restingHeartRate | API-supported (user permission required) | Read; Watch improves accuracy |
| Sleep | HKCategoryType.sleepAnalysis | API-supported (user permission required) | Read; quality data requires Apple Watch sleep tracking to be enabled |
| Weight | HKQuantityType.bodyMass | API-supported (user permission required) | Read + write |
| Blood pressure | HKCorrelationType.bloodPressure | API-supported (user permission required) | Read only; requires compatible device or manual entry; non-diagnostic display only |
| Hydration | HKQuantityType.dietaryWater | API-supported (user permission required) | Read + write |
| Mindful minutes | HKCategoryType.mindfulSession | API-supported (user permission required) | Read |

**Permission Model:** Request HealthKit permissions lazily (when feature is first used), not at app launch. Always explain why each permission is needed before requesting. Always provide a manual entry fallback for every HealthKit-backed data type.

---

## 12. Notification Architecture

See `SPRINT_PLAN.md` Sprint 6 for implementation plan.

### Stack

- **Local notifications:** `UserNotifications` framework, scheduled on-device.
- **Push notifications:** APNs via Supabase for accountability partner events, cross-device sync signals.
- **Watch alerts:** WatchKit + WatchConnectivity passthrough.
- **Live Activities:** `ActivityKit` for ongoing states (focus session, overdue critical task, night routine).

### Escalation Engine (Design Intent)

Priority-based escalation configured per task/habit priority and active context mode. See `SPRINT_PLAN.md` for implementation scheduling.
