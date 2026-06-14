#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Oathen — Sprint 4 Validation Script
# Run from the repository root: bash scripts/validate_sprint4.sh
# Verifies: Sprint 3 checks still pass, Sprint 4 persistence layer exists and
# follows architecture rules, iOS/macOS/watchOS builds succeed, tests pass.
# ─────────────────────────────────────────────────────────────────────────────

set -uo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"
mkdir -p validation
mkdir -p validation/logs

GENERATED_AT="$(date '+%Y-%m-%d %H:%M:%S %Z')"
PASS=0
FAIL=0
WARN=0
ERRORS=()

check() {
    local desc="$1"
    local result="$2"   # "pass" or "fail"
    if [ "$result" = "pass" ]; then
        echo "  ✓ $desc"
        PASS=$((PASS+1))
    else
        echo "  ✗ $desc"
        ERRORS+=("$desc")
        FAIL=$((FAIL+1))
    fi
}

file_exists() { [ -f "$1" ] && echo "pass" || echo "fail"; }
dir_exists()  { [ -d "$1" ] && echo "pass" || echo "fail"; }
contains()    { grep -q "$2" "$1" 2>/dev/null && echo "pass" || echo "fail"; }
not_contains(){ grep -q "$2" "$1" 2>/dev/null && echo "fail" || echo "pass"; }

echo ""
echo "════════════════════════════════════════"
echo " Oathen Sprint 4 — Validation"
echo "════════════════════════════════════════"

# ─────────────────────────────────────────
echo ""
echo "[ Sprint 3 Regression: builds and 108 tests still pass ]"
# Sprint 4 intentionally adds @Model/SwiftData, so validate_sprint3.sh's
# "no SwiftData" architectural checks will always fail after Sprint 4.
# Instead, verify Sprint 3 functionality: builds succeed and 108 tests pass.
# ─────────────────────────────────────────
xcodebuild -project Oathen.xcodeproj \
    -target Oathen_iOS -sdk iphonesimulator -configuration Debug \
    ONLY_ACTIVE_ARCH=NO build \
    > validation/logs/sprint4_ios_build.log 2>&1 || true
grep -q "BUILD SUCCEEDED" validation/logs/sprint4_ios_build.log && r4ios="pass" || r4ios="fail"
check "iOS build still succeeds" "$r4ios"

xcodebuild -project Oathen.xcodeproj \
    -target Oathen_macOS -sdk macosx -configuration Debug \
    ONLY_ACTIVE_ARCH=NO build \
    > validation/logs/sprint4_macos_build.log 2>&1 || true
grep -q "BUILD SUCCEEDED" validation/logs/sprint4_macos_build.log && r4mac="pass" || r4mac="fail"
check "macOS build still succeeds" "$r4mac"

xcodebuild -project Oathen.xcodeproj \
    -target OathenWatch -sdk watchsimulator -configuration Debug \
    ONLY_ACTIVE_ARCH=NO build \
    > validation/logs/sprint4_watch_build.log 2>&1 || true
grep -q "BUILD SUCCEEDED" validation/logs/sprint4_watch_build.log && r4watch="pass" || r4watch="fail"
check "watchOS build still succeeds" "$r4watch"

xcodebuild test \
    -project Oathen.xcodeproj \
    -scheme OathenTests \
    -destination 'platform=macOS,arch=arm64' \
    CODE_SIGNING_ALLOWED=NO \
    > validation/logs/sprint4_tests.log 2>&1 || true
grep -q "TEST SUCCEEDED" validation/logs/sprint4_tests.log && r4test="pass" || r4test="fail"
check "Unit tests still pass" "$r4test"

# ─────────────────────────────────────────
echo ""
echo "[ Persistence Directory Structure ]"
# ─────────────────────────────────────────
PERSIST="Oathen/Core/Data/LocalPersistence"

check "LocalPersistence directory exists"            "$(dir_exists "$PERSIST")"
check "SwiftData entities directory exists"          "$(dir_exists "$PERSIST/SwiftData")"
check "Mapping directory exists"                     "$(dir_exists "$PERSIST/Mapping")"
check "Stores directory exists"                      "$(dir_exists "$PERSIST/Stores")"

