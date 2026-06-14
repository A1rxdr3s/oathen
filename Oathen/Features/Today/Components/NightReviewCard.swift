// Sprint 3 — NightReviewCard component.
// Shows night review status and triggers the review sheet.
import SwiftUI

struct NightReviewCard: View {
    let review: NightReview?
    let state: TodayState
    let onTap: () -> Void

    var body: some View {
        OathenCard {
            HStack(spacing: OathenSpacing.md) {
                Image(systemName: review?.isComplete == true ? "checkmark.circle.fill" : "moon.stars.fill")
                    .foregroundStyle(review?.isComplete == true ? OathenColors.success : OathenColors.sleep)
                    .font(.title3)

                VStack(alignment: .leading, spacing: OathenSpacing.xs) {
                    Text("Night Review")
                        .font(OathenTypography.headingSmall)
                    if let review, review.isComplete {
                        Text(review.executionSummary)
                            .font(OathenTypography.bodySmall)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("Close the day. Log what you completed and what you missed.")
                            .font(OathenTypography.bodySmall)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                if review?.isComplete != true {
                    Button(action: onTap) {
                        Text("Review")
                            .font(OathenTypography.bodySmall.weight(.medium))
                            .foregroundStyle(.white)
                            .padding(.horizontal, OathenSpacing.md)
                            .padding(.vertical, OathenSpacing.xs)
                            .background(OathenColors.sleep)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        NightReviewCard(
            review: nil,
            state: DailyRoutinePolicy.defaultTodayState(),
            onTap: {}
        )
        NightReviewCard(
            review: NightReview(
                completedCriticalTaskIDs: [UUID()],
                completedAt: Date(),
                updatedAt: Date()
            ),
            state: DailyRoutinePolicy.defaultTodayState(),
            onTap: {}
        )
    }
    .padding()
    .preferredColorScheme(.dark)
}
