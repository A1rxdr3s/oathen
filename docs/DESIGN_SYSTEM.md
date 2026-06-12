# DESIGN_SYSTEM.md — Oathen / Discipline OS
## Design Language Reference

---

## 1. Visual Identity

### References (not copies)

| App | What to learn from it |
|---|---|
| Apple Fitness+ | Premium health metrics, dark mode ring progress, bold numbers |
| Apple Health | Data-dense but clean hierarchy, trusted medical/wellness feel |
| Things 3 | Task hierarchy elegance, calm but structured, native macOS feel |
| Linear | Bold typography, tight spacing, strict visual priority, productivity-grade |
| Whoop / Athlytic | Strain/recovery metrics, serious wearable data display |
| Raycast / Cron | Command-center mental model, keyboard-first on Mac, premium productivity |

### What Oathen must NOT look like

- Duolingo streaks and celebration animations
- Cheap gamified habit apps (bright colors, cartoon mascots)
- Generic SaaS dashboards (rounded grey cards, stock icons)
- Fitness bro apps (excessive gradients, aggressive muscle imagery)
- Overly therapeutic apps (soft pastels, excessive encouragement)

---

## Sprint 1 — Implemented Token Names (Swift)

> These tokens are **placeholder values only** — not final brand decisions. Implemented in Sprint 1 as Swift constants. Token names are binding for Sprint 2+.

### `OathenColors` (static `Color` values)

| Swift name | Role | Notes |
|---|---|---|
| `.accent` | Brand/discipline accent | `#4F46E5` approx — not final |
| `.critical` | Critical priority, overdue | `Color.red` |
| `.high` | High priority | `Color.orange` |
| `.normal` | Normal priority | `Color.blue` |
| `.low` | Low priority | `Color.secondary` |
| `.success` | Completed | `Color.green` |
| `.warning` | Risk / AI alert | `Color.yellow` |
| `.exercise` | Exercise health pillar | `Color.green` |
| `.hydration` | Hydration health pillar | `#38BDF8` |
| `.sleep` | Sleep health pillar | `#6366F1` |
| `.scoreHigh` | Score 80-100 | `Color.green` |
| `.scoreMid` | Score 50-79 | `Color.orange` |
| `.scoreLow` | Score 0-49 | `Color.red` |
| `.cardBackground` | Card/panel surface | Adaptive: `UIColor.secondarySystemBackground` / `NSColor.controlBackgroundColor` |
| `.screenBackground` | Main screen background | Adaptive: `UIColor.systemBackground` / `NSColor.windowBackgroundColor` |
| `.tertiaryFill` | Tertiary fill | Adaptive: `UIColor.tertiarySystemFill` / `NSColor.quaternaryLabelColor` |

### `OathenTypography` (static `Font` values)

| Swift name | Usage | Size / Weight / Design |
|---|---|---|
| `.scoreDisplay` | Discipline Score number | 72pt / Bold / Rounded |
| `.metricDisplay` | Large metric numbers | 48pt / Bold / Rounded |
| `.screenTitle` | Screen hero title | 34pt / Bold / Default |
| `.headingLarge` | Section heading | 22pt / Semibold / Default |
| `.headingMedium` | Card title | 17pt / Semibold / Default |
| `.headingSmall` | List item title | 15pt / Medium / Default |
| `.bodyLarge` | Main body | 17pt / Regular / Default |
| `.bodyMedium` | Supporting body | 15pt / Regular / Default |
| `.bodySmall` | Caption, metadata | 13pt / Regular / Default |
| `.priorityLabel` | Priority badge | 11pt / Bold / Default |
| `.tagLabel` | Tags, chips | 11pt / Medium / Default |
| `.monoData` | Raw metrics | 13pt / Regular / Monospaced |

### `OathenSpacing` (static `CGFloat` values, 8pt grid)

| Swift name | Value | Role |
|---|---|---|
| `.xs` | 4 | Micro gap |
| `.sm` | 8 | Small gap |
| `.md` | 12 | Medium gap |
| `.lg` | 16 | Large gap / standard padding |
| `.xl` | 20 | Extra large |
| `.xxl` | 24 | Section gap |
| `.xxxl` | 32 | Large section gap |
| `.huge` | 40 | Hero spacing |
| `.screenHorizontal` | 16 | Screen edge padding |
| `.cardH` | 16 | Card horizontal padding |
| `.cardV` | 12 | Card vertical padding |
| `.sectionGap` | 24 | Between major sections |
| `.tabContentTop` | 8 | Top padding inside tab scroll |

