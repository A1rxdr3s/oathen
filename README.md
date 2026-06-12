# Oathen — Personal Accountability OS

**Public brand:** Oathen (pronounced "Oaten")
**Internal system name:** Discipline OS
**Category:** Discipline, Health, Focus & Execution

> An oath is a serious personal commitment. Oathen converts your oaths into daily execution.

---

## What Oathen Is

Oathen is a premium Apple-native personal accountability operating system.

It is not a to-do app.
It is not a habit tracker.
It is not a generic AI chatbot.

It is a serious, strict, and intelligent operating system for your life — exercise, hydration, sleep, focus, tasks, goals, and AI coaching — across iPhone, Apple Watch, and Mac.

---

## Platform

- iPhone (primary)
- Apple Watch
- macOS (Mac dashboard)

---

## Tech Stack

- Swift 5.10+ / SwiftUI
- SwiftData (local persistence)
- Supabase (backend, sync, auth)
- HealthKit
- Provider-agnostic AI abstraction layer (OpenAI, Claude, Gemini)

---

## Documentation

| File | Purpose |
|---|---|
| [`docs/PROJECT_CONTEXT.md`](docs/PROJECT_CONTEXT.md) | Living source of truth — update after every sprint |
| [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) | Technical architecture reference |
| [`docs/DATA_MODEL.md`](docs/DATA_MODEL.md) | Complete data model with ~42 entities |
| [`docs/UX_FLOWS.md`](docs/UX_FLOWS.md) | UX flows for all major user journeys |
| [`docs/DESIGN_SYSTEM.md`](docs/DESIGN_SYSTEM.md) | Design language, tokens, components |
| [`docs/SPRINT_PLAN.md`](docs/SPRINT_PLAN.md) | Sprint roadmap and acceptance criteria |
| [`docs/DECISION_LOG.md`](docs/DECISION_LOG.md) | Architecture and product decision record |
| [`docs/SCOPE_CONTROL.md`](docs/SCOPE_CONTROL.md) | MVP scope, Phase 2, out of scope |
| [`docs/SECURITY_PRIVACY.md`](docs/SECURITY_PRIVACY.md) | Security and privacy architecture |
| [`docs/AI_SYSTEM.md`](docs/AI_SYSTEM.md) | AI architecture, provider abstraction, Coach behavior |
| [`docs/COST_MODEL.md`](docs/COST_MODEL.md) | Cost estimates at personal, 100, and 1,000 user scale |

---

## Current Status

**Sprint 0 — Master Plan: Complete**

Awaiting Sprint 1 approval to begin SwiftUI project base.

---

## Working Relationship

- **GPT** — strategic layer: debates product decisions, controls scope, generates English instructions for Claude.
- **Claude** — execution layer: architecture, documentation, code (Sprint 1+).
- **Andrés** — owner, tester, decision maker.
