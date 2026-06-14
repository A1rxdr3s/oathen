# PROJECT_CONTEXT.md — Oathen / Discipline OS
## Living Source of Truth

> **Update this file after every meaningful implementation or architecture change.**
> If the code changes and this file does not, the file is wrong.

---

## Identity

| Field | Value |
|---|---|
| Public Brand | **Oathen** |
| Pronunciation | "Oaten" |
| Internal System Name | **Discipline OS** |
| Product Descriptor | Personal Accountability OS |
| Category | Discipline, Health, Focus & Execution |
| Current Sprint | **Sprint 4 — Local Persistence Foundation** |
| Sprint Status | Complete |
| Last Updated | 2026-06-14 |

---

## Product Vision (One Paragraph)

Oathen (Discipline OS) is a premium Apple-native personal accountability operating system that converts personal commitments — oaths — into daily execution, measurable evidence, and real discipline. It is not a to-do app. It is not a habit tracker. It is not a generic AI chatbot. It is a serious, strict, and intelligent operating system for the user's life: exercise, hydration, sleep, focus, tasks, goals, and AI coaching — across iPhone, Apple Watch, and Mac — built on local-first privacy, evidence-based completion, and a provider-agnostic AI Coach that confronts excuses without humiliating the user.

---

## Current Sprint Status

### Sprint 0 — Master Plan (COMPLETE, hardening patch applied)
- [x] Product strategy defined
- [x] MVP product vision documented
- [x] Buildable MVP sequence separated
- [x] Scope control established
- [x] Technical architecture designed
- [x] Apple ecosystem architecture planned
- [x] Supabase architecture planned
- [x] AI architecture planned (provider-agnostic)
- [x] Security/privacy architecture designed
- [x] Data model defined
- [x] UX flows documented
- [x] Design system direction set
- [x] Cost model estimated
- [x] Sprint roadmap defined
- [x] All required Markdown documentation created
- [x] Documentation hardening patch: Apple API feasibility language tightened
- [x] Documentation hardening patch: AIProvider snippets labelled as conceptual pseudocode
- [x] Documentation hardening patch: Sprint 1 branding exclusions explicitly documented
- [x] Decision D-018 added to DECISION_LOG.md

### Sprint 1 — SwiftUI App Shell (COMPLETE)

**Completion date:** 2026-06-11

#### What was built

- `Oathen.xcodeproj` generated via XcodeGen 2.45.4 from `project.yml`
- Multiplatform target: iOS 17+ and macOS 14+ in a single SwiftUI target
- Separate watchOS 10+ target: `OathenWatch`
- 5-tab iPhone shell: Today, Goals, Coach, Health, You
- Mac NavigationSplitView shell (`MacDashboardView`) with sidebar, content, and detail panes
- Watch placeholder app: score ring, next action, hydration quick-log button (disabled)
- Design system tokens: `OathenColors`, `OathenTypography`, `OathenSpacing`, `OathenRadius`, `OathenComponents`
- Shared components: `OathenCard`, `PriorityBadge`, `ScoreRing`, `OathenProgressBar`, `OathenSectionHeader`, `PlaceholderTag`
- `AppEnvironment` (`@Observable @MainActor`) — app-wide environment shell
- `PlaceholderData` — static preview data used across all tab views
- `PlatformRouter` — routes iOS → `OathenRootView`, macOS → `MacDashboardView`
- `scripts/validate_sprint1.sh` — automated 10-goal validation script (passes 73/73 checks with Xcode 26.5)
- `validation/sprint1_validation_report.md` — generated report

#### Build validation notes
- Xcode 26.5 is installed and all three builds pass (iOS, macOS, watchOS).
- Validation uses `-target` + `-sdk` flags (no simulator runtime required): `Oathen_iOS`, `Oathen_macOS`, `OathenWatch`.
- XcodeGen multiplatform target generates schemes named `Oathen_iOS` and `Oathen_macOS` (not a bare `Oathen` scheme).

#### Sprint 1.3 — Placeholder Badge Removal (2026-06-11)
Visual QA found the "Sprint 1" capsule badge still appearing vertically in narrow trailing positions on macOS. Removed `PlaceholderTag` entirely from all 8 usages across 7 files and deleted the component from `OathenComponents.swift`. Fixed `moduleHeaderCard` subtitle truncation: changed `"Module implementation: \(item.sprintLabel)"` to `item.sprintLabel` directly. Sprint context is conveyed through existing inline text labels in each view. No business logic added.