### `OathenRadius` (static `CGFloat` values)

| Swift name | Value |
|---|---|
| `.sm` | 8 |
| `.md` | 12 |
| `.lg` | 16 |
| `.xl` | 20 |
| `.pill` | 100 |

### `OathenComponents` (Sprint 1 shared views)

| Component | Usage |
|---|---|
| `OathenCard<Content>` | Standard card container with adaptive background |
| `PriorityBadge(priority:)` | Capsule priority label (`.critical`/`.high`/`.normal`/`.low`/`.blocked`) |
| `OathenProgressBar(value:color:label:)` | Labeled progress bar (GeometryReader-based) |
| `OathenSectionHeader(title:)` | Uppercase tracking section label |
| `PlaceholderTag` | Small "PLACEHOLDER" badge for Sprint 1 UI |
| `ScoreRing(progress:score:size:)` | Circular score ring (scaleable) |
| `View.largeNavigationTitle()` | iOS-only `.navigationBarTitleDisplayMode(.large)` extension |

---

## 2. Design Principles

1. **Serious over cheerful.** Data and evidence dominate. Celebrations exist but are restrained.
2. **Typography does the work.** Big numbers, strong hierarchy, minimal icons as decoration.
3. **Dark mode first.** Most productive use is evening/night review. Dark mode is primary, light mode is secondary.
4. **Apple HIG compliance.** Native controls, native behaviors, native feel. No reinventing standard patterns.
5. **Content over chrome.** Minimal UI decoration; the user's data is the interface.
6. **Density with clarity.** Mac can show more. iPhone prioritizes what matters now.
7. **Red is serious.** Red means overdue, critical, or failure. Not playful.
8. **Score is central.** The Discipline Score should always be findable within one tap.

---

## 3. Color System

### Semantic Colors (Dark Mode Primary)

