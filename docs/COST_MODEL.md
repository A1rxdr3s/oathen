# COST_MODEL.md — Oathen / Discipline OS
## Cost Model and Financial Architecture

> All estimates are based on publicly available pricing as of June 2026.
> Prices change. This model must be reviewed before any commercial launch.

---

## 1. Fixed Costs (One-Time or Annual)

| Item | Cost | Frequency |
|---|---|---|
| Apple Developer Program | $99 USD | Annual |
| Domain / brand | ~$15-30 USD | Annual |
| Design tools (Figma, etc.) | $0-150 USD | Monthly or annual |
| Xcode / development | Free (included with Mac) | — |

---

## 2. Supabase Costs

### Supabase Plan Tiers (Approximate)

| Plan | Monthly Cost | Limits |
|---|---|---|
| Free | $0 | 500MB DB, 1GB Storage, 50MB Edge Functions, 500K Edge Function invocations |
| Pro | $25/month | 8GB DB, 100GB Storage, unlimited invocations, daily backups |
| Team | $599/month | Higher limits, SLAs, advanced features |

### MVP Personal Use Estimate

At personal scale (1 user, Andrés):

| Resource | Usage Estimate | Cost |
|---|---|---|
| Database | <50MB | Free tier |
| Storage (evidence, synced only) | <500MB | Free tier |
| Edge Functions | ~300 invocations/day | Free tier |
| Auth | 1 user | Free tier |
| Realtime | Minimal | Free tier |
| **Total** | | **$0/month (Free tier)** |

### 100 Users Scale

| Resource | Usage Estimate | Cost |
|---|---|---|
| Database | ~5GB | Pro tier |
| Storage (opt-in evidence) | ~20GB | Pro tier |
| Edge Functions | ~30,000 invocations/day | Pro tier |
| Auth | 100 users | Included |
| Backups | Daily | Included in Pro |
| **Total** | | **~$25-50/month** |

### 1,000 Users Scale

| Resource | Usage Estimate | Cost |
|---|---|---|
| Database | ~50GB | Pro tier (upgrade) |
| Storage (opt-in evidence) | ~200GB | Pro → custom |
| Edge Functions | ~300,000 invocations/day | Pro → custom |
| Auth | 1,000 users | Included |
| **Total** | | **~$100-300/month** |

---

## 3. AI Costs

### Pricing Assumptions (June 2026, approximate)

| Provider | Model | Input (per 1M tokens) | Output (per 1M tokens) |
|---|---|---|---|
| OpenAI | GPT-4o | $2.50 | $10.00 |
| OpenAI | GPT-4o mini | $0.15 | $0.60 |
| Anthropic | claude-sonnet-4-6 | $3.00 | $15.00 |
| Anthropic | claude-haiku-4-5 | $0.80 | $4.00 |
| Google | gemini-2.0-flash | $0.075 | $0.30 |
| Google | gemini-2.0-flash (vision) | $0.075 | $0.30 |

### Per-Feature Token Estimate

| Feature | Frequency | Est. Tokens/Call | Model | Est. Cost/Call |
|---|---|---|---|---|
| Morning Check-in analysis | 1/day | 1,500 in + 300 out | GPT-4o mini | $0.0004 |
| Night Review analysis | 1/day | 2,000 in + 500 out | GPT-4o mini | $0.0006 |
| Weekly summary | 1/week | 5,000 in + 1,000 out | claude-haiku-4-5 | $0.008 |
| Coach message (avg) | 5/day | 3,000 in + 500 out | GPT-4o | $0.013 |
| Daily plan generation | 1/day | 2,500 in + 800 out | GPT-4o mini | $0.0009 |
| Evidence validation (photo) | 3/day | 500 in + 200 out | gemini-flash | $0.00006 |
| Excuse detection | 1/day | 1,000 in + 200 out | GPT-4o mini | $0.0002 |
| Recovery plan | 2/week | 3,000 in + 1,000 out | claude-haiku-4-5 | $0.007 |

### Personal Use AI Cost Estimate (1 User — Andrés)

Assumptions:
- 5 Coach messages/day
- 1 Morning + 1 Night analysis/day
- 1 Daily plan/day
- 1 Weekly summary
- 3 Evidence validations/day
- Occasional recovery plans and goal suggestions

| Feature | Monthly Calls | Est. Monthly Cost |
|---|---|---|
| Coach messages | 150 | $1.95 |
| Morning Check-in | 30 | $0.012 |
| Night Review | 30 | $0.018 |
| Daily plan | 30 | $0.027 |
| Weekly summary | 4 | $0.032 |
| Evidence validation | 90 | $0.005 |
| Excuse detection | 30 | $0.006 |
| Recovery plans | 8 | $0.056 |
| **Total personal** | | **~$2-4/month** |

### 100 Users Scale AI Cost

Assuming same usage pattern per user, with caching and cost optimization:

| Optimization | Savings |
|---|---|
| Cached weekly summaries | -25% on summaries |
| Memory injection (vs full history) | -60% on Coach messages |
| GPT-4o mini for simple tasks | -70% vs GPT-4o |
| Shared context compression | -20% overall |

