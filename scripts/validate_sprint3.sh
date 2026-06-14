#!/usr/bin/env bash
# validate_sprint3.sh — Oathen Sprint 3 Validation
# Validates: Sprint 2 baseline, new domain models, forbidden patterns, builds, tests.
# Output: validation/sprint3_validation_report.md
# Run from repository root: bash scripts/validate_sprint3.sh
set -euo pipefail

# ──────────────────────────────────────────────────────────────────────────────
# Paths
# ──────────────────────────────────────────────────────────────────────────────
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_DIR="$REPO_ROOT/validation"
LOG_DIR="$REPORT_DIR/logs"
REPORT="$REPORT_DIR/sprint3_validation_report.md"
mkdir -p "$REPORT_DIR" "$LOG_DIR"

# ──────────────────────────────────────────────────────────────────────────────
# Counters
# ──────────────────────────────────────────────────────────────────────────────
PASS=0
FAIL=0
WARN=0

pass() { echo "  ✅ $1"; PASS=$((PASS + 1)); }
fail() { echo "  ❌ $1"; FAIL=$((FAIL + 1)); }
warn() { echo "  ⚠️  $1"; WARN=$((WARN + 1)); }
section() { echo ""; echo "## $1"; }

# ──────────────────────────────────────────────────────────────────────────────
# Goal 1 — Repository root check
# ──────────────────────────────────────────────────────────────────────────────
section "Goal 1: Repository Root"
if [[ -f "$REPO_ROOT/project.yml" && -d "$REPO_ROOT/Oathen" ]]; then
    pass "Running from repository root: $REPO_ROOT"
else
    fail "Not at repository root — run from the oathen/ directory"
    exit 1
fi

# ──────────────────────────────────────────────────────────────────────────────
# Goal 2 — Sprint 2 baseline
# ──────────────────────────────────────────────────────────────────────────────
section "Goal 2: Sprint 2 Baseline"
if bash "$REPO_ROOT/scripts/validate_sprint2.sh" > "$LOG_DIR/sprint2_baseline.log" 2>&1; then
    pass "validate_sprint2.sh passed (Sprint 2 baseline clean)"
else
    fail "validate_sprint2.sh FAILED — Sprint 2 baseline is broken"
fi

# ──────────────────────────────────────────────────────────────────────────────
# Goal 3 — Sprint 3 source files exist
# ──────────────────────────────────────────────────────────────────────────────
section "Goal 3: Sprint 3 Source Files"

# Domain models
check_file() {
    local label="$1"; local path="$2"
    if [[ -f "$REPO_ROOT/$path" ]]; then pass "$label"; else fail "$label — not found: $path"; fi
}

check_file "MorningCheckIn.swift"         "Oathen/Core/Domain/Models/MorningCheckIn.swift"
check_file "NightReview.swift"            "Oathen/Core/Domain/Models/NightReview.swift"
check_file "DailyPlanItem.swift"          "Oathen/Core/Domain/Models/DailyPlanItem.swift"
check_file "DailyPlan.swift"              "Oathen/Core/Domain/Models/DailyPlan.swift"
check_file "TodayState.swift"             "Oathen/Core/Domain/Models/TodayState.swift"
check_file "DailyRoutinePolicy.swift"     "Oathen/Core/Domain/Policies/DailyRoutinePolicy.swift"
check_file "TodayViewModel.swift"         "Oathen/Features/Today/TodayViewModel.swift"
check_file "DisciplineScoreCard.swift"    "Oathen/Features/Today/Components/DisciplineScoreCard.swift"
check_file "MorningCheckInCard.swift"     "Oathen/Features/Today/Components/MorningCheckInCard.swift"
check_file "DailyPlanCard.swift"          "Oathen/Features/Today/Components/DailyPlanCard.swift"
check_file "HealthPillarsCard.swift"      "Oathen/Features/Today/Components/HealthPillarsCard.swift"
check_file "NightReviewCard.swift"        "Oathen/Features/Today/Components/NightReviewCard.swift"
check_file "TodayProgressCard.swift"      "Oathen/Features/Today/Components/TodayProgressCard.swift"
check_file "MorningCheckInView.swift"     "Oathen/Features/DailyRoutine/MorningCheckInView.swift"
check_file "NightReviewView.swift"        "Oathen/Features/DailyRoutine/NightReviewView.swift"
check_file "DailyPlanView.swift"          "Oathen/Features/DailyRoutine/DailyPlanView.swift"
check_file "DailyRoutineTests.swift"      "OathenTests/DailyRoutineTests.swift"
check_file "DailyRoutineCodableTests.swift" "OathenTests/DailyRoutineCodableTests.swift"