#### Sprint 1.2 — Placeholder Badge Cleanup (2026-06-11)
Visual QA identified that the all-caps "PLACEHOLDER" capsule badge with an accent-colored stroke was visually noisy and not premium. Replaced with a quiet "Sprint 1" pill using tertiary foreground and a very subtle background — no accent color, no stroke, no rotation. Superseded by Sprint 1.3.

#### Sprint 1.1 — macOS Layout Stabilization (2026-06-11)
Visual QA on macOS revealed the NavigationSplitView columns were compressed at default window size, causing title text ("Today") to split across lines and "Discipline Score" to wrap in the sidebar widget. Applied minimum column widths and a default launch size — no business logic or new functionality added.

### Sprint 2 — Core Domain Models (COMPLETE)

**Completion date:** 2026-06-11

#### What was built

- **9 domain models** (pure Swift structs): `Goal`, `Project`, `Habit`, `OathenTask`, `Routine`, `RoutineStep`, `Evidence`, `DisciplineScore`, `ContextMode`
- **6 value objects**: `Priority`, `CompletionStatus` (6 status enums), `EvidenceRequirement`, `RecurrenceRule`, `ScoreBreakdown`, `DateRange`
- **2 policy helpers**: `DisciplineScorePolicy` (rule-based placeholder scorer), `TaskPriorityPolicy` (deterministic priority escalation)
- **Fixtures**: `DomainFixtures` — sample goal, project, 3 habits, 2 tasks, a morning routine, a score, and context mode
- **OathenTests** unit test target: 3 test files, macOS-only, domain source compiled directly into bundle (no host app dependency)
  - `ModelTests.swift` — initialization, flags, display names, clamping
  - `PolicyTests.swift` — scoring policy, priority escalation edge cases
  - `CodableTests.swift` — JSON round-trip for all key models
- `scripts/validate_sprint2.sh` — 65/65 checks pass
- `validation/sprint2_validation_report.md` — generated

#### Scope Boundaries

- **No SwiftData**, no `@Model`, no `ModelContainer` — persistence is Sprint 3+
- **No Supabase**, no backend schemas, no network code
- **No HealthKit**, no real health data
- **No AI providers**, no real scoring logic — `DisciplineScorePolicy` is a placeholder
- **No notifications**, no widgets, no Live Activities, no Watch sync
- **Not the full 42-entity data model** — Sprint 2 implements only the core foundation (D-021)

### Sprint 3 — Daily Routine Engine (COMPLETE)

**Completion date:** 2026-06-12

#### What was built

- **5 new domain models** (pure Swift structs): `MorningCheckIn`, `NightReview`, `DailyPlanItem`, `DailyPlan`, `TodayState`
- **Supporting enums**: `EnergyLevel`, `FocusLevel`, `MoodLevel`, `DailyPlanItemKind`, `DailyPlanItemStatus`
- **`DailyRoutinePolicy`** — 10 deterministic pure helpers: `defaultDailyPlan`, `defaultMorningCheckIn`, `nightReview`, `progressFraction`, `recoveryRecommendation`, `coachNudge`, `calculateScore`, `defaultTodayState`, `isMorningCheckInComplete`, `isNightReviewComplete`
- **`TodayViewModel`** — `@Observable @MainActor` in-memory state. Owns `TodayState`. Functions: `completeMorningCheckIn`, `toggleItem`, `completeNightReview`, `resetToDefaults`
- **6 Today card components**: `DisciplineScoreCard`, `MorningCheckInCard`, `DailyPlanCard`, `HealthPillarsCard`, `TodayProgressCard`, `NightReviewCard`
- **3 DailyRoutine flow views**: `MorningCheckInView` (sheet, Form-based), `NightReviewView` (sheet, day summary + failure reason + recovery), `DailyPlanView` (sheet, priority-grouped list)
- **Updated `TodayView`** — fully connected to TodayViewModel; sheets for check-in, night review, plan
- **Updated `MacDashboardView`** — Today tab: live score, check-in bar, commitments list, health pillars, coach nudge
- **`OathenApp`** injects `TodayViewModel` into environment via `@State`
- **`DailyRoutineTests.swift`** (44 tests) + **`DailyRoutineCodableTests.swift`** (20 tests) — total 108 tests, 0 failures
- **`scripts/validate_sprint3.sh`** — 74/74 checks pass, 0 failures
- **`validation/sprint3_validation_report.md`** — generated

#### Scope Boundaries

- **No SwiftData**, no `@Model`, no `ModelContainer` — persistence is Sprint 4+
- **No Supabase**, no backend schemas, no network code
- **No HealthKit** — health pillars are local-only checkboxes
- **No AI providers** — coach nudge and excuse detection are local rule-based
- **No notifications**, no widgets, no Live Activities, no Watch sync
- **In-memory only** — state resets on app restart (expected until Sprint 4)
- **No streak calculation** across multiple days (Sprint 4+)

