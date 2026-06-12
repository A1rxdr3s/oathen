# SECURITY_PRIVACY.md — Oathen / Discipline OS
## Security and Privacy Architecture

---

## 1. Privacy Philosophy

Oathen handles some of the most sensitive personal data a person generates:
- body progress photos
- health metrics (blood pressure, heart rate, weight)
- medications and clinical context
- sleep patterns
- daily journal and failure explanations
- location and travel context
- AI Coach conversations

The architecture must be designed so that **privacy is the default, not an option**.

**Core rules:**
1. Sensitive data lives locally by default.
2. No data is uploaded without explicit user consent.
3. No data is used by AI without per-category consent.
4. The user can see exactly what is synced and to where.
5. The user can export all data and delete all cloud data at any time.
6. Accountability partners see only what the user explicitly grants.

---

## 2. Data Classification

| Class | Definition | Examples | Default Storage |
|---|---|---|---|
| **Public** | Non-sensitive, safe to sync | Task titles, goal names, score values, streaks | Cloud sync auto |
| **Private** | User-generated, moderate sensitivity | Task notes, project descriptions, exercise logs, hydration logs | Local default, cloud opt-in |
| **Sensitive** | High personal sensitivity, requires user consent to share | Weekly review summaries, NightReview fields, health metrics, AI insights | Local only, explicit upload |
| **Critical** | Highest sensitivity, never auto-uploaded | Body progress photos, medication data, blood pressure, journal text, AI Coach conversations, body metrics | Local ONLY — never auto-synced |

---

## 3. Permission Architecture

### iOS System Permissions

| Permission | Purpose | Request Strategy | Denial Fallback |
|---|---|---|---|
| HealthKit (read) | Exercise, sleep, heart rate, hydration | At feature first-use, with explanation | Manual entry mode |
| HealthKit (write) | Log water, workouts | At feature first-use | Log locally only |
| Notifications | Escalation engine, reminders | Onboarding step, after onboarding | In-app banners only |
| Location (when in use) | Travel context detection | If user enables travel mode | Manual context setting |
| Camera | Evidence capture, body photos | At evidence capture point | No photo evidence; manual only |
| Photo Library | Import evidence, body photos | At evidence import point | Camera only |
| Calendar (EventKit) | Travel detection, routine sync | If user enables travel detection | Manual travel context |
| Reminders (EventKit) | Task-to-reminder sync (optional) | If user enables integration | No reminder sync |
| Face ID / Touch ID | App lock, sensitive area lock | Biometric settings screen | Passcode fallback |
| Screen Time (FamilyControls) | App distraction blocking | Sprint 11 feasibility validation | Focus Mode + reporting |

**Rule:** No permission is requested at app launch. Every permission is requested at the point of first use, preceded by an explanation screen describing why it is needed and what data will be accessed.

---

## 4. Encryption

### In Transit

- All network calls use **TLS 1.3**.
- Supabase connections: HTTPS enforced, no plain HTTP fallback.
- AI provider calls: HTTPS throughout.
- Certificate pinning: evaluated for Sprint 8 (Supabase SDK handles this).

### At Rest — Device

| Data Type | Encryption Level |
|---|---|
| General app data (SwiftData) | iOS standard file encryption (Data Protection) |
| Sensitive files (evidence photos, body photos) | `NSFileProtectionComplete` (encrypted when device locked) |
| Auth tokens | iOS Keychain, `kSecAttrAccessibleAfterFirstUnlock` |
| Biometric-gated secrets | Keychain with `kSecAccessControlBiometryCurrentSet` |
| Critical evidence (body photos) | Local encryption key + `NSFileProtectionComplete` |

### At Rest — Cloud

- Supabase enforces AES-256 encryption at rest for all database data and Storage objects.
- Supabase Vault used for AI API keys and sensitive Edge Function secrets.

---

## 5. Local-First Storage Policy

### Storage Decision Matrix