# ──────────────────────────────────────────────────────────────────────────────
# Goal 4 — Domain model conformances
# ──────────────────────────────────────────────────────────────────────────────
section "Goal 4: Domain Model Conformances"

DOMAIN="$REPO_ROOT/Oathen/Core/Domain"
SPRINT3_MODELS="$DOMAIN/Models/MorningCheckIn.swift $DOMAIN/Models/NightReview.swift $DOMAIN/Models/DailyPlanItem.swift $DOMAIN/Models/DailyPlan.swift $DOMAIN/Models/TodayState.swift"

for f in $SPRINT3_MODELS; do
    name=$(basename "$f")
    if grep -q "Codable" "$f" && grep -q "Equatable" "$f" && grep -q "Sendable" "$f"; then
        pass "$name: Codable + Equatable + Sendable"
    else
        fail "$name: missing required conformances"
    fi
done

# No @Model in domain
if ! grep -rq "@Model" "$DOMAIN/"; then
    pass "No @Model in domain layer"
else
    fail "@Model found in domain layer — forbidden"
fi

# No SwiftUI imports in domain
if ! grep -rq "^import SwiftUI" "$DOMAIN/"; then
    pass "No SwiftUI imports in domain layer"
else
    fail "SwiftUI imported in domain layer — forbidden"
fi

# No bare struct Task: (OathenTask naming rule)
if ! grep -rq "^struct Task:" "$DOMAIN/"; then
    pass "No bare 'struct Task:' — OathenTask naming preserved"
else
    fail "Found 'struct Task:' — must use OathenTask"
fi

# Foundation imported in Sprint 3 models
for f in $SPRINT3_MODELS; do
    name=$(basename "$f")
    if grep -q "^import Foundation" "$f"; then
        pass "$name: imports Foundation"
    else
        fail "$name: missing Foundation import"
    fi
done

# ──────────────────────────────────────────────────────────────────────────────
# Goal 5 — DailyRoutinePolicy helpers
# ──────────────────────────────────────────────────────────────────────────────
section "Goal 5: DailyRoutinePolicy Helpers"
POLICY="$DOMAIN/Policies/DailyRoutinePolicy.swift"

check_policy_fn() {
    local fn="$1"
    if grep -q "$fn" "$POLICY"; then pass "DailyRoutinePolicy.$fn exists"; else fail "DailyRoutinePolicy.$fn missing"; fi
}

check_policy_fn "defaultDailyPlan"
check_policy_fn "defaultMorningCheckIn"
check_policy_fn "nightReview"
check_policy_fn "progressFraction"
check_policy_fn "recoveryRecommendation"
check_policy_fn "coachNudge"
check_policy_fn "calculateScore"
check_policy_fn "defaultTodayState"
check_policy_fn "isMorningCheckInComplete"
check_policy_fn "isNightReviewComplete"

# ──────────────────────────────────────────────────────────────────────────────
# Goal 6 — TodayViewModel
# ──────────────────────────────────────────────────────────────────────────────
section "Goal 6: TodayViewModel"
VIEWMODEL="$REPO_ROOT/Oathen/Features/Today/TodayViewModel.swift"

if grep -q "@Observable" "$VIEWMODEL"; then
    pass "TodayViewModel is @Observable"
else
    fail "TodayViewModel missing @Observable"
fi
if grep -q "@MainActor" "$VIEWMODEL"; then
    pass "TodayViewModel is @MainActor"