| Token | Role | Approximate Value |
|---|---|---|
| `background.primary` | Main screen background | System Black / #000000 |
| `background.secondary` | Card / panel surface | System Dark Gray / #1C1C1E |
| `background.tertiary` | Nested card / input | #2C2C2E |
| `text.primary` | Main readable text | White / #FFFFFF |
| `text.secondary` | Supporting text | #EBEBF5 at 60% |
| `text.tertiary` | Placeholder, caption | #EBEBF5 at 30% |
| `accent.primary` | Interactive actions, links | System Blue |
| `accent.discipline` | Discipline Score, brand | Deep Blue-Indigo (#4F46E5 range) |
| `status.critical` | Critical priority, overdue | System Red |
| `status.high` | High priority | System Orange |
| `status.normal` | Normal priority | System Blue |
| `status.low` | Low priority | System Gray |
| `status.blocked` | Blocked state | System Yellow |
| `status.success` | Completed, done | System Green |
| `status.warning` | Risk flag, AI alert | System Yellow |
| `ultraStrict.active` | Ultra Strict Mode indicator | Deep Red / #DC2626 |
| `health.exercise` | Exercise metrics | Active Green |
| `health.hydration` | Hydration metrics | Light Blue / #38BDF8 |
| `health.sleep` | Sleep metrics | Indigo / #6366F1 |
| `score.high` | Score 80-100 | Green |
| `score.medium` | Score 50-79 | Orange |
| `score.low` | Score 0-49 | Red |

### Light Mode Adaptation

All tokens have light-mode equivalents via semantic color system. Light mode does not change the color meaning — only the surface values adapt. Use `Color(uiColor: .label)`, `Color(uiColor: .systemBackground)` and semantic colors to support both modes automatically.

---

## 4. Typography

### Type Scale

| Token | Usage | Apple Font | Weight | Size |
|---|---|---|---|---|
| `display.score` | Discipline Score number | SF Pro Rounded | Bold | 72pt |
| `display.metric` | Large metric numbers | SF Pro Rounded | Bold | 48pt |
| `display.title` | Screen hero title | SF Pro Display | Bold | 34pt |
| `heading.large` | Section heading | SF Pro Text | Semibold | 22pt |
| `heading.medium` | Card title | SF Pro Text | Semibold | 17pt |
| `heading.small` | List item title | SF Pro Text | Medium | 15pt |
| `body.large` | Main readable body | SF Pro Text | Regular | 17pt |
| `body.medium` | Supporting body | SF Pro Text | Regular | 15pt |
| `body.small` | Caption, metadata | SF Pro Text | Regular | 13pt |
| `label.priority` | Priority badge | SF Pro Text | Bold | 11pt |
| `label.tag` | Tags, chips | SF Pro Text | Medium | 11pt |
| `monospace.data` | Raw metrics, scores | SF Mono | Regular | 13pt |

### Typography Rules

- Use **SF Pro Rounded** for numbers that represent achievements or scores — it feels more personal.
- Use **SF Pro Display** for large titles.
- Use **SF Pro Text** for body content.
- Never use custom fonts in MVP — match Apple system conventions.
- Dynamic Type must be supported. Use `.body`, `.headline`, `.caption` semantic sizes.

---

## 5. Spacing System

Based on an 8pt grid.

| Token | Value |
|---|---|
| `space.1` | 4pt |
| `space.2` | 8pt |
| `space.3` | 12pt |
| `space.4` | 16pt |
| `space.5` | 20pt |
| `space.6` | 24pt |
| `space.8` | 32pt |
| `space.10` | 40pt |
| `space.12` | 48pt |

Standard card padding: `space.4` (16pt) horizontal, `space.3` (12pt) vertical.
Screen horizontal margins: 16pt on iPhone, 20pt on Mac list panels.

---

## 6. Component Library

### Score Ring Component

```
Large circular ring (like Apple Fitness rings)
Center: Large bold score number (72pt, SF Rounded)
Ring: Stroke width ~8pt, colored by score range
Surrounding: small "Discipline Score" label
State variations:
  - Active (today)
  - Historical (past day, dimmed)
  - Incomplete (dashed ring)
  - Ultra Strict (deeper color accent)
```

### Priority Badge

```
Inline badge attached to task/habit row
Shape: Capsule / rounded rect
Colors:
  Critical → Red background, white text
  High → Orange background, white text
  Normal → Blue tint, white text
  Low → Gray background, secondary text
  Blocked → Yellow background, primary text
Size: 11pt bold text, 4pt vertical padding, 8pt horizontal
```

### Task Row

```
[○ or ✓] [Title]                    [Priority Badge] [Time]
          [Subtitle / project name]                   [Duration]
```

Tap expands to Task Detail.
Swipe right → Quick complete.
Swipe left → Postpone / options.

### Evidence Badge

```
On task row: small camera icon or photo thumbnail
States:
  - Required but not submitted (orange outline)
  - Submitted, pending validation (gray)
  - Validated (green check)
  - Rejected (red X)
```

### Progress Bar (Hydration, Exercise)

```
Full-width bar
Background: tertiary surface
Fill: semantic health color
Text overlay: "2.25L / 3L" or "32 / 45 min"
Milestone markers (e.g., 50%, 75%) as subtle ticks
```

### Coach Message Bubble

```
Left-aligned bubble (Coach speaks left, like a real coach)
Coach: Deep indigo/blue bubble, white text
User: Surface secondary, secondary text
Timestamp: caption below
No avatar — just a horizontal capsule indicator "Coach" label
```

### Escalation Alert (In-App)

```
Persistent banner (non-dismissible in Ultra Strict Mode)
Background: status.critical
Title: Bold, white
Body: Smaller, white
Actions: [Done] [Postpone] (Postpone disabled after quota in Ultra Strict)
```

### Check-in Card

```
Sectioned card with steps
Each step: checkbox left, content right
Progress: subtle step counter at top
[Next Step →] button at bottom
Completion: quiet celebration — no confetti, firm acknowledgment
```

### Streak Counter

```
Number + "day streak" label
Color: accent.discipline (indigo)
Broken: Red crossed number — serious, no softening
```

---

## 7. Iconography

- Use **SF Symbols** throughout. No custom icon sets in MVP.
- Use filled variants for active/selected states, outlined for inactive.
- Priority-related symbols: `exclamationmark.circle.fill` (critical), `arrow.up.circle.fill` (high).
- Health symbols: `figure.run`, `drop.fill`, `moon.fill`, `heart.fill`.
- Navigation: system standard chevrons, tab icons.
- Evidence: `camera.fill`, `checkmark.seal.fill`.
- Score: `gauge.medium`, `chart.line.uptrend.xyaxis`.

---

## 8. Motion and Animation

- **No excessive animation.** Oathen is a discipline tool, not entertainment.
- Use system-standard transitions: `.slide`, `.opacity`, `.push`.
- Score number updates: smooth count-up animation (0.6s ease-out) — meaningful, not playful.
- Task completion: brief checkmark animation, row gently slides/fades — no fireworks.
- Achievement unlock: restrained reveal — fade in + subtle scale. One haptic `UIImpactFeedbackGenerator.notificationOccurred(.success)`. No confetti.
- Ultra Strict activation: firm, purposeful reveal with a brief shake haptic.

---

## 9. States Reference

| State | Visual Treatment |
|---|---|
| Empty | Centered icon (SF Symbol), short serious message, optional CTA |
| Loading | System `ProgressView` spinner — no custom loaders in MVP |
| Error | Red tint banner, error message, retry action |
| Offline | Subtle banner: "Offline — data saved locally" |
| Overdue | Red priority badge, `⚠` indicator, Live Activity on lock screen |
| Ultra Strict Active | Persistent top badge, deeper red accents, reduced dismiss options |
| Success (task done) | Green checkmark, row greyed out and pushed down |
| Score declining | Orange/red score, AI Coach nudge below |
| Streak broken | Red counter, no softening, recovery message from Coach |
| Evidence required | Camera icon badge on task row |
| Evidence rejected | Red `✗` badge, prompt to retake |
| Context mode active | Persistent mode badge on Today screen |
| Biometric locked | Lock screen overlay, `Touch ID / Face ID` unlock prompt |

---

## 10. iPhone Design Rules

- Safe area: always respect top and bottom safe areas.
- Minimum tap target: 44×44pt.
- Tab bar: 5 items max, never overflow to "More".
- Sheet presentations: use `.sheet` and `.fullScreenCover` per Apple HIG.
- Destructive actions: always require confirmation.
- Never use red buttons as primary actions — red is for destructive only.
- No center-aligned body text — left-aligned throughout.

---

## 11. Apple Watch Design Rules

- One goal per screen — Watch cannot support complex layouts.
- Large text, minimal detail — readable on wrist during activity.
- Action buttons: at most 2 per screen.
- Complications: use `.accessoryCircular`, `.accessoryRectangular`, `.accessoryCorner`.
- Haptics: use sparingly, only for important alerts.
- Navigation: Digital Crown for scrolling lists; swipe for dismiss.

---

## 12. Mac Design Rules

- Three-column layout (`NavigationSplitView`) for main app structure.
- Mac is the strategic planning center — dense information display is appropriate.
- Keyboard navigation must work throughout.
- Toolbar buttons for primary Mac actions.
- Context menus on right-click throughout.
- No bottom tab bar — sidebar navigation only.
- Menu bar item: optional in MVP (consider post-Sprint 10).

---

## 13. Apple HIG Alignment

| HIG Principle | Oathen Rule |
|---|---|
| People over apps | User's goals are always primary — the UI serves the data |
| Clarity | Typography hierarchy always clear; no ambiguous icons |
| Deference | UI defers to content — minimal decoration |
| Native controls | Use system controls throughout; no custom pickers in MVP |
| Accessibility | VoiceOver labels on all elements; Dynamic Type support required |
| Privacy indicators | Honor system privacy indicators; never circumvent |
| Permissions | Request at point of use; explain why before requesting |

---

## 14. Dark Mode Reference

Dark mode is the primary mode. All design decisions start from dark.

| Dark Mode | Light Mode Adaptation |
|---|---|
| Black backgrounds | White / system background |
| White text | Black / label text |
| Indigo accents | Same — works in both |
| Red overdue states | Same — works in both |
| Dimmed secondary cards | Grouped background |

Light mode should feel equally serious — not softer or more playful. The tone doesn't change with the appearance mode.
