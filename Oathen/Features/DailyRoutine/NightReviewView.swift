// Sprint 3 — NightReviewView.
// Placeholder night review flow. Shows day summary, captures failure reason,
// displays recovery plan. No persistence, no AI.
import SwiftUI

struct NightReviewView: View {
    @Environment(\.dismiss) private var dismiss

    let state: TodayState
    var onComplete: (String) -> Void

    @State private var failureReason: String = ""

    private var plan: DailyPlan { state.dailyPlan }
    private var previewRecovery: String {
        DailyRoutinePolicy.recoveryRecommendation(
            missedCriticalCount: plan.criticalItems.filter { !$0.isComplete }.count,
            failureReason: failureReason.isEmpty ? nil : failureReason
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Day Summary") {
                    summaryStats
                }

                Section("Commitments") {
                    commitmentRows
                }

                Section("Health Pillars") {
                    pillarRow("Hydration", complete: plan.hydrationCompleted, color: OathenColors.hydration)
                    pillarRow("Exercise", complete: plan.exerciseCompleted, color: OathenColors.exercise)
                    pillarRow("Sleep Routine", complete: plan.sleepRoutineStarted, color: OathenColors.sleep)
                }

                if plan.criticalItems.contains(where: { !$0.isComplete }) {
                    Section("Failure Reason") {
                        TextField("What prevented completion?", text: $failureReason, axis: .vertical)
                            .lineLimit(3...6)
                        if NightReview.detectExcuse(in: failureReason.isEmpty ? nil : failureReason) {
                            HStack(spacing: OathenSpacing.xs) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundStyle(OathenColors.warning)
                                    .font(.caption)
                                Text("Excuse pattern detected. Log it as a data point.")
                                    .font(OathenTypography.bodySmall)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                Section("Tomorrow's Recovery Plan") {
                    Text(previewRecovery)
                        .font(OathenTypography.bodySmall)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Section {
                    Button(action: complete) {
                        HStack {
                            Spacer()
                            Text("Close the Day")
                                .font(OathenTypography.headingSmall)
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        .padding(.vertical, OathenSpacing.xs)
                    }
                    .listRowBackground(OathenColors.sleep)
                }
            }
            .navigationTitle("Night Review")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private var summaryStats: some View {
        HStack(spacing: OathenSpacing.xl) {
            statBlock(
                value: "\(plan.completedCount)/\(plan.totalCount)",
                label: "Complete"
            )
            statBlock(
                value: "\(plan.completedCriticalCount)/\(plan.totalCriticalCount)",
                label: "Critical"
            )
            statBlock(
                value: "\(Int(plan.progressFraction * 100))%",
                label: "Progress"
            )
            Spacer()
        }
        .listRowBackground(Color.clear)
    }

    private func statBlock(value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .font(OathenTypography.headingLarge)
                .foregroundStyle(OathenColors.accent)
                .monospacedDigit()
            Text(label)
                .font(OathenTypography.bodySmall)
                .foregroundStyle(.secondary)
        }
    }

    private var commitmentRows: some View {
        ForEach(plan.items.filter { $0.kind == .criticalTask || $0.kind == .habit }) { item in
            HStack(spacing: OathenSpacing.sm) {
                Image(systemName: item.isComplete ? "checkmark.circle.fill" : "xmark.circle")
                    .foregroundStyle(item.isComplete ? OathenColors.success : OathenColors.critical)
                Text(item.title)
                    .font(OathenTypography.bodyMedium)
                    .foregroundStyle(item.isComplete ? .secondary : .primary)
                Spacer()
            }
        }
    }

    private func pillarRow(_ label: String, complete: Bool, color: Color) -> some View {
        HStack(spacing: OathenSpacing.sm) {
            Image(systemName: complete ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(complete ? OathenColors.success : color.opacity(0.5))
            Text(label)
                .foregroundStyle(complete ? .secondary : .primary)
            Spacer()
        }
    }

    private func complete() {
        onComplete(failureReason)
        dismiss()
    }
}

#Preview {
    NightReviewView(
        state: DailyRoutinePolicy.defaultTodayState(),
        onComplete: { _ in }
    )
    .preferredColorScheme(.dark)
}