#### Sprint 3.3 — iOS Layout Stabilization (2026-06-12)

Visual QA after Sprint 3.2 showed the iPhone app was rendering as a light-mode white card against the dark phone frame, with the floating tab bar overlapping Today content. Three targeted fixes applied:
- `OathenApp.swift`: Added `.preferredColorScheme(.dark)` at root → consistent dark mode on both iOS and macOS, matching the design intent reflected in all preview configurations
- `OathenRootView.swift`: Added `.tint(OathenColors.accent)` and `.background(OathenColors.screenBackground.ignoresSafeArea())` to the TabView → accent color in tab bar; background extends behind the new iOS 26 glass tab bar
- `TodayView.swift`: Changed `ScrollView` background to `.background { OathenColors.screenBackground.ignoresSafeArea() }` to extend the fill behind the tab bar; increased bottom content padding from `xxxl` (32pt) to `huge` (40pt) to provide more clearance above the floating tab bar

No product logic, persistence, HealthKit, Supabase, or AI functionality was added.

#### Sprint 3.1 — Placeholder Comprehension Cleanup (2026-06-12)

Visual QA after Sprint 3 found that non-Today sections on macOS and iPhone still displayed internal sprint implementation labels ("Sprint 2 — Domain Models", "Sprint 10", "Module implementation", "Sprint 7", etc.) in user-visible UI. Sprint 3.1 replaced all user-facing sprint labels with product-meaningful placeholder copy and added per-module explanatory content (Goals, Coach, Health, You). No new product logic, persistence, HealthKit, Supabase, or AI functionality was added.

- `GoalsView` — clarified as long-term commitments behind daily plan; removed sprint label from goal rows
- `CoachView` — banner renamed to "Accountability Coach"; placeholder bubbles describe product intent without sprint numbers
- `HealthView` — note now describes local targets and future HealthKit; "Coming in Sprint 4" → "Coming later"
- `YouView` — settings rows now show "Not active yet"; version footer no longer shows "Sprint N Shell"
- `MacDashboardView` — `sprintLabel` replaced by `subtitle`; non-Today sections now show per-module placeholder cards; detail panel "Sprint 10" removed
- `TodayView` + `HealthPillarsCard` — "HealthKit — Sprint 4" → "Local target" / "Local target only"

### Sprint 4 — Local Persistence Foundation (COMPLETE)

**Completion date:** 2026-06-14

#### What was built

- **Persistence layer** — `Oathen/Core/Data/LocalPersistence/` directory, never touching domain models
- **5 SwiftData entities** (in `SwiftData/`): `PersistentTodayState`, `PersistentDailyPlan`, `PersistentDailyPlanItem`, `PersistentMorningCheckIn`, `PersistentNightReview`
  - `[UUID]` arrays stored as JSON strings (`confirmedCriticalTaskIDsJSON`, etc.) to avoid SwiftData compatibility issues
  - `sortOrder: Int` on `PersistentDailyPlanItem` preserves daily plan item order across saves
  - `dayStart: Date` (normalized start-of-day) on `PersistentTodayState` as the query key for date lookup
- **4 mappers** + `UUIDArrayCoding` helper (in `Mapping/`): `TodayStateMapper`, `DailyPlanMapper`, `MorningCheckInMapper`, `NightReviewMapper` — all `@MainActor` static functions
  - `TodayStateMapper.toDomain` recalculates `DisciplineScore` from plan state on restore — avoids persisting a derived value
  - All raw enum values are round-tripped via `rawValue`/`init(rawValue:)` with nil-guard fallback
- **`TodayPersistenceStore`** (`@MainActor`) — `loadToday(for:)`, `saveToday(_:)`, `deleteToday(for:)`, `resetToday()` — delete-and-reinsert strategy for saves, cascade delete for children
- **`TodayPersistenceError`** — `LocalizedError` enum covering save/load/delete/corrupt-data cases
- **`OathenModelContainer`** — factory `make(inMemory:)` throwing function used by app (persistent) and tests (in-memory)
- **`TodayViewModel`** updated: two `init` overloads (`init()` for previews/no-persistence, `init(store:)` for full persistence); loads on init, persists after every mutation, falls back gracefully on save error
- **`OathenApp`** updated: creates `ModelContainer` in `init()`, falls back to in-memory container on failure, creates `TodayPersistenceStore` from `mainContext`, passes store to `TodayViewModel`; `.modelContainer(modelContainer)` injected for future SwiftUI `@Query` use
- **5 new unit test files** (in `OathenTests/Persistence/`): mapper round-trip tests and store integration tests using in-memory container
- **`project.yml`** updated: `Oathen/Core/Data/LocalPersistence` added to `OathenTests` sources
- **`scripts/validate_sprint4.sh`** — automated validation: Sprint 3 regression + Sprint 4 checks

