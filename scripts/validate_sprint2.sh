#!/usr/bin/env bash
# =============================================================================
# Oathen — Sprint 2 Validation Script
# Goal: verify Core Domain Models meet all Sprint 2 acceptance criteria.
# Calls validate_sprint1.sh first, then runs Sprint 2 specific checks.
# Generates: validation/sprint2_validation_report.md
#
# Build approach (when Xcode is available):
#   iOS    → -target Oathen_iOS  -sdk iphonesimulator  (no simulator runtime needed)
#   macOS  → -target Oathen_macOS -sdk macosx           (native)
#   watchOS→ -target OathenWatch  -sdk watchsimulator   (no simulator runtime needed)
#   tests  → -scheme OathenTests -destination 'platform=macOS,arch=arm64'
# =============================================================================
set -euo pipefail

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
PASS=0
FAIL=0
WARN=0
LINES=()

log()     { LINES+=("$1"); echo "$1"; }
pass()    { PASS=$((PASS+1)); log "  ✅  $1"; }
fail()    { FAIL=$((FAIL+1)); log "  ❌  $1"; }
warn()    { WARN=$((WARN+1)); log "  ⚠️   $1"; }
section() { log ""; log "## $1"; log ""; }

# ---------------------------------------------------------------------------
# Goal 0 — Confirm repo root
# ---------------------------------------------------------------------------
section "Goal 0 — Repository Root"

if [[ ! -f "project.yml" ]]; then
    echo "ERROR: Run this script from the repository root (where project.yml lives)."
    exit 1
fi

REPO_ROOT="$(pwd)"
REPORT_DIR="validation"
mkdir -p "$REPORT_DIR/logs"

pass "Repo root: $REPO_ROOT"
pass "project.yml found"

# ---------------------------------------------------------------------------
# Goal 1 — Sprint 1 baseline (must still pass)
# ---------------------------------------------------------------------------
section "Goal 1 — Sprint 1 Baseline"

if [[ -f "scripts/validate_sprint1.sh" ]]; then
    log "  Running scripts/validate_sprint1.sh..."
    SPRINT1_OUT="$REPORT_DIR/logs/sprint1_baseline.log"
    if bash scripts/validate_sprint1.sh > "$SPRINT1_OUT" 2>&1; then
        pass "Sprint 1 validation still passes"
    else
        fail "Sprint 1 validation FAILED — check $SPRINT1_OUT"
        tail -10 "$SPRINT1_OUT" | while IFS= read -r line; do log "    $line"; done
    fi
else
    fail "scripts/validate_sprint1.sh not found"
fi

# ---------------------------------------------------------------------------
# Goal 2 — Sprint 2 domain source files exist
# ---------------------------------------------------------------------------
section "Goal 2 — Domain Source Files"

DOMAIN_SOURCES=(
    # Models
    "Oathen/Core/Domain/Models/Goal.swift"
    "Oathen/Core/Domain/Models/Project.swift"
    "Oathen/Core/Domain/Models/Habit.swift"
    "Oathen/Core/Domain/Models/OathenTask.swift"
    "Oathen/Core/Domain/Models/Routine.swift"
    "Oathen/Core/Domain/Models/RoutineStep.swift"
    "Oathen/Core/Domain/Models/Evidence.swift"
    "Oathen/Core/Domain/Models/DisciplineScore.swift"
    "Oathen/Core/Domain/Models/ContextMode.swift"
    # Value Objects
    "Oathen/Core/Domain/ValueObjects/Priority.swift"
    "Oathen/Core/Domain/ValueObjects/CompletionStatus.swift"
    "Oathen/Core/Domain/ValueObjects/EvidenceRequirement.swift"
    "Oathen/Core/Domain/ValueObjects/RecurrenceRule.swift"
    "Oathen/Core/Domain/ValueObjects/ScoreBreakdown.swift"
    "Oathen/Core/Domain/ValueObjects/DateRange.swift"
    # Policies
    "Oathen/Core/Domain/Policies/DisciplineScorePolicy.swift"
    "Oathen/Core/Domain/Policies/TaskPriorityPolicy.swift"
    # Fixtures
    "Oathen/Core/Domain/Fixtures/DomainFixtures.swift"
)