else
    fail "TodayViewModel missing @MainActor"
fi
if grep -q "completeMorningCheckIn" "$VIEWMODEL"; then
    pass "completeMorningCheckIn function present"
else
    fail "completeMorningCheckIn missing"
fi
if grep -q "toggleItem" "$VIEWMODEL"; then
    pass "toggleItem function present"
else
    fail "toggleItem missing"
fi
if grep -q "completeNightReview" "$VIEWMODEL"; then
    pass "completeNightReview function present"
else
    fail "completeNightReview missing"
fi

# ──────────────────────────────────────────────────────────────────────────────
# Goal 7 — Forbidden implementation areas (cumulative from Sprint 2)
# ──────────────────────────────────────────────────────────────────────────────
section "Goal 7: Forbidden Implementations"
ALL_SWIFT="$REPO_ROOT/Oathen $REPO_ROOT/OathenTests"

forbidden_absent() {
    local label="$1"; local pattern="$2"
    if ! grep -rq "$pattern" $ALL_SWIFT 2>/dev/null; then
        pass "No $label found"
    else
        fail "$label found — forbidden in Sprint 3"
    fi
}

forbidden_absent "@Model"                      "@Model"
forbidden_absent "ModelContainer"              "ModelContainer"
forbidden_absent "SwiftData"                   "import SwiftData"
forbidden_absent "Core Data (NSManagedObject)" "NSManagedObject"
forbidden_absent "Supabase"                    "import Supabase"
forbidden_absent "HealthKit"                   "import HealthKit"
forbidden_absent "OpenAI API"                  "openai.com/v1"
forbidden_absent "Anthropic API"               "api.anthropic.com"
forbidden_absent "Gemini API"                  "generativelanguage.googleapis.com"
forbidden_absent "UserNotifications"           "import UserNotifications"
forbidden_absent "WidgetKit"                   "import WidgetKit"
forbidden_absent "ActivityKit"                 "import ActivityKit"
forbidden_absent "WatchConnectivity"           "import WatchConnectivity"
forbidden_absent "DeviceActivity"              "import DeviceActivity"
forbidden_absent "FamilyControls"              "import FamilyControls"
forbidden_absent "ManagedSettings"             "import ManagedSettings"
forbidden_absent "AuthenticationServices"      "import AuthenticationServices"
forbidden_absent "PHPhotoLibrary"              "PHPhotoLibrary"
forbidden_absent "AVFoundation"                "import AVFoundation"
forbidden_absent "Gmail reference"             "gmail.com/gmail/v1"
forbidden_absent "EventKit"                    "import EventKit"

# ──────────────────────────────────────────────────────────────────────────────
# Goal 8 — xcodebuild availability
# ──────────────────────────────────────────────────────────────────────────────
section "Goal 8: xcodebuild Availability"
if command -v xcodebuild &>/dev/null; then
    XCODE_VER=$(xcodebuild -version 2>/dev/null | head -1)
    pass "xcodebuild available: $XCODE_VER"
else
    warn "xcodebuild not found — skipping build and test goals"
    XCODE_VER=""
fi

# ──────────────────────────────────────────────────────────────────────────────
# Goal 9 — iOS build
# ──────────────────────────────────────────────────────────────────────────────
section "Goal 9: iOS Build"
if [[ -n "$XCODE_VER" ]]; then
    if xcodebuild build \
        -project "$REPO_ROOT/Oathen.xcodeproj" \
        -target Oathen_iOS \
        -sdk iphonesimulator \
        -configuration Debug \
        CODE_SIGNING_ALLOWED=NO \
        > "$LOG_DIR/ios_build.log" 2>&1; then
        pass "iOS build: exit 0"
    else
        fail "iOS build failed — see validation/logs/ios_build.log"
    fi
else
    warn "iOS build skipped — xcodebuild not available"
fi

