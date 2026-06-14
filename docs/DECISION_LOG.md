# DECISION_LOG.md — Oathen / Discipline OS
## Architecture and Product Decision Record

Format: Decision | Date | Reasoning | Risk | Rejected Alternatives | Status | Impact Area

---

## D-001: Public Brand Name is Oathen

**Date:** 2026-06-11
**Decision:** The public brand name is **Oathen**, pronounced "Oaten."
**Reasoning:** The name derives from "oath" — a serious personal commitment or vow. This is aligned with the product's core purpose: converting personal commitments into daily execution. The name is distinctive, memorable, and not generically tied to fitness or productivity.
**Risk:** Pronunciation is non-obvious for non-English speakers. Some markets may not connect "oath" to the product concept.
**Rejected Alternatives:** Generic names like "DisciplineApp", "CommitApp", or derived fitness names.
**Status:** Final
**Impact Area:** Branding, marketing, App Store presence

---

## D-002: Internal System Name is Discipline OS

**Date:** 2026-06-11
**Decision:** The internal architecture and system concept name is **Discipline OS**.
**Reasoning:** Communicates to the development team and documentation that this is an operating system for discipline — not a single-feature app. It sets the right mental model for architecture decisions: modular, comprehensive, platform-level.
**Risk:** "OS" branding could create expectations of complexity not appropriate for early sprints.
**Rejected Alternatives:** "Oathen Core", "Accountability Engine".
**Status:** Final
**Impact Area:** Internal documentation, architecture mental model

---

## D-003: Native Apple App Over PWA

**Date:** 2026-06-11
**Decision:** Oathen is a native Apple ecosystem app (Swift + SwiftUI), not a Progressive Web App.
**Reasoning:** Critical features (HealthKit, Apple Watch, Live Activities, WidgetKit, App Intents, DeviceActivity, CoreLocation, Keychain) are unavailable or severely limited in a PWA. The premium Apple-native feel is core to the product identity. Users in the Apple ecosystem expect and receive a qualitatively better native experience.
**Risk:** Excludes Android users. Higher development complexity. Requires Apple Developer Program.
**Rejected Alternatives:** React Native, Flutter, PWA, Ionic, Expo. All rejected due to API restrictions and native quality gap.
**Status:** Final
**Impact Area:** Platform strategy, engineering, hiring, distribution

---

## D-004: Swift and SwiftUI as Core Stack

**Date:** 2026-06-11
**Decision:** Swift 5.10+ and SwiftUI are the primary language and UI framework.
**Reasoning:** SwiftUI is Apple's current-generation UI framework. It supports multiplatform (iPhone, Watch, Mac) from a shared codebase. Swift Concurrency (async/await) handles background sync and AI calls cleanly. SwiftData provides native local persistence. Using Apple-first tools reduces impedance with Apple APIs.
**Risk:** SwiftUI has some platform-specific limitations for macOS that may require `#if os(macOS)` branches. SwiftData is relatively new — may have edge cases.
**Rejected Alternatives:** UIKit (older, more complex for multiplatform), AppKit (macOS only), React Native (API limitations).
**Status:** Final
**Impact Area:** Engineering, architecture, hiring

---

## D-005: Supabase as Preferred Backend

**Date:** 2026-06-11
**Decision:** Supabase is the backend platform: Auth, Postgres, Storage, Edge Functions, Realtime.
**Reasoning:** Supabase provides a complete backend with minimal operational overhead. Postgres is SaaS-ready with mature tooling. Row Level Security provides per-user data isolation. Supabase Storage handles evidence photos. Edge Functions allow AI orchestration at the API layer. The Swift SDK is available. Cost is low at personal scale.
**Risk:** Vendor dependency on Supabase. Edge Functions cold start latency. Realtime limitations at scale.
**Rejected Alternatives:** Firebase (proprietary, less SaaS-ready schema), custom backend (too much infrastructure overhead for MVP), AWS Amplify (complexity), PlanetScale (no storage/auth/functions).
**Status:** Final
**Impact Area:** Backend, data, sync, AI orchestration

