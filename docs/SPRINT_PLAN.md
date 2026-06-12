# SPRINT_PLAN.md — Oathen / Discipline OS
## Sprint Roadmap and Execution Plan

---

## Roadmap Overview

| Sprint | Name | Status |
|---|---|---|
| 0 | Master Plan | **Complete** |
| 1 | SwiftUI App Shell | **Complete** |
| 2 | Core Domain Models | Pending |
| 3 | Daily Routine Engine | Pending |
| 4 | HealthKit, Exercise, Sleep | Pending |
| 5 | Hydration + Evidence | Pending |
| 6 | Notifications + Escalation Engine | Pending |
| 7 | AI Coach Foundation | Pending |
| 8 | Supabase Sync | Pending |
| 9 | Apple Watch App | Pending |
| 10 | Mac Dashboard | Pending |
| 11 | Focus Engine | Pending |
| 12 | Accountability Partner | Pending |

---

## Sprint 0 — Master Plan

**Status:** Complete
**Goal:** Establish all product strategy, architecture, data model, UX flows, design system, cost model, and sprint roadmap. No code.

### Deliverables

- [x] Product vision and principles defined
- [x] MVP product vision separated from buildable sequence
- [x] Scope control established
- [x] Technical architecture designed
- [x] Apple ecosystem strategy documented
- [x] Supabase architecture planned
- [x] AI system architecture (provider-agnostic) designed
- [x] Data model (~42 entities) with sensitivity and sync classification
- [x] UX flows for all major flows
- [x] Design system direction documented
- [x] Cost model estimated
- [x] Risk analysis completed
- [x] All required Markdown documentation created
- [x] Decision log initialized
- [x] Scope control log initialized

### Acceptance Criteria Met

- [x] No Swift code written
- [x] Oathen used as public brand name
- [x] Discipline OS used as internal system name
- [x] MVP Product Vision separated from Buildable MVP Sequence
- [x] Apple-native architecture (not PWA)
- [x] Supabase as preferred backend
- [x] Local-first privacy model
- [x] Provider-agnostic AI architecture
- [x] Health features are strictly non-diagnostic
- [x] Apple APIs feasibility-gated
- [x] Nutrition is Phase 2
- [x] Gmail is limited to travel/reservation context
- [x] Accountability Partner permissions are granular
- [x] Data model includes local/cloud guidance and sensitivity
- [x] Cost model includes 1-user, 100-user, 1000-user scenarios
- [x] Sprint roadmap is realistic and modular
- [x] Required Markdown files created

---

## Sprint 1 — SwiftUI App Shell

**Status:** Complete — 2026-06-11 (Sprint 1.1 layout patch: 2026-06-11, Sprint 1.2 badge cleanup: 2026-06-11, Sprint 1.3 badge removal: 2026-06-11)
**Goal:** Create the functional Xcode project base with navigation structure, design tokens, placeholder screens, and target configuration. No business logic.

### Scope

**In scope:**
- New Xcode project setup: iOS + watchOS + macOS targets
- Swift Package structure for Core shared logic
- SwiftUI navigation skeleton (TabView iPhone, NavigationSplitView Mac)
- Design token scaffolding (color, typography, spacing constants — values from DESIGN_SYSTEM.md, no final visual polish)
- Placeholder screens for all 5 iPhone tabs (text labels only, no real content)
- Placeholder screens for Mac sidebar sections
- WatchOS target declared (single placeholder screen — confirms target compiles)
- Project folder structure per ARCHITECTURE.md
- Xcode-generated default app icon (template asset only, no custom design)
- Xcode-default or minimal launch screen (no custom brand design)
- Light mode + Dark mode design token wiring
- PROJECT_CONTEXT.md update

**Out of scope:**
- Any data models or persistence
- Any business logic
- Any HealthKit code
- Any Supabase code
- Any AI code
- Any real content
- **Final or custom app icon** — Xcode template placeholder only
- **Custom launch screen design** — minimal/default only; no brand graphics
- **Final logo or wordmark** — not in Sprint 1
- **Production onboarding copy** — no user-facing strings beyond structural labels
- **Final color exploration or brand polish** — design tokens scaffold the DESIGN_SYSTEM.md values; no design iteration or visual refinement in this sprint
- **Custom animations or transitions** — system defaults only

