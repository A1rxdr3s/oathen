# UX_FLOWS.md — Oathen / Discipline OS
## User Experience Flows

---

## Navigation Architecture

### iPhone — Primary Navigation

```
Tab Bar (5 tabs)
├── Today           — Daily Command Center
├── Goals           — Goal / Project / Habit / Task hierarchy
├── Coach           — AI Coach conversation + insights
├── Health          — Exercise, hydration, sleep, body metrics
└── You             — Score history, achievements, settings
```

### Mac — Navigation Architecture

```
Navigation Split View (3-column)
├── Sidebar
│   ├── Today
│   ├── Goals & Projects
│   ├── Weekly Planning
│   ├── Coach
│   ├── Analytics
│   ├── Templates
│   ├── Settings
│   └── Privacy
├── Content List      — Items for selected section
└── Detail Panel     — Expanded view / editing
```

### Apple Watch — Navigation

```
Watch Face Complications
    ↓
App Entry Points:
├── Today Summary (complication)
├── Quick Log (hydration, exercise)
├── Check-in prompt
├── Score status
└── Next action
```

---

> **Sprint 3 Note:** Sections 2, 3, and 4 document the full production UX intent.
> Sprint 3 ships a functional in-memory version of these flows. Where Sprint 3 behavior
> differs from the production design, implementation notes are marked with `[Sprint 3]`.
> All Sprint 3 state is in-memory only — it resets on app restart. Persistence arrives in Sprint 4+.

---

## 1. Onboarding Flow

### Screen Sequence

```
1. Welcome — Oathen identity, oath concept, "This is not a to-do app"
2. Auth — Sign in with Apple / Google (no guest mode in MVP)
3. Setup: Name + timezone
4. Core Intentions
   - What do you want to build discipline around?
   - (exercise / focus / hydration / sleep / goals / all)
5. First Goal Setup — guided goal creation
   - Title, category, target date (optional)
   - AI suggests sub-goals / breakdown
   - User approves or adjusts
6. Morning Routine Setup
   - Wake time, Morning Check-in time
7. Evening Routine Setup
   - Night Review time, sleep target
8. HealthKit Permission Request
   - Explain why each data type is needed
   - Request only what user agreed to track
9. Notification Permission
   - Explain escalation concept
   - Let user configure strictness level
10. Context Mode
    - "How strict should I be with you?" (Normal / Strict / Ultra Strict toggle)
11. Accountability Partner (optional, skip available)
12. Privacy Settings Overview
    - Local-first explanation
    - Cloud sync opt-in
    - AI processing consent per category
13. First Day Plan — AI generates, user approves
14. Onboarding Complete — Today screen unlocked
```

**Rule:** Never request permissions without explaining why. Never batch all permissions at app launch.

---

## 2. Today (Daily Command Center) — iPhone

### Morning State (pre-Check-in)

```
┌─────────────────────────────────────┐
│  [Morning Check-in required]        │
│  Good morning, Andrés               │
│  Complete your morning check-in     │
│  to activate today's plan.          │
│                                     │
│  [Begin Morning Check-in →]         │
└─────────────────────────────────────┘
```

### Active Day State

```
┌─────────────────────────────────────┐
│  THURSDAY   Discipline Score: 74    │
│  [Context badge: Normal]            │
│  ─────────────────────────────────  │
│  CRITICAL (1)                       │
│  ○ Finish DJHQ mix review   [Due]   │
│                                     │
│  HIGH (2)                           │
│  ○ Morning workout (45 min)  12:00  │
│  ○ 3L water goal            ██░░ 2L │
│                                     │
│  NORMAL (3)                         │
│  ○ Reply to booking agent           │
│  ○ Studio session 2h                │
│  ○ Read (30 min)                    │
│                                     │
│  HABITS                             │
│  ✓ Morning routine completed        │
│  ○ Evening journaling               │
│                                     │
│  Coach: "You skipped workout        │
│  yesterday. Don't let it be two."   │
│  [→ Coach]                          │
└─────────────────────────────────────┘
```

### Overdue State

```
┌─────────────────────────────────────┐
│  ⚠ OVERDUE                          │
│  Morning workout was due at 12:00   │
│  It is now 14:30. This will affect  │
│  your Discipline Score.             │
│                                     │
│  [Mark Done] [Postpone] [Skip]      │
│                                     │
│  Skipping requires a reason.        │
└─────────────────────────────────────┘
```