#### Architecture rules enforced

- `@Model` annotation appears **only** in `Core/Data/LocalPersistence/SwiftData/` — never in domain models
- Domain models (`TodayState`, `DailyPlan`, `MorningCheckIn`, `NightReview`) remain pure Swift structs with no persistence imports
- `watchOS` target unaffected — persistence files are in `Oathen/Core/Data/`, which `OathenWatch` does not source

#### Scope Boundaries

- **No HealthKit** — health pillars remain local checkboxes
- **No Supabase** — persistence is device-local only (SwiftData, on-disk SQLite)
- **No cross-day streak tracking** — only today's state is persisted
- **No AI providers**, no notifications, no widgets, no Watch sync added

#### Next: Sprint 5 — HealthKit, Exercise, and Sleep
- HealthKit permission request flow (lazy, at feature use)
- Real exercise and sleep data integration
- Hydration write to HealthKit
- Score calculation updated with real health signals
- Streak calculation
- Health tab functional

---

---

## Approved Tech Stack

> **Apple API Note:** All Apple system frameworks are API-supported capabilities subject to user permission, entitlement availability, platform version requirements, and App Store Review. "API-supported" does not mean unconditionally available. Build with graceful degradation for every system API.

| Layer | Technology | Status |
|---|---|---|
| Language | Swift 5.10+ | Confirmed |
| UI Framework | SwiftUI | Confirmed |
| iPhone App | Native SwiftUI | Confirmed |
| Mac App | Native SwiftUI (multiplatform) | Confirmed |
| Watch App | WatchOS SwiftUI target | Confirmed |
| Local Persistence | SwiftData + Core Data fallback | Confirmed |
| Backend | Supabase | Confirmed |
| Auth | Sign in with Apple + Google | Confirmed |
| AI | Provider-agnostic abstraction layer | Confirmed |
| Health | HealthKit | API-supported (user permission required per data type) |
| Notifications | UserNotifications + APNs | API-supported (user permission required) |
| Widgets | WidgetKit | API-supported (user placement required) |
| Siri | App Intents | API-supported (user permission + entitlement required) |
| Focus | FamilyControls / DeviceActivity | Feasibility-gated (entitlement required — Sprint 11 validates) |
| Live Activities | ActivityKit | API-supported (entitlement + supported device required) |
| Location | CoreLocation | API-supported (user permission required) |
| Calendar | EventKit | API-supported (user permission required) |
| Storage | Local-first, Supabase sync secondary | Confirmed |

---

## Architecture Decisions (Summary)

| Decision | Choice | Reasoning |
|---|---|---|
| App platform | Native Apple, not PWA | Performance, HealthKit, Watch, ecosystem depth |
| Local vs Cloud | Local-first, sync secondary | Privacy, offline, sensitive data |
| AI provider | Provider-agnostic abstraction | Avoid vendor lock-in, route by task |
| Backend | Supabase | Postgres, Auth, Storage, Edge Functions, SaaS-ready |
| Auth methods | Apple + Google only in MVP | Security, privacy, no password management |
| Evidence storage | Hybrid: local default, cloud opt-in | Privacy-first, sensitive evidence protection |
| Nutrition | Phase 2 | Scope control |
| Gmail | Travel/reservation context only | Scope control |
| App blocking | DeviceActivity feasibility-gated | Apple API restrictions |

---

## Active Modules (Approved for MVP)

| Module | Status |
|---|---|
| Daily Routine Engine | Planned — Sprint 3 |
| Morning Check-in | Planned — Sprint 3 |
| Night Review | Planned — Sprint 3 |
| Goal / Project / Habit / Task | Planned — Sprint 2 |
| Exercise Tracking | Planned — Sprint 4 |
| HealthKit Integration | Planned — Sprint 4 |
| Hydration + Evidence | Planned — Sprint 5 |
| Sleep Tracking | Planned — Sprint 4 |
| Discipline Score | Planned — Sprint 3 |
| AI Coach | Planned — Sprint 7 |
| Notifications / Escalation | Planned — Sprint 6 |
| Context Modes | Planned — Sprint 7 |
| Ultra Strict Mode | Planned — Sprint 7 |
| Focus Engine | Planned — Sprint 11 |
| Accountability Partner | Planned — Sprint 12 |
| Supabase Sync | Planned — Sprint 8 |
| Apple Watch | Planned — Sprint 9 |
| Mac Dashboard | Planned — Sprint 10 |
| Templates | Planned — Sprint 7+ |
| Travel / Gmail Context | Planned — Sprint 7+ |
| Siri / Widgets | Planned — Sprint 9+ |