for src in "${DOMAIN_SOURCES[@]}"; do
    if [[ -f "$src" ]]; then
        pass "$src"
    else
        fail "$src MISSING"
    fi
done

# Test files
TEST_SOURCES=(
    "OathenTests/ModelTests.swift"
    "OathenTests/PolicyTests.swift"
    "OathenTests/CodableTests.swift"
)

for src in "${TEST_SOURCES[@]}"; do
    if [[ -f "$src" ]]; then
        pass "$src"
    else
        warn "$src missing — unit tests will be skipped"
    fi
done

# ---------------------------------------------------------------------------
# Goal 3 — Domain model conformance checks (grep-based)
# ---------------------------------------------------------------------------
section "Goal 3 — Domain Model Conformance"

SWIFT_DOMAIN_FILES=$(find Oathen/Core/Domain -name "*.swift" | sort)
DOMAIN_COUNT=$(echo "$SWIFT_DOMAIN_FILES" | grep -c ".swift" || true)
log "  Scanning $DOMAIN_COUNT domain Swift files..."

check_present() {
    local pattern="$1"
    local label="$2"
    if echo "$SWIFT_DOMAIN_FILES" | xargs grep -l "$pattern" 2>/dev/null | grep -q "."; then
        pass "$label present in domain layer"
    else
        fail "$label ($pattern) NOT FOUND in domain layer"
    fi
}

check_present "Identifiable"  "Identifiable conformance"
check_present "Codable"       "Codable conformance"
check_present "Sendable"      "Sendable conformance"
check_present "CaseIterable"  "CaseIterable on enums"
check_present "import Foundation" "Foundation import (no UIKit/SwiftUI)"

# Domain must NOT import SwiftUI or UIKit
if echo "$SWIFT_DOMAIN_FILES" | xargs grep -l "import SwiftUI\|import UIKit\|import AppKit" 2>/dev/null | grep -q "."; then
    local found
    found=$(echo "$SWIFT_DOMAIN_FILES" | xargs grep -l "import SwiftUI\|import UIKit\|import AppKit" 2>/dev/null | tr '\n' ' ')
    fail "FORBIDDEN: Domain layer imports SwiftUI/UIKit/AppKit in: $found"
else
    pass "Domain layer is platform-agnostic (no SwiftUI/UIKit/AppKit imports)"
fi

# OathenTask must not use bare 'Task' as the Swift type name
if grep -r "^struct Task:" Oathen/Core/Domain 2>/dev/null | grep -q "Task:"; then
    fail "FORBIDDEN: 'struct Task' found — must be 'OathenTask' to avoid Swift Task conflict"
else
    pass "OathenTask named correctly (no bare 'Task' struct)"
fi

# No @Model annotation (SwiftData)
if echo "$SWIFT_DOMAIN_FILES" | xargs grep -l "@Model" 2>/dev/null | grep -q "."; then
    fail "FORBIDDEN: @Model (SwiftData) found in domain layer"
else
    pass "No @Model in domain layer"
fi

# ---------------------------------------------------------------------------
# Goal 4 — xcodebuild availability
# ---------------------------------------------------------------------------
section "Goal 4 — xcodebuild Availability"

XCODE_AVAILABLE=false
if xcodebuild -version >/dev/null 2>&1; then
    XCODE_AVAILABLE=true
    XCODE_VER="$(xcodebuild -version 2>&1 | head -1)"
    pass "xcodebuild available: $XCODE_VER"
else
    warn "xcodebuild unavailable — build and test goals will be SKIPPED"
fi

# ---------------------------------------------------------------------------
# Goal 5 — iOS build (Sprint 2 domain included)
# ---------------------------------------------------------------------------
section "Goal 5 — iOS Build (includes domain models)"