---

## D-006: Local-First Privacy Model

**Date:** 2026-06-11
**Decision:** All sensitive data defaults to local device storage. Cloud sync is optional and requires explicit user consent per data category.
**Reasoning:** Health metrics, body photos, medications, journal entries, and clinical data are highly personal. Users should not need to trust a cloud provider with this data. Local-first also enables offline operation, reduces AI API cost (no need to send sensitive data to cloud), and creates a genuine privacy differentiator.
**Risk:** Cross-device sync is limited for sensitive data. If device is lost without backup, sensitive data is lost. Complicates architecture (two persistence layers).
**Rejected Alternatives:** Cloud-first (simpler sync, but privacy liability), encrypt-and-sync everything (technical but loses the clear opt-in model).
**Status:** Final
**Impact Area:** Privacy, security, architecture, sync, AI

---

## D-007: AI Provider Abstraction Layer Required

**Date:** 2026-06-11
**Decision:** All AI calls must go through a provider-agnostic abstraction layer. No hardcoded dependency on any single AI provider.
**Reasoning:** AI provider landscape is rapidly changing. Costs, capabilities, and terms of service change. The optimal provider for coaching may differ from the optimal provider for vision validation or weekly summaries. Abstraction allows routing by task, fallback on provider failure, and future on-device AI integration.
**Risk:** Additional architectural complexity. Provider-specific features may be hard to abstract.
**Rejected Alternatives:** Hardcode OpenAI (simpler but locks vendor), use LangChain (Swift SDK immature).
**Status:** Final
**Impact Area:** AI architecture, cost, resilience

---

## D-008: Nutrition is Phase 2

**Date:** 2026-06-11
**Decision:** Full nutrition and meal tracking is explicitly Phase 2 and not included in the MVP buildable sequence.
**Reasoning:** Nutrition tracking is a complex domain (food database, macro calculation, photo meal analysis, logging friction). Adding it to MVP would expand scope significantly without delivering the core discipline OS value. Hydration (water) is included in MVP as a core health pillar.
**Risk:** Users who expect full nutrition tracking may be disappointed. Competitors may offer this.
**Rejected Alternatives:** Include nutrition with a simple food diary (rejected: logging friction undermines UX quality).
**Status:** Final
**Impact Area:** Scope, product roadmap, user expectations

---

## D-009: Gmail Limited to Travel and Reservation Context

**Date:** 2026-06-11
**Decision:** Gmail integration is scoped exclusively to detecting flights, hotels, reservations, and travel dates for the purpose of suggesting context mode changes. It is not a general email task management system.
**Reasoning:** General email task extraction is a full product (Superhuman, Spark, etc.). It creates major scope risk. Gmail OAuth also introduces significant privacy and security considerations. Limiting to travel detection delivers real value (automatic Tour Mode suggestion) at contained risk.
**Risk:** Users may expect more from a Gmail integration. OAuth scope may still be broad depending on API.
**Rejected Alternatives:** Full email task extraction (too large, privacy risk), no Gmail integration at all (loses travel detection value).
**Status:** Final
**Impact Area:** Scope, privacy, integrations

---

## D-010: Claude Must Not Start Coding Before Sprint 1 Approval

**Date:** 2026-06-11
**Decision:** No implementation code, Xcode files, Swift source files, Supabase configuration, or production scaffolding may be created until Sprint 0 is complete and Sprint 1 is explicitly approved by Andrés.
**Reasoning:** Sprint 0 is strategy, not execution. Starting code before strategy is finalized causes rework and architectural debt. All decisions must be made before code is written.
**Risk:** Impatience to start building may create pressure to skip this rule.
**Rejected Alternatives:** Start coding immediately (creates scope chaos).
**Status:** Final — Sprint 0 binding rule
**Impact Area:** Process, quality, architecture