| Entity | Default | Opt-In Cloud Sync | Never Synced |
|---|---|---|---|
| Tasks, Goals, Habits, Projects | Local | ✓ (non-sensitive fields) | — |
| DisciplineScore, Streaks | Local | ✓ (aggregate values) | — |
| MorningCheckIn, NightReview | Local | — | ✓ (full content) |
| Exercise, Hydration, Sleep logs | Local | ✓ (aggregates) | — |
| HealthMetrics (weight, BP, HR) | Local | — | ✓ |
| Medications, MedicationLog | Local | — | ✓ |
| BodyProgressPhoto | Local | — | ✓ |
| BodyMetric | Local | — | ✓ |
| Evidence (non-body photos) | Local | ✓ (with consent) | — |
| AICoachMessage | Local | — | ✓ |
| AICoachMemory | Local | — | ✓ |
| Journal / failure text | Local | — | ✓ |
| AccountabilityPartner (policy) | Cloud | N/A | — |
| DisciplineScore (summary) | Cloud | N/A | — |
| Achievements | Cloud | N/A | — |

---

## 6. Biometric Protection

### Configuration Options

| Level | What It Protects | When to Use |
|---|---|---|
| Whole App | Entire Oathen app requires biometric/passcode | Maximum security |
| Sensitive Areas Only | Body photos, weight, health reports, medications, journal, AI Coach history | Balanced |
| Off | No biometric gate | Minimum friction |

**Default:** Sensitive Areas Only.

### Sensitive Areas Requiring Biometric Gate

- Body progress photo gallery
- Weight and body metrics screen
- Blood pressure and clinical health screen
- Medication management screen
- Night Review journal fields
- Weekly Review journal fields
- AI Coach full conversation history
- Evidence export
- Health report export
- Account deletion flow

**Implementation:** `LocalAuthentication` framework with `LAContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, ...)`.

---

## 7. AI Processing Consent

### Per-Category Consent Model

Before any data category is sent to an AI provider for processing, the user must explicitly consent. Consent is stored in `PrivacySetting.aiProcessingConsent` as a per-category flag.

| Data Category | AI Processing | Default Consent | Notes |
|---|---|---|---|
| Task and goal context | Allowed | ✓ (on by default) | Needed for basic Coach function |
| Exercise and activity data | Allowed | ✓ | Needed for fitness coaching |
| Hydration data | Allowed | ✓ | Needed for hydration coaching |
| Sleep data | Allowed | ✓ | Needed for sleep coaching |
| Score and streak data | Allowed | ✓ | Needed for performance review |
| Health metrics (weight, HR) | Allowed | ✗ (opt-in) | Sensitive health data |
| Blood pressure | Allowed | ✗ (opt-in) | Sensitive clinical data |
| Medications | Never | Always off | Safety and privacy — no medication data sent to AI |
| Body photos | Allowed | ✗ (explicit separate consent) | Highest sensitivity |
| Night Review journal text | Allowed | ✗ (opt-in) | Private journaling |
| AI Coach full history | On-device only | N/A | Never sent to cloud |

**Rule:** "Allowed with Opt-In" means the user sees an explicit consent dialog the first time the feature is used, not just a buried settings toggle.

---

## 8. Accountability Partner Permissions

See `DATA_MODEL.md` — PermissionPolicy entity for full field list.

### Default Visibility for Partner

| Data | Default | User Can Enable |
|---|---|---|
| Discipline Score trend | ✓ Visible | N/A |
| Streaks | ✓ Visible | N/A |
| On-track / at-risk status | ✓ Visible | N/A |
| Task count (completed/missed) | ✓ Visible | N/A |
| Exercise summary (minutes, days) | ✓ Visible | N/A |
| Hydration consistency | ✓ Visible | N/A |
| Achievements | ✗ Hidden | ✓ |
| Body photos | ✗ Hidden | ✓ (explicit) |
| Weight | ✗ Hidden | ✓ |
| Blood pressure | ✗ Hidden | ✓ |
| Medications | ✗ Hidden | ✗ Never |
| Location | ✗ Hidden | ✗ Never |
| Journal / failure text | ✗ Hidden | ✗ Never |
| AI Coach conversations | ✗ Hidden | ✗ Never |
| Clinical metrics | ✗ Hidden | ✗ Never |
| Failure reasons | ✗ Hidden | ✓ (aggregate only) |