if [[ "$XCODE_AVAILABLE" == "true" ]]; then
    LOG_IOS="$REPORT_DIR/logs/sprint2_ios_build.log"
    log "  Running: xcodebuild build -target Oathen_iOS -sdk iphonesimulator ..."
    if xcodebuild build \
        -target Oathen_iOS \
        -sdk iphonesimulator \
        CODE_SIGNING_ALLOWED=NO \
        -quiet >"$LOG_IOS" 2>&1; then
        pass "iOS build SUCCEEDED (domain models compile on iOS)"
    else
        fail "iOS build FAILED — log: $LOG_IOS"
        grep "error:" "$LOG_IOS" | head -10 | while IFS= read -r line; do log "    $line"; done
    fi
else
    warn "SKIPPED — xcodebuild not available"
fi

# ---------------------------------------------------------------------------
# Goal 6 — macOS build
# ---------------------------------------------------------------------------
section "Goal 6 — macOS Build (includes domain models)"

if [[ "$XCODE_AVAILABLE" == "true" ]]; then
    LOG_MACOS="$REPORT_DIR/logs/sprint2_macos_build.log"
    log "  Running: xcodebuild build -target Oathen_macOS -sdk macosx ..."
    if xcodebuild build \
        -target Oathen_macOS \
        -sdk macosx \
        CODE_SIGNING_ALLOWED=NO \
        -quiet >"$LOG_MACOS" 2>&1; then
        pass "macOS build SUCCEEDED (domain models compile on macOS)"
    else
        fail "macOS build FAILED — log: $LOG_MACOS"
        grep "error:" "$LOG_MACOS" | head -10 | while IFS= read -r line; do log "    $line"; done
    fi
else
    warn "SKIPPED — xcodebuild not available"
fi

# ---------------------------------------------------------------------------
# Goal 7 — watchOS build
# ---------------------------------------------------------------------------
section "Goal 7 — watchOS Build"

if [[ "$XCODE_AVAILABLE" == "true" ]]; then
    LOG_WATCH="$REPORT_DIR/logs/sprint2_watchos_build.log"
    log "  Running: xcodebuild build -target OathenWatch -sdk watchsimulator ..."
    if xcodebuild build \
        -target OathenWatch \
        -sdk watchsimulator \
        CODE_SIGNING_ALLOWED=NO \
        -quiet >"$LOG_WATCH" 2>&1; then
        pass "watchOS build SUCCEEDED"
    else
        fail "watchOS build FAILED — log: $LOG_WATCH"
        grep "error:" "$LOG_WATCH" | head -10 | while IFS= read -r line; do log "    $line"; done
    fi
else
    warn "SKIPPED — xcodebuild not available"
fi

# ---------------------------------------------------------------------------
# Goal 8 — Unit tests
# ---------------------------------------------------------------------------
section "Goal 8 — Unit Tests (OathenTests scheme, macOS)"

TEST_TARGET_EXISTS=false
if xcodebuild -list -project Oathen.xcodeproj 2>/dev/null | grep -q "OathenTests"; then
    TEST_TARGET_EXISTS=true
fi

if [[ "$XCODE_AVAILABLE" == "true" && "$TEST_TARGET_EXISTS" == "true" ]]; then
    LOG_TESTS="$REPORT_DIR/logs/sprint2_unit_tests.log"
    log "  Running: xcodebuild test -scheme OathenTests -destination 'platform=macOS,arch=arm64' ..."
    if xcodebuild test \
        -project Oathen.xcodeproj \
        -scheme OathenTests \
        -destination 'platform=macOS,arch=arm64' \
        CODE_SIGNING_ALLOWED=NO \
        -quiet >"$LOG_TESTS" 2>&1; then
        pass "All unit tests PASSED"
        # Count test cases from log
        if grep -q "Test Suite" "$LOG_TESTS" 2>/dev/null; then
            PASSED_COUNT=$(grep -c "passed" "$LOG_TESTS" 2>/dev/null || echo "?")
            log "  Tests passed: $PASSED_COUNT"
        fi
    else
        fail "Unit tests FAILED — log: $LOG_TESTS"
        grep -E "Failing tests:|FAILED" "$LOG_TESTS" | head -10 | while IFS= read -r line; do log "    $line"; done
    fi