### [Sprint 3] Today Command Center — Live Implementation

The Today tab is connected to `TodayViewModel` (in-memory, `@Observable @MainActor`).
State is injected via SwiftUI environment from `OathenApp`.

**Cards displayed (top to bottom):**

```
DisciplineScoreCard     — animated score ring; color-coded (green ≥80 / yellow ≥60 / orange ≥40 / red <40)
MorningCheckInCard      — green checkmark when complete; "Start Morning Check-in" button when not
TodayProgressCard       — animated progress bar; morning + night status pills
DailyPlanCard           — Critical and High items only; circle-toggle to complete; strikethrough animation
HealthPillarsCard       — Hydration / Exercise / Sleep routine toggle rows
NightReviewCard         — "Review your day" prompt; "✓ Day Closed" when complete
Coach nudge             — text-only local rule-based nudge from DailyRoutinePolicy.coachNudge
```

**Sheets opened from Today:**
- Morning Check-in → `MorningCheckInView` (Form sheet)
- Night Review → `NightReviewView` (Form sheet)
- Daily Plan detail → `DailyPlanView` (sheet, priority-grouped list)

**Limitations (Sprint 3 — resolved in future sprints):**
- State resets on app restart (no SwiftData/Supabase persistence)
- Daily plan items are default-generated (no user-customizable tasks yet)
- Coach nudge is rule-based text, not AI-generated
- Overdue state and due-time alerts are not yet implemented
- Context badge is set during Morning Check-in but not used for automatic plan adjustment

---

## 3. Morning Check-in Flow

```
Step 1: Sleep Review
  ─────────────────
  "How did you sleep?"
  ○ Hours: [auto-populated from HealthKit / manual entry]
  ○ Quality: [1-5 tap selector]
  ○ HealthKit badge: "Synced from Apple Watch"

Step 2: State Assessment
  ─────────────────────
  Energy level today: [1-5]
  Focus level: [1-5]
  Main obstacle or blocker: [text, optional]

Step 3: Today's Plan Review
  ─────────────────────────
  [AI-generated plan shown]
  "Here is your plan for today."
  [Critical tasks listed with times]
  [Habits listed]
  [Exercise goal shown]
  [Hydration goal shown]
  [Approve Plan] [Adjust Plan]

Step 4: Confirmation
  ─────────────────
  Context mode for today: [Normal / Travel / Rest Day...]
  Exercise goal: [confirmed]
  Hydration goal: [confirmed]
  [Begin Day →]
```

**States:**
- **Completed on time:** Green badge, day unlocked.
- **Skipped:** Score penalty; AI Coach notes it.
- **Completed late:** Logged with timestamp; AI notes pattern.

### [Sprint 3] Morning Check-in — Live Implementation

Sprint 3 ships a Form sheet (`MorningCheckInView`) in place of the multi-step wizard above.

```
MorningCheckInView (sheet)
  ├── Sleep Hours slider    — range 3.0–12.0h, step 0.5; stored as Double?
  ├── Energy Level picker   — Low / Moderate / High
  ├── Focus Level picker    — Scattered / Moderate / Sharp
  ├── Mood picker           — Low / Neutral / Good / Excellent
  ├── Context Mode picker   — matches ContextMode enum (Normal, Travel, etc.)
  ├── Main Obstacle field   — optional free text
  └── [Lock In Commitments] — completes MorningCheckIn; dismisses sheet
```

**How it differs from the production design:**
- No HealthKit sleep auto-population (Step 1 production) — sleep hours are manual only
- No 5-level quality selector — replaced by EnergyLevel / FocusLevel / MoodLevel pickers
- No AI-generated plan review (Step 3 production) — plan is pre-generated by `DailyRoutinePolicy`
- No multi-step wizard — single Form sheet
- Defaults available via `completeMorningCheckInWithDefaults()` for fast completion

---

## 4. Night Review Flow