---

## 9. Retention and Deletion Policies

### Evidence Photo Retention (Configurable)

| Setting | Behavior |
|---|---|
| No auto-delete | Photos kept until manually deleted |
| 30-day retention | Photos deleted after 30 days |
| 90-day retention | Photos deleted after 90 days |
| 1-year retention | Photos deleted after 1 year |
| Manual only | User must explicitly delete each photo |

Body progress photos: always manual deletion only. No auto-delete default.

### AI Data Retention

- AI Coach conversations: retained locally indefinitely (user can delete by session or all).
- AI Insights: expire per `expiresAt` field (default: 90 days for suggestions, indefinite for approved plans).
- CostEvent logs: retained for 1 year (billing audit).
- AIUsageLog: retained for 1 year.

### Account Deletion Flow

1. User requests account deletion in Settings > Privacy > Delete Account.
2. Confirmation dialog with explicit statement of what will be deleted.
3. Cloud data: all Supabase rows for the user's `userID` are hard-deleted (no soft delete for this operation).
4. Supabase Storage: all evidence photos, reports, and files for the user are deleted.
5. Local data: user is prompted to delete local device data. If confirmed, app deletes SwiftData store and file storage.
6. Auth: Supabase Auth account deleted.
7. Accountability partner: partner account is disassociated and receives notification.
8. Confirmation: user receives confirmation that all cloud data has been deleted.

---

## 10. Audit Log

The `AuditLog` entity records all significant data access and sharing events.

### Logged Events

| Event Type | Logged When |
|---|---|
| `dataAccess` | Sensitive data accessed within app (body photos, medications, health report) |
| `dataShare` | Any data shared with accountability partner |
| `aiProcessing` | Data category sent to AI provider |
| `partnerView` | Partner views shared dashboard |
| `export` | User exports data |
| `delete` | User deletes evidence, photos, or account |
| `sync` | Data synced to cloud (which entities, timestamp) |

### Audit Log Visibility

- User can view their own audit log in Settings > Privacy > Activity Log.
- Cloud audit events are stored in Supabase (sharing events only, not local-only events).
- Local audit events are stored locally and included in data export.

---

## 11. Data Export

Users can export all their data at any time.

### Export Format

- JSON file containing all local entities.
- Photo/evidence archive as ZIP.
- Health metrics as CSV.
- AI Coach conversation export as structured text.

### Export Gating

- Entire export process is biometric-gated.
- Export is logged in AuditLog.

---

## 12. Security Incident Response (Conceptual)

In case of a Supabase data breach or unauthorized access:

1. Supabase RLS ensures users can only access their own rows — a breach of one user's credentials does not expose others' data.
2. Sensitive data (body photos, medications, health metrics) is never stored in Supabase — breach impact is limited to non-sensitive data.
3. Users are notified via push notification and in-app message.
4. Auth tokens are revoked and users are required to re-authenticate.
5. Affected data categories are identified and disclosed to users.

---

## 13. Health and Safety Legal Boundaries

| Allowed | Not Allowed |
|---|---|
| "Your resting heart rate is outside your usual range. Consider re-measuring." | "Your heart rate indicates atrial fibrillation." |
| "You've missed your medication reminder 3 times this week." | "You should reduce your dosage." |
| "Your sleep average this week is 5.4 hours. This may affect your energy levels." | "You have a sleep disorder." |
| "Consider consulting a healthcare professional about this trend." | "Based on your data, you have condition X." |
| "Your blood pressure reading today is higher than your recent average." | "Your blood pressure indicates hypertension." |
| "This is not a medical device. This is a wellness insight." | Anything framed as a clinical diagnosis |

All health-related UI strings must be reviewed against this table before shipping.