---

## Explicitly Out of Scope (MVP)

- Nutrition / meal tracking (Phase 2)
- General email task management via Gmail
- Web dashboard (post-MVP)
- Billing / subscription management (post-MVP)
- Multi-user SaaS (post-MVP)
- Template marketplace (post-MVP)
- Full Screen Time enforcement (feasibility-gated, fallback only if restricted)
- Any medical diagnosis, prescription, or treatment recommendation

---

## Data Model Summary

See `DATA_MODEL.md` for full entity definitions.

**Entity count:** ~42 core entities
**Storage split:** ~60% local-only, ~40% cloud-synced
**Sensitive entities:** BodyProgressPhoto, BodyMetric, HealthMetric, Medication, MedicationLog, Evidence (certain types), NightReview private fields, AICoachMemory

---

## Privacy Decisions

| Principle | Rule |
|---|---|
| Local-first | All sensitive data defaults to device-only |
| AI consent | User must explicitly consent before AI processes health/evidence data |
| Body photos | Never uploaded without explicit opt-in |
| Accountability partner | No sensitive data visible by default |
| Biometric lock | Available for sensitive areas |
| Audit log | All significant data access and sharing events logged locally |
| Data export | Full export available on request |
| Account deletion | All cloud data deleted, device data deleted on user request |

---

## AI Decisions

| Principle | Rule |
|---|---|
| Provider agnostic | All AI calls go through an abstraction layer |
| Coach tone | Strict, direct, demanding but not abusive |
| Health framing | Non-diagnostic, wellness signal language only |
| Memory | AI Coach has a structured memory system |
| On-device preference | Use Apple Intelligence / on-device where available for sensitive data |
| Vision AI | Optional, explicit consent, routes to Gemini/OpenAI Vision |
| Cost control | Summarization, caching, quotas enforced |

---

## Known Risks

| Risk | Severity | Mitigation |
|---|---|---|
| Apple DeviceActivity restrictions | High | Fallback to Focus Modes + reporting |
| AI cost growth at scale | Medium | Abstraction layer + quotas + caching |
| HealthKit permission denial | Medium | Graceful degradation, manual entry always available |
| Scope creep | High | Scope control log enforced every sprint |
| Gmail API complexity | Medium | Scoped to travel context only, not general email |
| Photo evidence storage growth | Medium | Local-first, retention policies, user-controlled deletion |
| Evidence validation false positives | Medium | AI is advisory, user can override |

---

## Open Questions

1. Should Supabase Edge Functions handle AI orchestration, or a separate AI proxy layer?
2. What is the fallback model strategy if a provider has an outage?
3. Should the accountability partner have a separate lightweight app or web view?
4. Should Gmail integration use OAuth in-app or use the native iOS Mail/Shortcuts APIs?
5. How aggressive should evidence requirements be in normal mode vs Ultra Strict Mode?
6. What is the Watch complication set for Sprint 9?
7. ~~Should the Mac app be a multiplatform SwiftUI app or a distinct Mac target?~~ **Resolved Sprint 1:** Multiplatform SwiftUI target (`platform: [iOS, macOS]` in project.yml). PlatformRouter routes iOS → TabView, macOS → NavigationSplitView.

---

## Completed Work

| Sprint | Deliverable | Date |
|---|---|---|
| Sprint 0 | Master Plan + All Documentation | 2026-06-11 |
| Sprint 1 | SwiftUI App Shell + Validation Script | 2026-06-11 |
| Sprint 2 | Core Domain Models + Unit Tests | 2026-06-11 |
| Sprint 3 | Daily Routine Engine (in-memory) | 2026-06-12 |
| Sprint 4 | Local Persistence Foundation (SwiftData) | 2026-06-14 |

---

## Pending Work

| Sprint | Deliverable |
|---|---|
| Sprint 5 | HealthKit, Exercise, Sleep |
| Sprint 6 (prev. 5) | Hydration + Evidence |
| Sprint 6 | Notifications + Escalation Engine |
| Sprint 7 | AI Coach Foundation |
| Sprint 8 | Supabase Sync |
| Sprint 9 | Apple Watch App |
| Sprint 10 | Mac Dashboard |
| Sprint 11 | Focus Engine |
| Sprint 12 | Accountability Partner |