```
Step 1: Day Summary (auto-generated)
  ─────────────────────────────────
  Discipline Score for today: [score]
  Tasks completed: X/Y
  Habits completed: X/Y
  Exercise: [done / skipped]
  Hydration: [goal met / missed by Xml]

Step 2: Failures / Gaps
  ─────────────────────
  "You skipped 2 tasks today."
  [Task 1]: [require justification]
  [Task 2]: [require justification]
  Excuses detected: [AI flags patterns like "too tired", "forgot"]

Step 3: Tomorrow Planning
  ─────────────────────────
  "Shall we adjust tomorrow's plan based on today?"
  [AI suggests] → [User approves or adjusts]

Step 4: Pre-Sleep Routine
  ─────────────────────────
  "Your sleep target is 23:00."
  Screen time warning if device used past target.
  [Mark as ready to sleep]
```

### [Sprint 3] Night Review — Live Implementation

Sprint 3 ships a Form sheet (`NightReviewView`) in place of the multi-step flow above.

```
NightReviewView (sheet)
  ├── Auto-calculated stats (read-only)
  │     ├── Tasks complete: X / Y
  │     ├── Critical complete: X / Y
  │     ├── Health pillars: Hydration ✓/✗, Exercise ✓/✗, Sleep Routine ✓/✗
  ├── Commitment rows — toggle each completed critical task ID
  ├── Health pillar rows — confirm hydration / exercise / sleep routine completion
  ├── Failure Reason field  — optional free text; excuse warning shown if patterns detected
  │     └── Detected phrases: "didn't have time", "too tired", "forgot", "was busy",
  │                           "too hard", "it's fine", "next time", "couldn't be bothered"
  ├── Recovery Plan preview — generated by DailyRoutinePolicy.recoveryRecommendation
  └── [Close the Day] — completes NightReview; triggers score recalculation; dismisses sheet
```

**How it differs from the production design:**
- No AI-generated day summary (Step 1) — stats are calculated directly from DailyPlan state
- No AI excuse flagging — excuse detection is local keyword matching (`NightReview.detectExcuse`)
- No tomorrow planning step (Step 3) — plan resets to defaults on each launch (no persistence yet)
- No pre-sleep screen time warning (Step 4) — DeviceActivity / notifications are Sprint 6+
- Excuse detection is advisory only — user can proceed regardless of detected excuse

---

## 5. Weekly Review Flow

```
Step 1: Week Score Summary
  ─────────────────────────
  Average Discipline Score: [score]
  Best day: [day + score]
  Worst day: [day + reason]
  Score trend: [chart]

Step 2: Habit / Exercise / Hydration / Sleep
  ─────────────────────────────────────────
  Hydration consistency: 5/7 days
  Exercise consistency: 4/7 days (goal: 5)
  Sleep average: 6.8h (target: 7.5h)
  Habits completed: 28/35

Step 3: Excuse Patterns
  ────────────────────
  "You used 'tired' as a reason 4 times this week."
  "You postponed morning workouts 3 times."
  [Coach response to patterns]

Step 4: AI Recommendations
  ────────────────────────
  [AI Coach generates 3-5 recommendations]
  "Move workout earlier based on your skip pattern."
  [User approves / dismisses / saves each]

Step 5: Next Week Planning
  ─────────────────────────
  [AI proposes next week plan adjustments]
  [User approves or adjusts]
  [Activate] 
```

---

## 6. Task Detail and Evidence Flow

### Task Detail Screen

```
[Task Title]                    [Priority badge]
[Status] [Scheduled date] [Deadline]
[Estimated time: 45 min]        [Project: DJHQ]

Description: ────────────────
[text]

Evidence Required: Photo
[Capture Evidence] or [View Evidence]

History:
- Created: [date]
- Postponed: 1 time (reason logged)

AI Notes:
"This task has been postponed twice. Deadline is in 3 days."

[Start Focus Session] [Mark Done] [Postpone] [Cancel]
```

### Evidence Capture Flow

```
[Tap "Capture Evidence"]
    ↓
Choose type:
  ○ Photo
  ○ Metric entry
  ○ Manual confirmation (low-evidence mode)
    ↓
[Camera opens] or [Metric input]
    ↓
Preview + optional note
    ↓
[Submit Evidence]
    ↓
AI validation (if enabled):
  "Validating your photo..."
  Result: "Evidence accepted" / "Unclear — retake?" / "Needs review"
    ↓
Task marked complete
Evidence stored locally
```

---

## 7. Hydration Tracking Flow

### Quick Log (Most Common)