Optimized cost per user: ~$1.50-2.50/month
100 users: ~$150-250/month AI cost

### 1,000 Users Scale AI Cost

Optimized cost per user: ~$1.00-2.00/month (bulk usage patterns, more caching)
1,000 users: ~$1,000-2,000/month AI cost

### Revenue Target to Cover AI at 1,000 Users

At $1,500/month AI cost + $200/month Supabase + $100/month infrastructure:
Monthly cost: ~$1,800/month
At $9.99/month subscription: need ~180 paid subscribers to cover AI+infra at 1,000 users
**Break-even: ~18% paid conversion at 1,000 users.**

---

## 4. Storage Costs

### Assumptions

- Most sensitive evidence (body photos, health metrics) is local-only.
- Cloud storage is opt-in for non-sensitive evidence photos.
- Average evidence photo: ~500KB after compression.
- Average user uploads ~5 evidence photos/day (opt-in, so real number will be lower).

### Storage per User/Month

| Data Type | Monthly Volume | Size | Notes |
|---|---|---|---|
| Evidence photos (opt-in, 5/day) | 150 photos | ~75MB | Only opt-in users |
| Audio (none planned) | — | — | Not in MVP |
| Health reports (exported) | <1/month | <1MB | PDF export |
| Sync data (non-sensitive) | — | Negligible (text/JSON) | In database |
| **Total per opt-in user** | | **~75MB/month** | ~900MB/year |

### Supabase Storage Pricing

Supabase Pro includes 100GB. Additional storage is ~$0.021/GB.

| Scale | Opt-In Users | Storage Used | Storage Cost |
|---|---|---|---|
| 1 user | 1 | 0.9 GB/year | Free tier |
| 100 users (50% opt-in) | 50 | ~45 GB/year | Included in Pro |
| 1,000 users (30% opt-in) | 300 | ~270 GB/year | ~$3.50/month overage |

---

## 5. Infrastructure Costs

| Service | Personal | 100 Users | 1,000 Users |
|---|---|---|---|
| Supabase | $0 (free) | $25/month | $100-300/month |
| AI (OpenAI/Claude/Gemini) | $2-4/month | $150-250/month | $1,000-2,000/month |
| Storage (included in Supabase) | $0 | $0 | $3-10/month |
| Push notifications (APNs) | $0 (Apple free) | $0 | $0 |
| App Store distribution | $0 (in Developer Program) | $0 | $0 |
| **Total** | **$2-4/month** | **$175-275/month** | **$1,100-2,300/month** |

---

## 6. Cost Risks

| Risk | Severity | Mitigation |
|---|---|---|
| AI cost spike from heavy Coach usage | High | Per-user monthly AI token quota; throttling above quota |
| Vision API cost for evidence spam | Medium | Limit evidence validation to required tasks only; rate limit |
| Storage growth if opt-in is popular | Medium | Retention policies; user-controlled deletion; compression |
| Supabase pricing changes | Low | Architecture abstracts backend; migration feasible |
| Provider rate limits at scale | Medium | Retry logic + fallback provider |
| Token inflation from long conversations | Medium | Context window management; memory injection vs full history |
| AI provider outage affecting core feature | Medium | Fallback to rules-based; offline notice |

---

## 7. Cost Control Strategy

### Technical Strategies

1. **Memory injection** — Structured memory summaries instead of full conversation history. ~60% token reduction for Coach sessions.
2. **Model routing** — Use GPT-4o mini or Haiku for simple tasks. Reserve GPT-4o / Sonnet for complex analysis.
3. **Caching** — Cache weekly summaries, goal suggestions, and template outputs. Regenerate weekly, not daily.
4. **On-device AI** — Use Apple Intelligence for privacy-sensitive local insights when available. Zero AI cost.
5. **Evidence validation gating** — Only call vision AI when evidence is mandatory for a task. Not all tasks require evidence.
6. **Batch analysis** — Group daily events for single Night Review analysis call instead of multiple incremental calls.
7. **Context compression** — Summarize task history rather than sending raw lists.

### Product Strategies

8. **User quotas** — SaaS pricing tiers include AI quota (e.g., Free: 100 Coach messages/month, Pro: unlimited).
9. **Evidence compression** — Compress photos before sending to vision AI. Reduces image token cost.
10. **Local-first for low-stakes insights** — Rule-based score calculation, streak updates, and simple pattern detection don't need AI.
11. **Opt-in AI features** — Evidence validation, body photo analysis, and Gmail-based travel detection are opt-in. Reduces API calls for users who don't need them.

---

## 8. Commercial Pricing Model (Future)

Not implemented in MVP. For planning only.

| Tier | Price | Includes |
|---|---|---|
| Free | $0/month | Core habits, tasks, basic score, 50 Coach messages/month |
| Personal Pro | $9.99/month | Unlimited Coach, evidence validation, AI planning, Ultra Strict, advanced analytics |
| Ultra | $19.99/month | Priority AI models, accountability partner, premium support, export |

**Target gross margin at Pro tier (1,000 users):**
- Revenue: $9,990/month (1,000 × $9.99)
- AI + infra cost: $1,800-2,300/month
- Gross margin: ~77%