---

## D-011: Sign in with Apple + Google Only (No Email/Password in MVP)

**Date:** 2026-06-11
**Decision:** Authentication in MVP is limited to Sign in with Apple and Google Sign-In. Email/password authentication is not included.
**Reasoning:** Email/password requires password reset flows, validation, rate limiting, and security hardening. Sign in with Apple is privacy-first and required by Apple for apps with third-party login. Google covers non-Apple ecosystem users who create a partner account. Eliminating email/password reduces implementation scope and security surface.
**Risk:** Some users may prefer email/password. Accountability partners who don't have Apple or Google accounts cannot onboard.
**Rejected Alternatives:** Email/password only (rejected: privacy and implementation overhead), Magic link email (rejected: adds email infrastructure).
**Status:** Final
**Impact Area:** Auth, onboarding, security

---

## D-012: DeviceActivity / App Blocking is Feasibility-Gated

**Date:** 2026-06-11
**Decision:** App blocking and Screen Time enforcement features (DeviceActivity, FamilyControls, ManagedSettings) are feasibility-gated. They will be investigated in Sprint 11. If the entitlement is restricted or the API does not support the use case, the fallback is Focus Modes + accountability reporting.
**Reasoning:** Apple's Family Controls API is powerful but requires a special entitlement and is primarily designed for parental controls. Its use in a personal accountability context is technically possible but may face App Store review friction. Building a significant feature on an uncertain API is a risk.
**Risk:** Sprint 11 may discover the feature is not implementable as designed. Core Focus Engine would then be limited to timer + reporting.
**Rejected Alternatives:** Assume it works and design around it (rejects the feasibility-first principle).
**Status:** Pending validation (Sprint 11)
**Impact Area:** Focus Engine, Sprint 11 scope

---

## D-013: Body Progress Photos are Never Auto-Uploaded

**Date:** 2026-06-11
**Decision:** Body progress photos are stored locally only, never automatically uploaded to cloud storage. Upload requires explicit user opt-in, and AI analysis of body photos requires a separate, additional consent.
**Reasoning:** Body photos are highly sensitive personal data. Users need absolute confidence that this data does not leave their device without their knowledge. Automatic upload — even to encrypted storage — would undermine trust. AI analysis is optional and must never be forced.
**Risk:** Users who want cross-device body progress tracking have no automatic solution. Manual export only.
**Rejected Alternatives:** Encrypt and auto-sync to Supabase (rejected: erodes the trust model for highly sensitive data).
**Status:** Final
**Impact Area:** Privacy, evidence storage, Ultra Strict Mode

---

## D-014: AI Coach Tone — Strict but Not Abusive

**Date:** 2026-06-11
**Decision:** The AI Coach's personality is strict, direct, demanding, and evidence-based. It confronts excuses and weak patterns. It never humiliates, insults, or acts abusively. It is not motivational fluff.
**Reasoning:** The product is designed for users who want real accountability, not a cheerleader. But aggressive or abusive AI behavior creates legal, ethical, and reputational risk, and is counterproductive. The target is the tone of a strict professional coach who respects the athlete but does not accept weak excuses.
**Risk:** "Strict" AI may trigger negative user reactions if the line between demanding and harsh is crossed. Prompt engineering must be carefully maintained.
**Rejected Alternatives:** Purely motivational tone (rejected: out of character), fully confrontational/harsh tone (rejected: ethically problematic).
**Status:** Final
**Impact Area:** AI Coach, product experience, safety

---

## D-015: MVVM + Clean Architecture with Feature-Based Modules