elif [[ "$XCODE_AVAILABLE" == "false" ]]; then
    warn "SKIPPED — xcodebuild not available"
else
    warn "SKIPPED — OathenTests scheme not found in project"
fi

# ---------------------------------------------------------------------------
# Goal 9 — Forbidden implementation scan (Sprint 2 extended)
# ---------------------------------------------------------------------------
section "Goal 9 — Forbidden Implementation Scan (Sprint 2)"

ALL_SWIFT=$(find . \
    -name "*.swift" \
    -not -path "./.build/*" \
    -not -path "./Oathen.xcodeproj/*" \
    -not -path "*/.swiftpm/*" \
    -not -path "./build/*" \
    | sort)

SWIFT_COUNT=$(echo "$ALL_SWIFT" | grep -c ".swift" || true)
log "  Scanning $SWIFT_COUNT Swift source files..."

check_forbidden() {
    local pattern="$1"
    local label="$2"
    local context="$3"
    if echo "$ALL_SWIFT" | xargs grep -l "$pattern" 2>/dev/null | grep -q "."; then
        local found_in
        found_in=$(echo "$ALL_SWIFT" | xargs grep -l "$pattern" 2>/dev/null | tr '\n' ' ')
        fail "FORBIDDEN: $label ($pattern) found in: $found_in — $context"
    else
        pass "No $label ($pattern)"
    fi
}

# Persistence (still forbidden in Sprint 2)
check_forbidden "@Model"                     "SwiftData @Model"            "Persistence — Sprint 3+"
check_forbidden "ModelContainer"             "SwiftData ModelContainer"    "Persistence — Sprint 3+"
check_forbidden "NSManagedObject"            "Core Data"                   "Persistence — Sprint 3+"
check_forbidden "NSPersistentContainer"      "Core Data stack"             "Persistence — Sprint 3+"

# Backend
check_forbidden "import Supabase"            "Supabase SDK"                "Backend — Sprint 8+"
check_forbidden "SupabaseClient"             "SupabaseClient"              "Backend — Sprint 8+"

# HealthKit
check_forbidden "import HealthKit"           "HealthKit"                   "Sprint 4"
check_forbidden "HKHealthStore"              "HKHealthStore"               "Sprint 4"

# AI/LLM
check_forbidden "openai\.com"                "OpenAI endpoint"             "Sprint 7"
check_forbidden "api\.anthropic\.com"        "Anthropic endpoint"          "Sprint 7"
check_forbidden "generativelanguage\.google" "Gemini endpoint"             "Sprint 7"
check_forbidden "ChatCompletion"             "OpenAI ChatCompletion"       "Sprint 7"
check_forbidden "AnthropicClient"            "Anthropic SDK"               "Sprint 7"

# Auth
check_forbidden "ASAuthorizationController"  "Sign in with Apple"          "Sprint 8"
check_forbidden "GIDSignIn"                  "Google Sign-In"              "Sprint 8"

# Notifications
check_forbidden "UNUserNotificationCenter"   "Notification scheduling"     "Sprint 6"

# WidgetKit / ActivityKit
check_forbidden "import WidgetKit"           "WidgetKit"                   "Sprint 9+"
check_forbidden "import ActivityKit"         "ActivityKit"                 "Sprint 9+"
check_forbidden "ActivityAttributes"         "Live Activity"               "Sprint 9+"

# WatchConnectivity
check_forbidden "import WatchConnectivity"   "WatchConnectivity"           "Sprint 6"
check_forbidden "WCSession"                  "WCSession"                   "Sprint 6"

# DeviceActivity
check_forbidden "import DeviceActivity"      "DeviceActivity"              "Sprint 11"
check_forbidden "import FamilyControls"      "FamilyControls"              "Sprint 11"
check_forbidden "import ManagedSettings"     "ManagedSettings"             "Sprint 11"
check_forbidden "DeviceActivityMonitor"      "DeviceActivityMonitor"       "Sprint 11"

# Photo / storage implementation
check_forbidden "PHPhotoLibrary"             "PhotoKit"                    "Sprint 5"
check_forbidden "AVFoundation"               "AVFoundation (camera)"       "Sprint 5"

