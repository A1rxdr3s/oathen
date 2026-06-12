# AI_SYSTEM.md — Oathen / Discipline OS
## AI Architecture Reference

---

## 1. AI Philosophy

Oathen's AI must be:

- **Useful** — AI acts on real user data, not generic advice.
- **Contextual** — Coach knows the user's goals, history, score, patterns.
- **Strict** — Coach confronts excuses. Coach does not give passes.
- **Non-diagnostic** — AI never crosses into medical territory.
- **Privacy-preserving** — Sensitive data is processed locally or not at all.
- **Cost-controlled** — AI usage is metered, cached where possible, and provider-routed by task.
- **Provider-agnostic** — No single AI provider dependency.

**The AI Coach is NOT a general chatbot.** It is a domain-specific coaching agent connected to the user's Discipline OS data.

---

## 2. AI Provider Abstraction Layer

### Design

```
Client Code
    ↓
AIRouter — selects provider for task type
    ↓
AIProvider Protocol — abstract interface
    ↓
Concrete Implementations:
  OpenAIProvider
  ClaudeProvider
  GeminiProvider
  OnDeviceProvider (Apple Intelligence — future)
  RulesBasedProvider (offline fallback)
```

### AIProvider Protocol (Design Intent)

> **Conceptual Pseudocode — Not a Swift source file.** The snippets below illustrate the intended design of the AI abstraction layer. They are not compilable Swift and do not represent the final implementation. Real Swift source code will be written in Sprint 7 after the architecture is validated in working code.

```
// CONCEPTUAL DESIGN INTENT — NOT PRODUCTION CODE
// AIProvider — abstract interface all providers implement
AIProvider {
    identifier: String
    supportsVision: Bool

    complete(request: AIRequest) → AIResponse
    stream(request: AIRequest) → AsyncStream<String>
    validateEvidence(image: Data, context: EvidenceContext) → EvidenceValidation
    estimateCost(request: AIRequest) → CostEstimate
}
```

### AIRouter Logic (Conceptual)

> **Conceptual Pseudocode — Not a Swift source file.** Design intent only.

```
// CONCEPTUAL DESIGN INTENT — NOT PRODUCTION CODE
// AIRouter — selects provider by task, consent, and availability
selectProvider(task, userConsent):
    coachMessage         → userConfiguredCoachProvider ?? openAIProvider
    planGeneration       → claudeProvider ?? openAIProvider
    longAnalysis         → claudeProvider ?? openAIProvider
    evidenceValidation   → (consent.allowsVisionAI)
                           ? geminiVisionProvider ?? openAIVisionProvider
                           : manualValidationFallback
    sensitiveInsight     → (onDeviceAvailable) ? onDeviceProvider : redactedCloudProvider
    weeklySummary        → claudeProvider ?? openAIProvider
    offline / noConsent  → rulesBasedProvider
```

### Provider Configuration

| Provider | Primary Use | Model Target | Notes |
|---|---|---|---|
| OpenAI | AI Coach conversation, daily plan | GPT-4o or GPT-4.1 | Primary coach provider |
| Anthropic Claude | Long analysis, planning, weekly review | claude-sonnet-4-6 or opus | High-quality synthesis |
| Google Gemini | Photo/vision evidence validation | gemini-2.0-flash | Vision accuracy |
| Apple Intelligence | Sensitive local insights | On-device (future) | Requires iOS 18+ |
| Rules-Based | Offline fallback, no consent | N/A | No AI, deterministic |

**API keys:** Stored in Supabase Vault. Never stored in app binary. Fetched at runtime via Edge Function — client never holds raw API keys in memory beyond request lifetime.

---

## 3. AI Coach Role and Behavior

### Coach Identity

The AI Coach is Oathen's central AI presence. It:

- Reviews the user's day and week
- Plans tomorrow's schedule
- Detects excuse patterns
- Confronts repeated failures
- Suggests goal adjustments
- Generates recovery plans
- Validates or challenges evidence
- Adapts tone to context mode
- Remembers user patterns across sessions

### Coach Tone (Behavioral Specification)

**IS:**
- Direct and clear
- Demanding but respectful
- Evidence-based
- Context-aware
- Honest about patterns
- Firm when the user makes excuses
- Genuinely trying to help the user improve

**IS NOT:**
- A cheerleader ("Great job! You're doing amazing!")
- Humiliating ("You're pathetic. You failed again.")
- Abusive or shaming
- A generic chatbot
- Medical ("Your heart rate suggests you may have a condition...")
- A yes-machine (does not validate weak excuses)