**Date:** 2026-06-11
**Decision:** The app uses MVVM with Clean Architecture separation (Domain / Data / Presentation) organized into feature-based modules sharing a Core Swift Package.
**Reasoning:** Feature-based modules enable parallel development, enforce boundaries between domains, and scale to the full feature set without becoming a monolithic view controller mess. Clean Architecture ensures business logic is testable without UI or database dependencies.
**Risk:** Higher initial setup complexity. May feel over-engineered in Sprint 1.
**Rejected Alternatives:** Simple MVC (doesn't scale to 12+ modules), VIPER (too ceremonial for SwiftUI).
**Status:** Final
**Impact Area:** Architecture, sprint velocity, testability

---

## D-016: PROJECT_CONTEXT.md is the Living Source of Truth

**Date:** 2026-06-11
**Decision:** PROJECT_CONTEXT.md must be updated after every meaningful implementation or architecture change. If code changes and this file does not, the file is wrong.
**Reasoning:** Large projects lose coherence when documentation falls out of sync with code. PROJECT_CONTEXT.md is the contract between GPT (strategic layer), Claude (execution layer), and Andrés (owner/tester). All three parties rely on it being current.
**Risk:** Updating it requires discipline — ironically, maintaining documentation requires the same discipline the product promotes.
**Rejected Alternatives:** Inline code comments only (rejected: not accessible to strategic review), separate wiki (rejected: more friction to update).
**Status:** Final — binding process rule
**Impact Area:** Process, documentation, team coordination

---

## D-017: SwiftData as Local Persistence Layer

**Date:** 2026-06-11
**Decision:** SwiftData is the primary local persistence framework, with Core Data as a documented fallback if SwiftData has blocking issues.
**Reasoning:** SwiftData is Apple's current-generation persistence framework (iOS 17+, macOS 14+). It integrates with SwiftUI via `@Query` and `@Model`. It supports relationships, migrations, and CloudKit sync if needed later. The iOS 17+ requirement is acceptable for a new app in 2026.
**Risk:** SwiftData is relatively new and may have edge cases in complex migrations or relationship handling.
**Rejected Alternatives:** Core Data (older, more verbose), SQLite direct (no ORM), Realm (third-party dependency).
**Status:** Final (with Core Data fallback documented)
**Impact Area:** Local persistence, Sprint 2

---

## D-018: Apple Platform Capabilities Are API-Supported but Gated — Not Unconditionally Confirmed

**Date:** 2026-06-11
**Decision:** All Apple platform APIs used by Oathen must be documented as "API-supported capabilities subject to user permission, entitlement availability, platform version requirements, and App Store Review." No Apple API is treated as an unconditionally confirmed implementation capability.
**Reasoning:** Apple API availability in production depends on multiple runtime factors: the user must grant permission; some APIs require special entitlements approved by Apple; some features require specific hardware (e.g., Dynamic Island, Apple Watch); App Store Review can reject apps that misuse entitlements. Treating all APIs as confirmed risks building on unavailable or rejected capabilities. DeviceActivity, FamilyControls, and ManagedSettings are the highest-risk examples and remain explicitly feasibility-gated until Sprint 11 validates them.
**Risk:** Some planned Apple ecosystem features (app blocking, certain Live Activity behaviors, background execution) may need fallback implementations if entitlements are denied or APIs are more limited than expected.
**Rejected Alternatives:** Treating all Apple APIs as fully confirmed implementation capabilities from Sprint 0 (rejected: creates false confidence and overbuilding risk).
**Status:** Approved — applies to all sprints
**Impact Area:** Apple platform architecture, implementation planning, Sprint 6 (notifications), Sprint 9 (Watch), Sprint 11 (Focus Engine)

---

## D-019: XcodeGen Used for Project Generation (Never Handcraft .pbxproj)

**Date:** 2026-06-11
**Decision:** `Oathen.xcodeproj` is generated from `project.yml` using XcodeGen 2.45.4. The `.pbxproj` file is never handcrafted and is excluded from manual edits. All structural changes to the Xcode project (new targets, new files, new build settings) go through `project.yml` first, then `xcodegen generate`.
**Reasoning:** Handcrafted `.pbxproj` files are merge-conflict-prone, opaque, and error-prone. XcodeGen provides a declarative, version-controlled source of truth for project structure. XcodeGen does not require Xcode to be installed to generate the project, enabling project structure setup before Xcode is available.
**Risk:** XcodeGen syntax must be maintained. XcodeGen version upgrades may require project.yml adjustments.
**Rejected Alternatives:** Handcraft `.pbxproj` (rejected: too error-prone), Tuist (rejected: adds Swift macro layer, more complexity), Swift Package Manager executables (rejected: not appropriate for a multiplatform app target).
**Status:** Final — binding for all sprints
**Impact Area:** Sprint 1+, project structure, CI/CD

---

## D-020: Validation Builds Use `-target` + `-sdk` (Not `-scheme` + `-destination`)

**Date:** 2026-06-11
**Decision:** Sprint 1 validation builds use `xcodebuild -target <name> -sdk <sdk>` instead of `-scheme <name> -destination <specifier>`. The XcodeGen multiplatform target (`platform: [iOS, macOS]`) generates schemes named `Oathen_iOS` and `Oathen_macOS` (not a bare `Oathen` scheme). The `-destination` flag requires a simulator runtime to be installed; the `-sdk` flag compiles against the SDK headers only and does not require a runtime.
**Reasoning:** (1) The scheme name `Oathen` does not exist in the generated project — using it caused all builds to fail silently. (2) `-destination 'generic/platform=iOS Simulator'` requires the iOS simulator platform runtime to be installed in Xcode, not just the SDK. The `-sdk` approach compiles the code without a runtime, which is sufficient for a shell-validity check. (3) Using `-target` is more explicit and portable across machines with different simulator runtimes installed.
**Risk:** `-target` bypasses scheme-level build settings. If scheme-level customizations are added in the future, the validation script must be updated to use `-scheme` once all destination requirements are met.
**Rejected Alternatives:** `-scheme Oathen -destination 'generic/platform=iOS Simulator'` (rejected: scheme doesn't exist; destination requires simulator runtime).
**Status:** Final for Sprint 1; revisit in Sprint 9 (Watch) when simulator runtime testing becomes critical
**Impact Area:** `scripts/validate_sprint1.sh`, CI/CD pipeline design

---

## D-021: Sprint 2 Implements Only Core Domain Models, Not the Full Data Model

**Date:** 2026-06-11
**Decision:** Sprint 2 implements 9 core domain models (Goal, Project, Habit, OathenTask, Routine, RoutineStep, Evidence, DisciplineScore, ContextMode), 6 value objects, 2 policy helpers, and 1 fixtures file — not the full ~42-entity data model from the Sprint 0 plan. No SwiftData, no persistence, no Supabase schemas.
**Reasoning:** Establishing a stable, testable domain language before introducing SwiftData, Supabase, HealthKit, or AI complexity is critical. The domain layer must be correct and clean before persistence can be layered on top. Attempting to implement all 42 entities in a single sprint would introduce untested assumptions that compound in every subsequent sprint.
**Risk:** Some future entities remain documented but not implemented yet. Sprint 3+ depends on these domain types being stable.
**Rejected Alternatives:** Implementing all ~42 planned entities in Sprint 2 (rejected: too much surface area to test or stabilize); adding SwiftData persistence immediately (rejected: premature, would lock in schema before domain validation); adding backend schemas before domain validation (rejected: Supabase schema changes are harder to reverse than Swift struct changes).
**Status:** Approved
**Impact Area:** Architecture, implementation sequence, scope control, data model

---

## D-022: Sprint 3 Implements In-Memory Daily Routine Engine Before Persistence

**Date:** 2026-06-12
**Decision:** Sprint 3 implements the full Morning Check-in → Daily Plan → Day Progress → Night Review → Discipline Score loop as an in-memory experience only. No SwiftData, no Core Data, no Supabase, no HealthKit, no AI. State resets on app restart.
**Reasoning:** The product needs a usable daily accountability loop before adding external integration complexity. A clean in-memory implementation validates the product flow and domain model interactions without introducing persistence coupling. Users (Andrés) can verify the daily routine UX before committing to a schema. The in-memory constraint forces the domain model design to be clean and correct — persistence will follow from a tested baseline.
**Risk:** Data resets when the app restarts. Users cannot test multi-day patterns until Sprint 3+ adds persistence. The in-memory state boundary must be clearly documented and enforced.
**Rejected Alternatives:** Adding SwiftData immediately (rejected: premature before daily flow validation); integrating HealthKit before the daily routine loop (rejected: adds complexity before core UX is validated); adding AI Coach before deterministic local behavior exists (rejected: non-determinism before correctness).
**Status:** Approved
**Impact Area:** Product, UX, architecture, implementation sequence, scope control

---

## D-023: SwiftData Persistence Uses Separate @Model Entities, Not @Model on Domain Structs

**Date:** 2026-06-14
**Decision:** Sprint 4 adds SwiftData persistence via a separate `Core/Data/LocalPersistence/` layer. The 5 domain models that need persistence (`TodayState`, `DailyPlan`, `DailyPlanItem`, `MorningCheckIn`, `NightReview`) are wrapped by separate `Persistent*` `@Model` classes. Domain structs remain annotation-free.
**Reasoning:** SwiftData `@Model` converts structs to reference-type classes and adds runtime coupling to the persistence layer. Domain models must remain pure Swift for testability (compiled directly into `OathenTests` without a host app), Codable round-trips, `Sendable` conformance, and clean watchOS builds. The mapper pattern (domain ↔ persistent) is a well-established clean architecture pattern that makes the boundary explicit and testable. The additional mapper code is a small cost compared to the flexibility gained.
**Risk:** Mapper boilerplate; risk of mapper and domain model diverging silently. Mitigated by: mapper round-trip unit tests, `validate_sprint4.sh` grep checks for `@Model` in domain files, and `DisciplineScore` being recalculated (not persisted) so it can never drift.
**Rejected Alternatives:** Adding `@Model` directly to domain structs (rejected: couples domain to SwiftData, breaks `OathenTests` bundle compilation, breaks watchOS build, removes Sendable conformance); using `NSCoding` / `Codable` + file system (rejected: more boilerplate, harder querying, no SwiftUI integration); full Core Data stack (rejected: more complex setup, less Swift-native).
**Status:** Approved
**Impact Area:** Architecture, persistence, testing, watchOS compatibility, scope control

---

## D-024: DisciplineScore Is Not Persisted — Recalculated on Load

**Date:** 2026-06-14
**Decision:** `DisciplineScore` is not persisted to SwiftData. On every load of a `TodayState` from the store, `DailyRoutinePolicy.calculateScore(from:)` is called to recompute the score.
**Reasoning:** `DisciplineScore` is a pure function of the plan state at a given point in time. Persisting it would create a secondary source of truth that could silently diverge from the actual plan completion data. Recalculating is deterministic, cheap, and ensures the score is always consistent with the loaded plan items' completion state. `DisciplineScore` contains a `ScoreBreakdown` struct which would require additional persistent entity fields for no gain.
**Risk:** Score calculation changes in a future sprint (e.g., when HealthKit data is added) will retroactively change scores for loaded historical days. This is intentional — stored plan completion states are facts, score interpretation is policy.
**Rejected Alternatives:** Persisting `DisciplineScore` and `ScoreBreakdown` directly (rejected: derived value problem, additional entity complexity); caching score in `PersistentTodayState` as a simple `Int` (rejected: still a second source of truth, marginal benefit).
**Status:** Approved
**Impact Area:** Persistence architecture, score consistency, future HealthKit integration