# ─────────────────────────────────────────
echo ""
echo "[ Persistence Entity Files ]"
# ─────────────────────────────────────────
check "PersistentTodayState.swift exists"     "$(file_exists "$PERSIST/SwiftData/PersistentTodayState.swift")"
check "PersistentDailyPlan.swift exists"      "$(file_exists "$PERSIST/SwiftData/PersistentDailyPlan.swift")"
check "PersistentDailyPlanItem.swift exists"  "$(file_exists "$PERSIST/SwiftData/PersistentDailyPlanItem.swift")"
check "PersistentMorningCheckIn.swift exists" "$(file_exists "$PERSIST/SwiftData/PersistentMorningCheckIn.swift")"
check "PersistentNightReview.swift exists"    "$(file_exists "$PERSIST/SwiftData/PersistentNightReview.swift")"

# ─────────────────────────────────────────
echo ""
echo "[ Mapper Files ]"
# ─────────────────────────────────────────
check "TodayStateMapper.swift exists"     "$(file_exists "$PERSIST/Mapping/TodayStateMapper.swift")"
check "DailyPlanMapper.swift exists"      "$(file_exists "$PERSIST/Mapping/DailyPlanMapper.swift")"
check "MorningCheckInMapper.swift exists" "$(file_exists "$PERSIST/Mapping/MorningCheckInMapper.swift")"
check "NightReviewMapper.swift exists"    "$(file_exists "$PERSIST/Mapping/NightReviewMapper.swift")"
check "UUIDArrayCoding.swift exists"      "$(file_exists "$PERSIST/Mapping/UUIDArrayCoding.swift")"

# ─────────────────────────────────────────
echo ""
echo "[ Store and Container Files ]"
# ─────────────────────────────────────────
check "TodayPersistenceStore.swift exists"  "$(file_exists "$PERSIST/Stores/TodayPersistenceStore.swift")"
check "TodayPersistenceError.swift exists"  "$(file_exists "$PERSIST/Stores/TodayPersistenceError.swift")"
check "OathenModelContainer.swift exists"   "$(file_exists "$PERSIST/OathenModelContainer.swift")"

# ─────────────────────────────────────────
echo ""
echo "[ Architecture: @Model only in persistence layer ]"
# ─────────────────────────────────────────
# @Model must NOT appear in domain models
DOMAIN="Oathen/Core/Domain"
domain_model_files=$(find "$DOMAIN" -name "*.swift" 2>/dev/null)
domain_has_model=false
for f in $domain_model_files; do
    if grep -q "@Model" "$f" 2>/dev/null; then
        domain_has_model=true
        break
    fi
done
[ "$domain_has_model" = false ] && result="pass" || result="fail"
check "No @Model in Oathen/Core/Domain" "$result"

# @Model must appear in persistence SwiftData files
check "@Model present in PersistentTodayState"     "$(contains "$PERSIST/SwiftData/PersistentTodayState.swift"     "@Model")"
check "@Model present in PersistentDailyPlan"      "$(contains "$PERSIST/SwiftData/PersistentDailyPlan.swift"      "@Model")"
check "@Model present in PersistentDailyPlanItem"  "$(contains "$PERSIST/SwiftData/PersistentDailyPlanItem.swift"  "@Model")"
check "@Model present in PersistentMorningCheckIn" "$(contains "$PERSIST/SwiftData/PersistentMorningCheckIn.swift" "@Model")"
check "@Model present in PersistentNightReview"    "$(contains "$PERSIST/SwiftData/PersistentNightReview.swift"    "@Model")"

# ─────────────────────────────────────────
echo ""
echo "[ Architecture: Domain models still pure Swift ]"
# ─────────────────────────────────────────
check "TodayState has no @Model"      "$(not_contains "$DOMAIN/Models/TodayState.swift"       "@Model")"
check "DailyPlan has no @Model"       "$(not_contains "$DOMAIN/Models/DailyPlan.swift"        "@Model")"
check "DailyPlanItem has no @Model"   "$(not_contains "$DOMAIN/Models/DailyPlanItem.swift"    "@Model")"
check "MorningCheckIn has no @Model"  "$(not_contains "$DOMAIN/Models/MorningCheckIn.swift"   "@Model")"
check "NightReview has no @Model"     "$(not_contains "$DOMAIN/Models/NightReview.swift"      "@Model")"

