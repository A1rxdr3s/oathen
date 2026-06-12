# SCOPE_CONTROL.md — Oathen / Discipline OS
## Scope Control Reference

> **Rule:** Every sprint must be measured against this document before starting.
> Any feature not listed in the current sprint is out of scope, regardless of how good the idea is.
> New ideas go to Phase 2 or Future SaaS sections — they do not enter the current sprint.

---

## 1. MVP Product Vision (Full Approved Capability Set)

This is what Oathen is designed to do. It is NOT a single sprint. It is the complete product vision that will be built across multiple sprints.

### Core Discipline System
- Daily Routine Engine (Morning Check-in, Night Review, Weekly Review)
- Discipline Score calculation
- Streaks, ranks, levels
- Serious achievements (non-infantile)
- Context Modes (Normal, Travel, Tour, Vacation, Illness, Rest Day, Ultra Strict, Post-Travel Recovery)
- Ultra Strict Mode

### Goals and Execution
- Goal / Project / Habit / Task hierarchy
- Task priorities (Critical, High, Normal, Low, Blocked)
- AI-suggested priorities with manual override
- Evidence-based task completion
- Evidence capture (photo, metric, manual, AI-validated)
- Smart daily planning
- Replanning during the day
- Recurring tasks and habits
- Templates (system and AI-generated)

### Health
- Exercise tracking (goals, Apple Watch, HealthKit)
- Hydration tracking with optional photo evidence
- Sleep tracking (Apple Watch / HealthKit)
- Body progress tracking (photo, metrics)
- Medication reminders (non-diagnostic)
- Health metrics (weight, blood pressure read-only, heart rate)
- Non-diagnostic wellness insights

### AI Coach
- Provider-agnostic AI abstraction layer
- Context-aware coaching (goals, tasks, score, health)
- Excuse detection and confrontation
- Recovery plan generation
- Goal adjustment suggestions
- Template generation (user approval required)
- Weekly summary generation
- Vision AI for evidence validation
- Structured AI memory system

### Notifications and Escalation
- Priority-based escalation engine
- Apple Watch alerts
- Live Activities (focus sessions, overdue critical states)
- Hydration, exercise, check-in, review reminders

### Focus Engine
- Focus timer with pre/post checklists
- Distraction tracking
- DeviceActivity integration (feasibility-gated)
- Focus Mode integration
- Abandonment penalty
- App distraction categories

### Ecosystem
- iPhone (primary)
- Apple Watch
- Mac dashboard (strategic center)
- Siri (App Intents for high-value actions)
- Widgets (WidgetKit)
- Live Activities

### Accountability
- Accountability partner with basic account
- Granular permission policy (default private)
- Weekly digest, nudges, critical alerts

### Context Intelligence
- Travel detection via Apple Calendar
- Gmail travel/reservation detection (limited scope)
- Automatic context mode suggestions
- Manual mode override

### Data and Privacy
- Local-first architecture
- Supabase sync (opt-in per category)
- Biometric app protection (configurable)
- Evidence encryption and retention policies
- Data export and account deletion
- Audit log

---

## 2. Buildable MVP Sequence (Sprint Order)

This is the REALISTIC path to building the MVP product vision.

| Sprint | Deliverable | Foundation Needed |
|---|---|---|
| 1 | App Shell + Navigation | None |
| 2 | Domain Models + Local Persistence | Sprint 1 |
| 3 | Daily Routine Engine + Score | Sprint 2 |
| 4 | HealthKit + Exercise + Sleep | Sprint 2, 3 |
| 5 | Hydration + Evidence | Sprint 2, 3 |
| 6 | Notifications + Escalation | Sprint 3, 4, 5 |
| 7 | AI Coach Foundation | Sprint 2, 3, 4, 5 |
| 8 | Supabase Sync | Sprint 2, 7 |
| 9 | Apple Watch App | Sprint 3, 4, 5, 6 |
| 10 | Mac Dashboard | Sprint 3, 4, 5, 7 |
| 11 | Focus Engine | Sprint 3, 6 |
| 12 | Accountability Partner | Sprint 7, 8 |

---

## 3. Current Sprint Scope

**Current Sprint: Sprint 0 — Master Plan**
**Status: Complete**

Only the following work is in scope for Sprint 0:
- Product strategy and vision documentation
- Architecture design
- Data model design
- UX flow design
- Design system direction
- Cost modeling
- Sprint roadmap
- Required Markdown documentation

---

## 4. Phase 2 (Post-MVP)

These features are intentionally deferred. They must not be added to any sprint without explicit approval.

| Feature | Reason for Deferral |
|---|---|
| Full nutrition / meal tracking | Scope — complete separate domain |
| Macro and calorie tracking | Scope — requires food database |
| Meal photo analysis | Scope — AI cost + food recognition accuracy |
| Alcohol and late-night eating tracking | Scope — part of nutrition phase |
| Web dashboard | Scope — PWA/web separate from native MVP |
| Template marketplace | Scope — requires social/publishing infrastructure |
| Family plans | Scope — multi-user SaaS |
| Coach / professional plans | Scope — B2B commercial |
| Body composition AI analysis | Privacy sensitivity — opt-in only post-MVP |
| Apple Intelligence on-device AI | Availability — depends on Apple rollout |
| Siri full NLP conversations | Complexity — App Intents for specific actions only in MVP |
| Menu bar app (Mac) | Nice-to-have post Sprint 10 |
| Apple Wallet / boarding pass | Technical complexity |
| Third-party fitness devices | HealthKit covers most cases |
| Advanced sleep coaching | Scope — Sleep is tracked, not coached in depth |
| Meditation / mindfulness tracking | Adjacent domain — not core |