```
Today Widget or Watch tap
    ↓
[+250ml] [+500ml] [+750ml] [Custom]
    ↓
Logged instantly
    ↓
Progress bar updated: 2.25L / 3L
```

### Evidence-Required Mode (Ultra Strict or configured)

```
Hydration check-in reminder fires
    ↓
"Log your hydration with photo evidence"
    ↓
[Capture photo]
    ↓
AI validates: "Photo shows a bottle — looks like ~500ml of water"
    ↓
[Confirm] or [Adjust amount]
    ↓
Logged
```

---

## 8. Exercise Tracking Flow

### HealthKit Auto-Detection

```
Apple Watch workout detected
    ↓
Oathen notification: "Workout detected: 45 min run"
    ↓
[Confirm and link to today's goal?]
    ↓
[Yes] → Goal progress updated, evidence stored
[No] → Workout not counted (user can link manually later)
```

### Manual Session Flow

```
[Log Workout]
    ↓
Type: [Running / Lifting / Cycling / Custom...]
Duration: [45 min]
Notes: [optional]
    ↓
[Save]
    ↓
HealthKit write (if permitted)
Goal progress updated
```

---

## 9. Focus Session Flow

### Start Session

```
[Task card] → [Start Focus Session]
    ↓
Pre-session checklist:
  ○ Phone on Do Not Disturb?
  ○ Water ready?
  ○ Clear workspace?
  [Start 25 min / 45 min / Custom]
    ↓
Live Activity activates on iPhone Lock Screen
Timer running
    ↓
If distraction app opened:
  Warning: "You opened Instagram during your focus session."
  [Return to focus] [Log interruption]
```

### Session End

```
Timer complete / User ends session
    ↓
Post-session:
  Actual time: [calculated]
  Task progress: [% done? → input]
  Distractions: [count logged]
    ↓
[Complete Task] or [Continue Later]
    ↓
Score credit applied
```

---

## 10. Ultra Strict Mode Flow

### Activation

```
Settings → Ultra Strict Mode
    ↓
"This mode is intense. It reduces postponements,
requires evidence for critical habits, and logs
all failures. Are you committed?"
    ↓
[Choose duration: 7 / 14 / 30 / 45 days / Custom]
    ↓
"Your accountability partner will be notified
of major failures if alerts are enabled."
    ↓
[Activate Ultra Strict Mode]
    ↓
Confirmation: "Mode active. No soft exits without
logging the abandonment."
```

### Ultra Strict Active State

```
Visual indicator: [ULTRA STRICT] badge in UI
Stricter score penalties shown
Evidence required on all critical habits
Postponements limited: "1 postpone remaining today"
Exit: [Exit Ultra Strict Mode] → requires reason + logged as abandonment
```

---

## 11. Context Mode Flow

### Automatic Detection

```
System detects: travel in calendar tomorrow
    ↓
Notification: "You have a flight tomorrow.
Activate Tour Mode? Your plan will be adjusted."
    ↓
[Yes, activate] [No, keep normal] [Remind me later]
    ↓
If Yes:
  Mode activates
  Plan adjusts: lighter hydration goal, no home gym session
  AI notes: "Tour Mode active. Goals adjusted. Recovery plan on return."
```

### Manual Mode Activation

```
Today screen → [Context Mode badge]
    ↓
Mode picker:
  ○ Normal
  ○ Travel
  ○ Tour / Work travel
  ○ Vacation
  ○ Illness / Recovery
  ○ Rest Day
  ○ Ultra Strict
  ○ Post-travel recovery
    ↓
[Activate] → Plan adjusts immediately
```

---

## 12. Accountability Partner Flow

### Setup (Owner side)

```
Settings → Accountability Partner → [Invite]
    ↓
Enter email or share invite link
    ↓
Configure permissions:
  [Toggle list — see PermissionPolicy]
  "What can your partner see?"
    ↓
Review privacy summary
    ↓
[Send Invite]
```

### Setup (Partner side)

```
Receive invite link / email
    ↓
Open Oathen → Create basic partner account
    ↓
Accept invitation
    ↓
See partner's shared dashboard:
  Score trend
  Streaks
  On-track status
  [Only what owner permitted]
    ↓
Partner can: send nudge / receive weekly digest / receive critical alerts (if enabled)
```

---