# ──────────────────────────────────────────────────────────────────────────────
# Goal 10 — macOS build
# ──────────────────────────────────────────────────────────────────────────────
section "Goal 10: macOS Build"
if [[ -n "$XCODE_VER" ]]; then
    if xcodebuild build \
        -project "$REPO_ROOT/Oathen.xcodeproj" \
        -target Oathen_macOS \
        -sdk macosx \
        -configuration Debug \
        CODE_SIGNING_ALLOWED=NO \
        > "$LOG_DIR/macos_build.log" 2>&1; then
        pass "macOS build: exit 0"
    else
        fail "macOS build failed — see validation/logs/macos_build.log"
    fi
else
    warn "macOS build skipped — xcodebuild not available"
fi

# ──────────────────────────────────────────────────────────────────────────────
# Goal 11 — watchOS build
# ──────────────────────────────────────────────────────────────────────────────
section "Goal 11: watchOS Build"
if [[ -n "$XCODE_VER" ]]; then
    if xcodebuild build \
        -project "$REPO_ROOT/Oathen.xcodeproj" \
        -target OathenWatch \
        -sdk watchsimulator \
        -configuration Debug \
        CODE_SIGNING_ALLOWED=NO \
        > "$LOG_DIR/watchos_build.log" 2>&1; then
        pass "watchOS build: exit 0"
    else
        fail "watchOS build failed — see validation/logs/watchos_build.log"
    fi
else
    warn "watchOS build skipped — xcodebuild not available"
fi

# ──────────────────────────────────────────────────────────────────────────────
# Goal 12 — Unit tests (OathenTests scheme)
# ──────────────────────────────────────────────────────────────────────────────
section "Goal 12: Unit Tests"
if [[ -n "$XCODE_VER" ]]; then
    if xcodebuild test \
        -project "$REPO_ROOT/Oathen.xcodeproj" \
        -scheme OathenTests \
        -destination 'platform=macOS,arch=arm64' \
        CODE_SIGNING_ALLOWED=NO \
        > "$LOG_DIR/unit_tests.log" 2>&1; then
        pass "OathenTests: ** TEST SUCCEEDED **"
    else
        fail "OathenTests FAILED — see validation/logs/unit_tests.log"
    fi
else
    warn "Unit tests skipped — xcodebuild not available"
fi

# ──────────────────────────────────────────────────────────────────────────────
# Summary
# ──────────────────────────────────────────────────────────────────────────────
echo ""
echo "────────────────────────────────────────────────────────────────"
TOTAL=$((PASS + FAIL + WARN))
echo "Sprint 3 Validation: $PASS passed / $FAIL failed / $WARN warnings / $TOTAL total"
echo "────────────────────────────────────────────────────────────────"

# ──────────────────────────────────────────────────────────────────────────────
# Report
# ──────────────────────────────────────────────────────────────────────────────
TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"
cat > "$REPORT" <<EOF
# Oathen Sprint 3 Validation Report

**Generated:** $TIMESTAMP
**Script:** scripts/validate_sprint3.sh
**Repository:** $REPO_ROOT

## Result

| Metric | Count |
|--------|-------|
| Passed | $PASS |
| Failed | $FAIL |
| Warnings | $WARN |
| Total | $TOTAL |

## Goals

1. Repository root check
2. Sprint 2 baseline
3. Sprint 3 source files exist (18 files)
4. Domain model conformances
5. DailyRoutinePolicy helpers
6. TodayViewModel
7. Forbidden implementations (20 patterns)
8. xcodebuild availability
9. iOS build
10. macOS build
11. watchOS build
12. OathenTests unit tests

## Build Environment

- xcodebuild: ${XCODE_VER:-not found}
- Logs: validation/logs/

## Sprint 3 Notes

- In-memory state only — no persistence, no SwiftData
- TodayViewModel is @Observable @MainActor
- DailyRoutinePolicy is pure deterministic, no AI or HealthKit
- Watch target is unchanged (placeholder only)
EOF

if [[ $FAIL -eq 0 ]]; then
    echo "Sprint 3 validation PASSED. Report: $REPORT"
    exit 0
else
    echo "Sprint 3 validation FAILED ($FAIL failures). Report: $REPORT"
    exit 1
fi
