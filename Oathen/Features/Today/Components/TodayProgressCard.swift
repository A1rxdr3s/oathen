// Sprint 3 — TodayProgressCard component.
// Shows overall day progress with a progress bar.
import SwiftUI

struct TodayProgressCard: View {
    let state: TodayState

    private var progressColor: Color {
        let p = state.dailyPlan.progressFraction
        if p >= 0.8 { return OathenColors.success }
        if p >= 0.5 { return OathenColors.accent }
        return OathenColors.warning
    }

    var body: some View {
        OathenCard {
            VStack(alignment: .leading, spacing: OathenSpacing.md) {
                HStack {
                    Text(state.completionSummary)
                        .font(OathenTypography.headingSmall)
                    Spacer()
                    Text("\(Int(state.dailyPlan.progressFraction * 100))%")
                        .font(OathenTypography.monoData)
                        .foregroundStyle(progressColor)
                }

                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: OathenRadius.sm)
                            .fill(progressColor.opacity(0.15))
                            .frame(height: 8)
                        RoundedRectangle(cornerRadius: OathenRadius.sm)
                            .fill(progressColor)
                            .frame(
                                width: max(0, proxy.size.width * state.dailyPlan.progressFraction),
                                height: 8
                            )
                            .animation(.easeInOut(duration: 0.3), value: state.dailyPlan.progressFraction)
                    }
                }
                .frame(height: 8)

                HStack(spacing: OathenSpacing.lg) {
                    statusPill(
                        icon: "sun.horizon.fill",
                        label: "Morning",
                        complete: state.isMorningCheckInComplete
                    )
                    statusPill(
                        icon: "moon.stars.fill",
                        label: "Night Review",
                        complete: state.isNightReviewComplete
                    )
                    Spacer()
                    Text(state.criticalCompletionSummary)
                        .font(OathenTypography.bodySmall)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func statusPill(icon: String, label: String, complete: Bool) -> some View {
        HStack(spacing: OathenSpacing.xs) {
            Image(systemName: complete ? "checkmark.circle.fill" : icon)
                .font(.caption)
                .foregroundStyle(complete ? OathenColors.success : .secondary)
            Text(label)
                .font(OathenTypography.bodySmall)
                .foregroundStyle(complete ? .primary : .secondary)
        }
    }
}

#Preview {
    TodayProgressCard(state: DailyRoutinePolicy.defaultTodayState())
        .padding()
        .preferredColorScheme(.dark)
}