## 13. Permission Request Flows

### HealthKit Permission

```
Feature first-use trigger
    ↓
Explanation screen:
  "To track your exercise goals and validate
  your workouts, Oathen needs access to
  your Apple Health data."
  [Data types listed]
  "Your health data never leaves your device
  unless you explicitly enable cloud sync."
    ↓
[Grant Access] → iOS HealthKit permission dialog
[Not now] → Feature works in manual-only mode
```

### Gmail Permission

```
Context mode engine → calendar insufficient → suggest Gmail
    ↓
Explanation screen:
  "Oathen can read your Gmail to detect
  travel bookings and help you activate
  Tour Mode automatically."
  "Oathen does NOT read general emails.
  Only flight/hotel/reservation patterns."
    ↓
[Connect Gmail] → OAuth flow
[Skip] → Manual travel context only
```

---

## 14. Apple Watch Flows

### Watch Home (Complication → App)

```
Complication: Score ring or next action
    ↓
App entry:
  Today summary
  ├── Score: 74
  ├── Next: Drink water (−45min)
  ├── Exercise: 30/45 min
  └── Habits: 3/5
```

### Quick Log from Watch

```
Crown press / complication tap
    ↓
Quick action:
  [+250ml] hydration
  [Start workout]
  [Check-in done]
  [Mark task complete]
```

### Alert on Watch

```
Escalation fires → Watch haptic + notification
"Your workout should have started 20 min ago."
[Done] [Snooze 10min] [Skip with reason]
```

---

## 15. Mac Dashboard Flows

### Today Command Center (Mac)

```
┌──────────────┬─────────────────────────────┬────────────────────┐
│  Sidebar     │  Today's Plan               │  Detail            │
│              │                             │                    │
│  Today ←     │  Score: 74   Thu Jun 11     │  [Task expanded]   │
│  Goals       │  ─────────────────────────  │                    │
│  Planning    │  CRITICAL                   │  DJHQ Mix Review   │
│  Coach       │  ○ DJHQ Mix Review   !!     │  ──────────────── │
│  Analytics   │                             │  Priority: Critical│
│  Templates   │  HIGH                       │  Due: Today        │
│  Settings    │  ○ Workout (45min)          │  Est: 2h           │
│  Privacy     │  ○ Hydration: 2L/3L         │                    │
│              │                             │  Evidence: None    │
│              │  NORMAL                     │  yet required      │
│              │  ○ Reply to booking         │                    │
│              │  ○ Studio 2h                │  [Start Focus]     │
│              │  ○ Read 30min               │  [Mark Done]       │
│              │                             │  [Postpone]        │
└──────────────┴─────────────────────────────┴────────────────────┘
```

### Goals & Projects (Mac)

```
Left panel: Goal list
Center panel: Projects under selected goal
Right panel: Habits + Tasks under selected project
Bottom bar: AI Coach context for selected item
```

---

## 16. Empty, Error, and Edge State Flows

### Empty State — No Tasks

```
"No tasks planned for today.
Your AI Coach can help you build a plan."
[Ask Coach to plan my day →]
```

### Error State — HealthKit Denied

```
"Exercise tracking requires Health access.
You can still log workouts manually."
[Grant Access] [Continue without Health]
```

### Error State — Offline

```
"You're offline. Your data is saved locally.
Everything syncs when you reconnect."
[No action required — transparent]
```

### Overdue Critical Task

```
[Red Live Activity on lock screen]
"DJHQ Mix Review is 2 hours overdue."
[Mark Done] [Skip with reason]
[Cannot dismiss without action in Ultra Strict Mode]
```

### Evidence Rejected

```
"Your photo evidence was not accepted."
[AI explanation: "Photo is blurry or doesn't show the activity clearly"]
[Retake] [Submit as manual confirmation] [Dispute]
```

### Streak Broken

```
"Your 14-day hydration streak was broken yesterday."
[Serious — no confetti, no infantilizing]
"Yesterday you missed your hydration goal."
Recovery nudge from Coach.
[See Recovery Plan]
```

### Score Below Threshold

```
[Night Review]
Score: 38
"This is significantly below your average (72).
Three critical tasks were skipped without justification."
Coach: "One bad day is recoverable. Two is a pattern. Let's plan tomorrow now."
[Plan Tomorrow →]
```