### Example Tone Calibration

| User Action | Weak Coach Response (wrong) | Oathen Coach Response (correct) |
|---|---|---|
| Skipped workout, reason: "too tired" | "That's okay! Rest is important!" | "You've been 'too tired' to work out 3 times this week. That's a pattern, not a reason." |
| Missed hydration goal | "Don't worry, try again tomorrow!" | "You hit 1.2L out of 3L. That's 40% of your goal. Let's identify where you're losing track." |
| Completed all tasks | "Amazing! You're crushing it!" | "Strong day. 7/7 tasks done. Your score reflects it. Maintain it tomorrow." |
| Failed Ultra Strict Mode | "It's okay to fail sometimes." | "You exited Ultra Strict Mode after 4 days. That will be logged. What changed?" |

---

## 4. AI Coach Memory System

### Why Memory Matters

Sending the user's entire history to the AI on every request is expensive and slow. Instead, the `AICoachMemory` entity stores structured key-value memories that represent what the Coach "knows" about the user.

### Memory Categories

| Type | Example Keys | Example Values |
|---|---|---|
| `preference` | `preferred_workout_time` | `"morning, 7-8am"` |
| `preference` | `coach_tone_preference` | `"strict, minimal praise"` |
| `pattern` | `workout_skip_pattern` | `"Skips Monday and Wednesday most often"` |
| `pattern` | `common_excuse` | `"'too tired' used 8 times in last 30 days"` |
| `goal` | `primary_goal` | `"Improve physical condition by September"` |
| `goal` | `current_priority` | `"DJHQ completion is critical this week"` |
| `excuse` | `excuses_detected` | `["too tired", "forgot", "too busy"]` |
| `context` | `travel_sensitivity` | `"Tour mode needed for gigs; prefers lighter goals"` |
| `risk` | `streak_break_risk` | `"Hydration streak at 12 days; historically breaks at ~14"` |

### Memory Injection

Each Coach request includes a `context` object with:

1. User's current memories (selected relevant subset by key)
2. Today's score, tasks, and completion summary (last 7 days)
3. Active context mode
4. Any critical or overdue items
5. The user's message

This avoids sending full conversation history every time, reducing token cost by ~60-80%.

### Memory Update Triggers

- After each Night Review (AI extracts new patterns)
- After weekly summary generation
- When user confirms or corrects an AI observation ("You're right, I do skip Monday workouts")
- When Coach detects a new repeated pattern (3+ occurrences of same excuse or skip)

---

## 5. Prompting Strategy

### System Prompt Structure

```
[Identity]
You are the AI Coach for Oathen (Discipline OS), a personal accountability operating system.
You help the user convert personal commitments into daily execution.

[Tone Rules]
Be direct, honest, and demanding. Do not give meaningless praise.
Confront repeated excuses with evidence. Never humiliate.
You are not a therapist, not a cheerleader, and not a chatbot.

[Medical Boundary]
Never diagnose, prescribe, or make clinical recommendations.
Use "non-diagnostic insight", "wellness signal", "consider consulting a healthcare professional."
Never mention medications or dosages.

[Context]
User: [name]
Active mode: [context mode]
Today's score: [score]
[Recent memory summary — structured, not full history]
[Today's tasks and completion state]
[Active goals and progress]
[Recent patterns if relevant]

[Conversation]
[Message history — last 5-10 turns only]
```

### Evidence Validation Prompt

```
You are validating evidence for a health and discipline app.
The user is trying to log: [evidence type — e.g., "500ml of water consumed"]
Review the photo and determine if it reasonably supports this claim.

Return:
- accepted: true/false
- confidence: 0.0-1.0
- reason: brief explanation
- suggestion: what to do if rejected

Do not diagnose. Do not make medical judgments.
Evidence types: hydration photo, completed workout selfie, completed task screenshot, etc.
```

---

## 6. AI Feature Map