### Acceptance Criteria

- [x] Xcode project generated (via XcodeGen 2.45.4 from project.yml)
- [x] All 5 tab bar items exist with placeholder screens (Today, Goals, Coach, Health, You)
- [x] Design tokens implemented (OathenColors, OathenTypography, OathenSpacing, OathenRadius, OathenComponents)
- [x] Mac target shell: MacDashboardView with NavigationSplitView (sidebar + content + detail)
- [x] watchOS target: OathenWatchApp + WatchHomeView placeholder
- [x] PlatformRouter routes iOS → TabView, macOS → NavigationSplitView
- [x] No custom app icon, no custom launch screen, no final branding
- [x] No forbidden implementations: 0 failures on 30 forbidden pattern checks
- [x] Validation script passes 73/73 checks (0 failures, 0 warnings) with Xcode 26.5
- [x] PROJECT_CONTEXT.md updated

### Andrés Validation Checklist (requires Xcode installed)

Before closing Sprint 1 formally, install Xcode and verify:

- [ ] Install Xcode from the Mac App Store
- [ ] Run `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`
- [x] Run `bash scripts/validate_sprint1.sh` — 73/73 passed, 0 failures, 0 warnings
- [ ] Open `Oathen.xcodeproj` in Xcode
- [ ] Run on iPhone 16 simulator — confirm 5 tabs render, no crashes
- [ ] Run on macOS target — confirm sidebar renders, no crashes
- [ ] Run watchOS scheme — confirm placeholder compiles and renders
- [ ] Toggle dark mode in simulator — confirm no missing color tokens

---

## Sprint 2 — Core Domain Models

**Status:** Pending
**Goal:** Implement all core domain models as Swift structs, SwiftData schemas, and local persistence. No UI beyond what is needed to test.

### Scope

**In scope:**
- Swift structs for all domain entities (no UI)
- SwiftData `@Model` classes for local persistence
- ModelContainer configuration
- Basic CRUD repository protocols and implementations
- Unit tests for model validation
- Goal → Project → Habit → Task hierarchy working in persistence
- Evidence model + local file reference model
- DisciplineScore model (no calculation logic yet)
- SyncState model
- PROJECT_CONTEXT.md update

**Out of scope:**
- Supabase sync
- AI logic
- HealthKit
- UI implementation beyond test harness
- Notification scheduling

---

## Sprint 3 — Daily Routine Engine

**Status:** Pending
**Goal:** Implement Morning Check-in, Night Review, Daily Plan, and baseline Discipline Score calculation. Full iPhone UI for daily flows.

### Scope

**In scope:**
- Morning Check-in full UI flow
- Night Review full UI flow
- Weekly Review skeleton
- Daily plan generation (rule-based, no AI yet)
- Discipline Score calculation engine (rule-based)
- Score display on Today screen
- Task list for today with priority display
- Task completion (mark done, postpone, skip with reason)
- Streak calculation for habits and exercise
- Today screen fully functional with real data
- Empty states and error states
- PROJECT_CONTEXT.md update

**Out of scope:**
- HealthKit data (stubs only)
- AI Coach
- Notifications (triggers stubbed)
- Evidence capture (stubbed)

---

## Sprint 4 — HealthKit, Exercise, and Sleep

**Status:** Pending
**Goal:** Integrate HealthKit for exercise, sleep, and basic health metrics. Update Discipline Score to use real health data.

### Scope

**In scope:**
- HealthKit permission request flow (lazy, at feature use)
- Read: HKActivitySummary (exercise, calories, steps)
- Read: HKWorkout (workout sessions)
- Read: HKCategoryType.sleepAnalysis
- Read: HKQuantityType.restingHeartRate
- Write: HKQuantityType.dietaryWater
- ExerciseSession model → HealthKit integration
- SleepLog model → HealthKit integration
- Exercise goal validation via HealthKit data
- Sleep data in Morning Check-in
- Score calculation updated with HealthKit signals
- Exercise screen in Health tab
- Sleep summary in Health tab
- HealthKit denial graceful degradation
- PROJECT_CONTEXT.md update