---

## 5. Future SaaS (Post-Personal MVP)

Do not contaminate MVP implementation with multi-user concerns beyond what is necessary for SaaS-ready architecture.

| Feature | Notes |
|---|---|
| Personal Pro subscription | AI quota, premium features |
| AI Coach premium tier | Increased Coach interaction limits |
| Ultra Strict Mode premium | Premium gating possible |
| Advanced analytics | Richer score breakdown, trends |
| Template marketplace | User-generated and curated |
| Accountability partner premium | Richer partner dashboard |
| Coach / trainer plans | Multi-client management |
| Organization plans | Team discipline tracking |
| API access | Developers building on Discipline OS |

---

## 6. Not Now (Never in MVP)

These are explicitly rejected from the MVP product vision. If they reappear in planning, escalate to scope review.

| Rejected | Reason |
|---|---|
| General email task management via Gmail | Out of scope — scope-creep risk |
| Social feed or community | Out of scope — changes product identity |
| Gamification with avatars, coins, or cartoon elements | Product identity violation |
| Public accountability leaderboards | Privacy risk, product identity violation |
| Medical diagnosis or prescription recommendations | Safety, legal |
| Medication dosage adjustment | Safety, legal |
| Automatic medication changes | Safety, legal — never |
| Clinical health decisions | Safety, legal |
| Android app | Platform decision (Apple-native only) |
| Android watch support | Platform decision |
| Spotify / music integration as separate module | Scope — music use cases via Projects/Templates |
| Full DJ set management module | Scope — use Projects + Templates |
| Subscription billing in MVP | Deferred to commercial phase |
| Full team/enterprise features in MVP | Post-personal MVP |
| Invasive behavioral biometrics | Privacy, ethics |
| Predictive health risk scoring | Safety, legal, diagnostic risk |

---

## 7. Apple API Feasibility Rule

All Apple platform APIs are **API-supported capabilities** — not unconditionally available features.

Before building any feature dependent on an Apple system API, verify:

1. **User permission** — Does the user need to grant access? What is the graceful degradation if denied?
2. **Entitlement** — Does the API require a special Apple-provisioned entitlement? (DeviceActivity, FamilyControls, ManagedSettings, certain push capabilities)
3. **Platform version** — What is the minimum iOS/watchOS/macOS version? Is the iOS 17+ floor acceptable?
4. **Hardware** — Does the feature require specific hardware? (Live Activities require Dynamic Island or Lock Screen support; blood pressure requires a compatible device)
5. **App Review** — Has Apple approved this entitlement use case for personal (non-parental) apps?

**Feasibility-gated APIs (require Sprint 11 validation before building):**
- DeviceActivity / FamilyControls / ManagedSettings (app blocking)

**All other Apple APIs:** API-supported but permission-gated. Graceful degradation is required. Never assume permission is granted.

---

## 8. Scope Creep Risk Register

| Risk | Trigger | Response |
|---|---|---|
| Adding nutrition during Sprint 5 (hydration sprint) | "While we're doing hydration..." | Block. Nutrition is Phase 2. |
| Expanding Gmail to general email in Sprint 7 | "Can we also pull tasks from emails?" | Block. Gmail = travel context only. |
| Building full team features for accountability | "What if two users could compare scores?" | Block. MVP = 1 user + 1 partner. |
| AI Coach becoming a general chatbot | "Can I ask the Coach anything?" | Constrain. Coach answers only within product context. |
| Gamification creep | "Can we add coins/rewards?" | Block. Not the product identity. |
| Adding Android support | "My friend uses Android..." | Block. Apple-native decision is final. |
| Pre-building billing during Supabase sprint | "We should set up Stripe while we're there..." | Block. No billing in MVP. |
| Expanding body tracking to full medical | "Can we add blood glucose?" | Review carefully. Health safety rules apply. Non-diagnostic only. |
| Feature parity with Todoist/Things | "Can we also add tags, filters, areas..." | Evaluate. Tasks must not become a generic Todoist clone. |
| Watch app becoming independent | "The Watch should work without iPhone..." | Phase 2. Watch requires iPhone pairing in MVP. |
| Adding brand polish to Sprint 1 | "Can we also do the logo / icon / real colors?" | Block. Sprint 1 = structure only. No final branding. |
| Assuming an Apple API works without testing | "DeviceActivity should work fine..." | Block. Feasibility-gated APIs must be validated in Sprint 11. |

---

## 9. Scope Control Protocol

Before adding any new feature or expanding any existing feature:

1. **Check SCOPE_CONTROL.md** — Is it in Phase 2 or Not Now?
2. **Check SPRINT_PLAN.md** — Is it in the current sprint scope?
3. **Is it a natural extension or a new domain?** Natural extension (e.g., adding a new Task field) may be absorbed. New domain (e.g., nutrition) is not.
4. **If it involves an Apple system API:** Check the Apple API Feasibility Rule above. Is the entitlement confirmed? Is there a graceful degradation path?
5. **Estimate blast radius** — How many files change? How many sprints does it push back?
6. **If in doubt: defer.** It is always better to ship a focused feature than to bloat a sprint and ship nothing.
7. **Document the decision in DECISION_LOG.md** if a new item is added or explicitly rejected.