| Feature | AI Role | Provider | Consent Required |
|---|---|---|---|
| Daily plan generation | Propose daily task order and priorities | OpenAI / Claude | Task data (default on) |
| Morning Check-in analysis | Interpret sleep/energy for capacity | OpenAI | Sleep/energy (default on) |
| Night Review analysis | Detect excuses, generate recovery plan | OpenAI / Claude | Score/task data (default on) |
| Weekly summary | Synthesize week, recommend adjustments | Claude | Full non-sensitive summary (default on) |
| Excuse detection | Identify repeated excuse patterns | OpenAI | Task/note data (default on) |
| Evidence validation | Validate photo evidence | Gemini / OpenAI Vision | Photos (explicit opt-in) |
| Goal adjustment | Suggest realistic changes to goals | Claude | Goal data (default on) |
| Context mode suggestion | Suggest mode change based on calendar | OpenAI | Calendar data (on if calendar enabled) |
| Travel detection | Detect travel from Gmail | OpenAI | Gmail access (opt-in) |
| Template generation | Generate a 7/14/30-day plan | Claude | Goal/task data (default on) |
| Coach nudge | In-context encouragement/challenge | OpenAI | Score/task (default on) |
| Trend alert | Flag unusual health metric | Rules-based first, AI if opted in | Health data (opt-in) |
| Recovery plan | Create comeback plan after failure | Claude | Score/task/goal data (default on) |

---

## 7. Cost Controls

### Per-Request Cost Management

- Every AI request generates a `CostEvent` with token counts and estimated USD cost.
- Cost is aggregated in `AIUsageLog` per user per period.
- A configurable quota (e.g., 500K tokens/month) triggers a warning and then a throttle.

### Cost Reduction Strategies

| Strategy | How |
|---|---|
| Memory injection instead of full history | Structured 5-10 memory keys instead of full conversation |
| Summarized context | Send score summary, not raw data dump |
| Model routing | Use cheaper models (GPT-4o mini, Haiku) for simple tasks |
| On-device for low-stakes insights | Rule-based offline fallback for simple patterns |
| Cache weekly summaries | Only regenerate once per week; cache result |
| Batch Coach nudges | Don't call AI for every minor event; batch and summarize |
| Streamed responses | Stream long outputs so user sees content faster; partial responses cancel early |
| Evidence validation only when required | Not every task requires evidence; only call vision API when evidence is mandatory |

### Estimated Cost per User (Personal MVP)

See `COST_MODEL.md` for detailed estimates.

---

## 8. Privacy Boundaries for AI

| Boundary | Rule |
|---|---|
| Medications | Never sent to any AI provider |
| Body photos | Only sent if `aiAnalysisConsented = true` on that photo |
| NightReview journal text | Only sent if user opts in per-category |
| AI Coach conversations | Never synced to cloud; never sent as context to new sessions (only memories are used) |
| Health metrics (BP, weight) | Only sent if user opts in per-category |
| Location | Only used for context mode suggestion with explicit consent |
| Full task details | Titles sent; private notes require opt-in |

### On-Device AI Preference

For any insight that can be computed locally:
1. Attempt on-device (Apple Intelligence or rule-based)
2. If insufficient, offer to send to cloud AI with consent reminder
3. Always tell user what will be sent

---

## 9. AI Offline and Fallback Behavior

| Scenario | AI Behavior |
|---|---|
| No internet connection | RulesBasedProvider handles all requests; Coach not available |
| AI provider returns error | Retry with exponential backoff (3 attempts); then fallback provider; then rules-based |
| User has not consented for category | Skip that data category; proceed with available context |
| Token quota exceeded | Throttle requests; notify user; suggest lower-frequency Coach interaction |
| Vision API rejects image | Mark evidence as "needs manual review"; user can submit with manual confirmation |
| All providers unavailable | Coach shows: "AI Coach is temporarily unavailable. Your data is safe." No data is lost. |

---

## 10. AI Safety and Quality Assurance

### Before Shipping Each Sprint with AI Features

- [ ] System prompt reviewed for medical boundary compliance
- [ ] All AI responses include a medical disclaimer flag where health data is discussed
- [ ] Evidence validation tested with edge cases (blurry photos, unrelated images)
- [ ] Cost event logging verified (no silent AI calls)
- [ ] Consent gate tested — blocked categories not sent
- [ ] Offline fallback tested — app does not crash or break when AI is unavailable
- [ ] Tone tested — no praise inflation, no abusive outputs

### Prohibited AI Outputs

Any AI output containing these must be blocked and logged:

- Diagnosis language: "you have", "you are suffering from", "this indicates a condition"
- Prescription: "you should take", "increase your dose", "stop taking"
- Humiliation: personal attacks, comparisons to others in negative framing
- False certainty: "definitely", "you will", "I guarantee" for health outcomes
- Medical claims: "clinically proven", "medically recommended"

Implementation: Content filter layer applied to all AI Coach outputs before displaying to user. Blocked outputs trigger fallback message and are logged for review.