**Out of scope:**
- Blood pressure (HealthKit read only, display sprint 5+)
- Body metrics (sprint 5+)
- AI analysis of health data

---

## Sprint 5 — Hydration + Evidence

**Status:** Pending
**Goal:** Full hydration tracking with logging, goal progress, evidence capture, and AI validation stub.

### Scope

**In scope:**
- HydrationLog CRUD + UI
- Hydration goal configuration per context mode
- Quick-log widget (in-app)
- Photo evidence capture flow
- Evidence model + PhotoEvidence local storage
- Evidence status display on task/habit rows
- Evidence required mode for habits
- Local file storage for photos (encrypted)
- Evidence retention policy configuration
- AI validation stub (returns mock result)
- Hydration screen in Health tab
- Body metrics entry screen (basic)
- Body progress photo capture (local only, biometric gated)
- PROJECT_CONTEXT.md update

**Out of scope:**
- Real AI vision validation (Sprint 7)
- Cloud evidence storage (Sprint 8)
- Watch hydration logging (Sprint 9)

---

## Sprint 6 — Notifications + Escalation Engine

**Status:** Pending
**Goal:** Full local notification system with priority-based escalation, Watch alerts, and Live Activities.

### Scope

**In scope:**
- NotificationRule CRUD
- EscalationRule configuration
- Local notification scheduling (`UserNotifications`)
- Morning Check-in reminder
- Night Review reminder
- Hydration reminders (configurable intervals)
- Exercise reminders
- Task overdue escalation (progressive: 30 → 15 → 10 → 5 min)
- Critical task overdue Live Activity
- Focus session Live Activity
- Apple Watch alert passthrough (WatchConnectivity)
- Context mode notification adjustment
- Ultra Strict Mode notification intensity
- Notification settings UI
- PROJECT_CONTEXT.md update

**Out of scope:**
- Push notifications (APNs) — Sprint 8
- Accountability partner alerts — Sprint 12
- Siri shortcuts — Sprint 9+

---

## Sprint 7 — AI Coach Foundation

**Status:** Pending
**Goal:** Implement AI abstraction layer, Coach conversation UI, memory model, context injection, and real AI provider connections.

### Scope

**In scope:**
- AIProvider protocol and abstraction layer
- AIRouter (provider selection by task type)
- OpenAI integration (primary Coach provider)
- Claude integration (analysis/planning provider)
- AICoachMemory model + storage
- AICoachMessage CRUD + conversation UI
- Context injection: goals, tasks, today's score, streaks, patterns
- Coach tone enforcement via system prompt
- Coach message in Today screen (contextual nudge)
- Real evidence validation via Gemini Vision or OpenAI Vision
- Weekly summary generation (AI)
- Excuse pattern detection
- Context mode suggestions
- Travel detection stub (calendar-based)
- CostEvent logging per AI call
- AI usage quota enforcement
- AI consent UI in settings
- PROJECT_CONTEXT.md update

**Out of scope:**
- Gmail integration (Sprint 7 extended or post-Sprint 8)
- Apple Intelligence on-device (post-MVP)
- Full Ultra Strict Mode AI behavior (depends on Sprint 3 + 6)

---

## Sprint 8 — Supabase Sync

**Status:** Pending
**Goal:** Configure Supabase project, implement auth, sync engine, and storage for opted-in content.

### Scope

**In scope:**
- Supabase project setup (Andrés runs in Supabase dashboard)
- Postgres schema migration (all cloud-synced entities)
- Row Level Security on all tables
- Supabase Auth: Sign in with Apple
- Supabase Auth: Google Sign-In
- Swift Supabase SDK integration
- SyncEngine: push local changes, pull remote changes
- Conflict resolution implementation
- Non-sensitive entity sync (Goals, Projects, Tasks, Score, Streaks, Achievements)
- Supabase Storage setup for opt-in evidence photos
- Evidence upload with consent gate
- Sync settings UI (what to sync, when to sync)
- Cross-device sync test (iPhone to Mac)
- Offline queue
- PROJECT_CONTEXT.md update