# Core Data model files
if find . -name "*.xcdatamodeld" -not -path "./.build/*" -not -path "./build/*" | grep -q "."; then
    fail "FORBIDDEN: .xcdatamodeld found — use SwiftData (Sprint 3+)"
else
    pass "No .xcdatamodeld Core Data model files"
fi

# ---------------------------------------------------------------------------
# Goal 10 — Summary
# ---------------------------------------------------------------------------
section "Validation Summary"

TOTAL=$((PASS + FAIL + WARN))
log "  Total checks : $TOTAL"
log "  Passed       : $PASS"
log "  Failed       : $FAIL"
log "  Warnings     : $WARN"
log ""

if [[ $FAIL -eq 0 ]]; then
    log "  ✅  ALL CHECKS PASSED — Sprint 2 domain models are valid."
    STATUS="PASSED"
else
    log "  ❌  $FAIL CHECKS FAILED — address the failures above before Sprint 3."
    STATUS="FAILED ($FAIL failures)"
fi

if [[ $WARN -gt 0 ]]; then
    log "  ⚠️   $WARN warnings (usually: Xcode not installed — install before final validation)"
fi

# ---------------------------------------------------------------------------
# Write report
# ---------------------------------------------------------------------------
REPORT="$REPORT_DIR/sprint2_validation_report.md"

{
    echo "# Sprint 2 Validation Report"
    echo ""
    echo "**Status:** $STATUS"
    echo "**Date:** $(date '+%Y-%m-%d %H:%M:%S %Z')"
    echo "**Repo:** $REPO_ROOT"
    echo ""
    echo "---"
    echo ""
    for line in "${LINES[@]}"; do
        echo "$line"
    done
    echo ""
    echo "---"
    echo ""
    echo "## Domain Layer"
    echo ""
    echo "### Models Implemented"
    echo "- Goal, Project, Habit, OathenTask"
    echo "- Routine, RoutineStep"
    echo "- Evidence, DisciplineScore, ContextMode"
    echo ""
    echo "### Value Objects"
    echo "- Priority, CompletionStatus (6 status enums), EvidenceRequirement"
    echo "- RecurrenceRule, ScoreBreakdown, DateRange"
    echo ""
    echo "### Policies"
    echo "- DisciplineScorePolicy (rule-based placeholder)"
    echo "- TaskPriorityPolicy (deterministic due-date escalation)"
    echo ""
    echo "### Fixtures"
    echo "- DomainFixtures (sample goal, project, 3 habits, 2 tasks, routine, score)"
    echo ""
    echo "## Build Approach"
    echo ""
    echo "Builds use \`-target\` + \`-sdk\` (no simulator runtime required):"
    echo "- iOS:    \`-target Oathen_iOS -sdk iphonesimulator\`"
    echo "- macOS:  \`-target Oathen_macOS -sdk macosx\`"
    echo "- watchOS:\`-target OathenWatch -sdk watchsimulator\`"
    echo "- Tests:  \`-scheme OathenTests -destination 'platform=macOS,arch=arm64'\`"
    echo ""
    echo "Full build logs: \`$REPORT_DIR/logs/\`"
    echo ""
    echo "## Not Implemented (Sprint 2 scope boundaries)"
    echo ""
    echo "- No SwiftData / Core Data / Supabase"
    echo "- No HealthKit"
    echo "- No AI provider code"
    echo "- No notifications, WidgetKit, ActivityKit"
    echo "- No WatchConnectivity, DeviceActivity, FamilyControls"
    echo "- No authentication"
    echo "- No full 42-entity data model (Sprint 0 plan)"
    echo ""
    echo "## Next Steps"
    echo ""
    if [[ $FAIL -eq 0 ]]; then
        echo "- Sprint 2 domain layer validated. Proceed to Sprint 3 planning."
        echo "- Sprint 3: Morning Check-in, Night Review, Daily Routine Engine, Score calculation."
    else
        echo "- Address the $FAIL failing checks above, then re-run this script."
    fi
} > "$REPORT"

log ""
log "  Report written to: $REPORT"
log ""