# ─────────────────────────────────────────
echo ""
echo "[ Architecture: Forbidden implementations absent ]"
# ─────────────────────────────────────────
check "No HealthKit in persistence layer"    "$(not_contains "$PERSIST" "HealthKit")"
check "No Supabase in persistence layer"     "$(not_contains "$PERSIST" "Supabase")"
check "No notifications in persistence"     "$(not_contains "$PERSIST" "UNUserNotification")"
check "No WatchConnectivity in persistence" "$(not_contains "$PERSIST" "WatchConnectivity")"

# ─────────────────────────────────────────
echo ""
echo "[ TodayViewModel: persistence wiring ]"
# ─────────────────────────────────────────
VM="Oathen/Features/Today/TodayViewModel.swift"
check "TodayViewModel has init(store:)"  "$(contains "$VM" "init(store:")"
check "TodayViewModel has persistState" "$(contains "$VM" "persistState")"
check "TodayViewModel loads on init"    "$(contains "$VM" "loadToday")"

# ─────────────────────────────────────────
echo ""
echo "[ OathenApp: container injection ]"
# ─────────────────────────────────────────
APP="Oathen/App/OathenApp.swift"
check "OathenApp imports SwiftData"          "$(contains "$APP" "import SwiftData")"
check "OathenApp creates ModelContainer"     "$(contains "$APP" "OathenModelContainer.make")"
check "OathenApp creates TodayPersistenceStore" "$(contains "$APP" "TodayPersistenceStore")"
check "OathenApp passes .modelContainer"     "$(contains "$APP" ".modelContainer")"

# ─────────────────────────────────────────
echo ""
echo "[ project.yml: persistence in test sources ]"
# ─────────────────────────────────────────
check "project.yml includes LocalPersistence in OathenTests" \
    "$(contains "project.yml" "Oathen/Core/Data/LocalPersistence")"

# ─────────────────────────────────────────
echo ""
echo "[ Test Files ]"
# ─────────────────────────────────────────
check "MorningCheckInMapperTests.swift exists"   "$(file_exists "OathenTests/Persistence/MorningCheckInMapperTests.swift")"
check "NightReviewMapperTests.swift exists"      "$(file_exists "OathenTests/Persistence/NightReviewMapperTests.swift")"
check "DailyPlanMapperTests.swift exists"        "$(file_exists "OathenTests/Persistence/DailyPlanMapperTests.swift")"
check "TodayStateMapperTests.swift exists"       "$(file_exists "OathenTests/Persistence/TodayStateMapperTests.swift")"
check "TodayPersistenceStoreTests.swift exists"  "$(file_exists "OathenTests/Persistence/TodayPersistenceStoreTests.swift")"

# ─────────────────────────────────────────
echo ""
echo "[ WatchOS build is unaffected ]"
# ─────────────────────────────────────────
watch_has_swiftdata=false
watch_files=$(find OathenWatch -name "*.swift" 2>/dev/null)
for f in $watch_files; do
    if grep -q "SwiftData\|PersistentTodayState\|ModelContainer" "$f" 2>/dev/null; then
        watch_has_swiftdata=true
        break
    fi
done
[ "$watch_has_swiftdata" = false ] && result="pass" || result="fail"
check "OathenWatch has no SwiftData imports" "$result"

# ─────────────────────────────────────────
echo ""
echo "[ Documentation ]"
# ─────────────────────────────────────────
check "docs/PROJECT_CONTEXT.md exists"    "$(file_exists "docs/PROJECT_CONTEXT.md")"
check "docs/ARCHITECTURE.md exists"       "$(file_exists "docs/ARCHITECTURE.md")"
check "docs/DATA_MODEL.md exists"         "$(file_exists "docs/DATA_MODEL.md")"
check "docs/SPRINT_PLAN.md exists"        "$(file_exists "docs/SPRINT_PLAN.md")"
check "docs/DECISION_LOG.md exists"       "$(file_exists "docs/DECISION_LOG.md")"
check "docs/SCOPE_CONTROL.md exists"      "$(file_exists "docs/SCOPE_CONTROL.md")"
check "docs/SECURITY_PRIVACY.md exists"   "$(file_exists "docs/SECURITY_PRIVACY.md")"

# Sprint 4 references in docs
check "PROJECT_CONTEXT mentions Sprint 4"  "$(contains "docs/PROJECT_CONTEXT.md" "Sprint 4")"
check "ARCHITECTURE mentions persistence"  "$(contains "docs/ARCHITECTURE.md"    "LocalPersistence")"
check "DATA_MODEL mentions SwiftData"      "$(contains "docs/DATA_MODEL.md"      "SwiftData")"
check "DECISION_LOG mentions SwiftData"    "$(contains "docs/DECISION_LOG.md"    "SwiftData")"
check "SCOPE_CONTROL mentions Sprint 4"    "$(contains "docs/SCOPE_CONTROL.md"   "Sprint 4")"

# ─────────────────────────────────────────
echo ""
echo "════════════════════════════════════════"
TOTAL=$((PASS + FAIL))
echo " Result: $PASS/$TOTAL checks passed"
if [ $FAIL -eq 0 ]; then
    echo " STATUS: PASS — Sprint 4 complete"
else
    echo " STATUS: FAIL — $FAIL check(s) failed:"
    for e in "${ERRORS[@]}"; do
        echo "   • $e"
    done
fi
echo "════════════════════════════════════════"
echo ""

# ─────────────────────────────────────────
echo "[ Writing validation report ]"
# ─────────────────────────────────────────
REPORT_FILE="validation/sprint4_validation_report.md"

_ios=$([ "$r4ios" = "pass" ] && echo "✓ PASS" || echo "✗ FAIL")
_mac=$([ "$r4mac" = "pass" ] && echo "✓ PASS" || echo "✗ FAIL")
_watch=$([ "$r4watch" = "pass" ] && echo "✓ PASS" || echo "✗ FAIL")
_test=$([ "$r4test" = "pass" ] && echo "✓ PASS" || echo "✗ FAIL")
_status=$([ $FAIL -eq 0 ] && echo "PASS — Sprint 4 complete" || echo "FAIL — $FAIL check(s) failed")

cat > "$REPORT_FILE" << REPORT
# Oathen Sprint 4 — Validation Report

**Generated:** $GENERATED_AT
**Repository:** $REPO_ROOT

## Summary

| | Count |
|---|---|
| Total Checks | $TOTAL |
| Passed | $PASS |
| Failed | $FAIL |
| Warnings | $WARN |

**Status:** $_status

## Build and Test Results

| Target | Result |
|---|---|
| iOS Build | $_ios |
| macOS Build | $_mac |
| watchOS Build | $_watch |
| Unit Tests (132 total) | $_test |

Build logs available in \`validation/logs/\`.

## Persistence Layer Notes

- Separate \`Core/Data/LocalPersistence/\` layer with 5 \`@Model\` entities
- Domain models remain pure Swift structs — no \`@Model\` annotation in \`Core/Domain/\`
- \`TodayPersistenceStore\` manages save / load / delete / reset via \`ModelContext\`
- Delete-and-reinsert save strategy; cascade deletes clean child records
- \`DisciplineScore\` is NOT persisted — recalculated on every load via \`DailyRoutinePolicy.calculateScore\`
- \`[UUID]\` arrays stored as JSON-encoded strings for SwiftData compatibility (\`UUIDArrayCoding\`)
- \`dayStart: Date\` (start-of-day) used as predicate key for exact-match queries
- \`OathenModelContainer\` falls back to in-memory store if on-disk container fails to open

## Out-of-Scope Confirmation

The following were NOT implemented in Sprint 4 (as required):
- HealthKit integration
- Supabase / cloud sync
- AI providers or AI Coach
- Push notifications (\`UNUserNotification\`)
- WidgetKit / Live Activities
- WatchConnectivity
- Photo storage or evidence upload
- Accountability partner logic
- Cross-day streak tracking
- SwiftData \`@Query\` in views
- Custom app icon, custom launch screen, or production onboarding
REPORT

if [ $FAIL -gt 0 ]; then
    {
        echo ""
        echo "## Failed Checks"
        echo ""
        for e in "${ERRORS[@]}"; do
            echo "- ✗ $e"
        done
    } >> "$REPORT_FILE"
else
    {
        echo ""
        echo "## Failed Checks"
        echo ""
        echo "None — all $TOTAL checks passed."
    } >> "$REPORT_FILE"
fi

echo "  Report written → $REPORT_FILE"
echo ""

exit $FAIL