**Out of scope:**
- Accountability partner backend (Sprint 12)
- Edge Functions for AI orchestration (Sprint 8 extended)
- Push notifications via APNs (may be Sprint 8 or 9)

---

## Sprint 9 — Apple Watch App

**Status:** Pending
**Goal:** Functional watchOS app with check-ins, health data, complications, and quick-log actions.

### Scope

**In scope:**
- Watch app navigation (SwiftUI watchOS)
- Today summary on Watch
- Quick hydration log from Watch
- Exercise session start/stop from Watch
- Morning Check-in prompt on Watch
- Score complication (`.accessoryCircular`)
- Next action complication (`.accessoryRectangular`)
- Watch alert handling (escalation passthrough)
- WatchConnectivity sync with iPhone
- Watch health data independent access
- Workout session live tracking on Watch
- PROJECT_CONTEXT.md update

**Out of scope:**
- Independent Watch app (always requires iPhone pairing in MVP)
- Watch AI Coach chat

---

## Sprint 10 — Mac Dashboard

**Status:** Pending
**Goal:** Full Mac-native dashboard for strategic planning, analytics, and goals management.

### Scope

**In scope:**
- Mac NavigationSplitView layout
- Today Command Center (Mac-adapted)
- Goals & Projects management (Mac)
- Weekly Planning view (Mac)
- Analytics dashboard (score trend, habit consistency, exercise)
- Templates browser and management
- Settings center (Mac)
- Privacy center (Mac)
- Coach view (Mac)
- Keyboard navigation throughout
- Context menus
- Mac-adapted typography and density
- PROJECT_CONTEXT.md update

**Out of scope:**
- Menu bar app (post-MVP)
- Mac-specific Siri integration

---

## Sprint 11 — Focus Engine

**Status:** Pending
**Goal:** Focus timer, distraction tracking, DeviceActivity feasibility validation, and Focus Mode integration.

### Scope

**In scope:**
- Focus session timer UI + Live Activity
- Pre/post checklist
- Distraction rule configuration
- DeviceActivity feasibility validation (test real API restrictions)
- If feasible: DeviceActivity integration for usage monitoring
- If not feasible: Focus Modes integration + reporting fallback
- Screen time reporting in analytics
- Abandonment penalty
- Distraction log
- FocusSession CRUD
- PROJECT_CONTEXT.md update

**Feasibility gate:** If DeviceActivity/FamilyControls entitlement is denied or too restrictive, implement Focus Mode integration only. Document actual capability vs expected.

---

## Sprint 12 — Accountability Partner

**Status:** Pending
**Goal:** Accountability partner invite, permissions, summary view, nudges, and critical alerts.

### Scope

**In scope:**
- Partner invite flow (email + link)
- Partner account creation (lightweight)
- PermissionPolicy CRUD and UI
- Partner dashboard (what partner can see)
- Weekly digest for partner (email or in-app)
- Critical alert to partner (push notification)
- Nudge from partner to user
- Partner audit log
- Privacy explanation before enabling partner
- PROJECT_CONTEXT.md update

**Out of scope:**
- Partner full Oathen account (partner has lightweight view only in MVP)
- Family plans
- Coach plans

---

## Out of Scope — All Sprints

These items are not in any sprint above and will not be built in the initial buildable MVP sequence:

- Full nutrition / meal tracking (Phase 2)
- General email task management via Gmail
- Web dashboard
- Billing / subscriptions
- Template marketplace
- Multi-user SaaS backend
- Apple Intelligence on-device AI (depends on availability)
- Siri full NLP (App Intents for specific actions only)
- Full medication dosage management or clinical advice
- Body composition AI analysis (optional, explicit consent, post-MVP)
- Apple Wallet / boarding pass integration
- Third-party calendar sync beyond EventKit
