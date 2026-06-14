// Sprint 3 — MorningCheckInCard component.
// Shows morning check-in status and triggers the check-in sheet.
import SwiftUI

struct MorningCheckInCard: View {
    let checkIn: MorningCheckIn?
    let onTap: () -> Void

    var body: some View {
        OathenCard {
            HStack(spacing: OathenSpacing.md) {
                Image(systemName: checkIn?.isComplete == true ? "checkmark.circle.fill" : "sun.horizon.fill")
                    .foregroundStyle(checkIn?.isComplete == true ? OathenColors.success : OathenColors.accent)
                    .font(.title3)

                VStack(alignment: .leading, spacing: OathenSpacing.xs) {
                    Text("Morning Check-in")
                        .font(OathenTypography.headingSmall)
                    if let checkIn, checkIn.isComplete {
                        HStack(spacing: OathenSpacing.xs) {
                            Text(checkIn.energyLevel.displayName)
                            Text("·")
                                .foregroundStyle(.tertiary)
                            Text(checkIn.focusLevel.displayName + " focus")
                            Text("·")
                                .foregroundStyle(.tertiary)
                            Text(checkIn.mood.displayName + " mood")
                        }
                        .font(OathenTypography.bodySmall)
                        .foregroundStyle(.secondary)
                    } else {
                        Text("Set your intentions and commitments for today.")
                            .font(OathenTypography.bodySmall)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                if checkIn?.isComplete != true {
                    Button(action: onTap) {
                        Text("Start")
                            .font(OathenTypography.bodySmall.weight(.medium))
                            .foregroundStyle(.white)
                            .padding(.horizontal, OathenSpacing.md)
                            .padding(.vertical, OathenSpacing.xs)
                            .background(OathenColors.accent)
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
        MorningCheckInCard(checkIn: nil, onTap: {})
        MorningCheckInCard(
            checkIn: MorningCheckIn(
                energyLevel: .high, focusLevel: .sharp, mood: .good,
                completedAt: Date()
            ),
            onTap: {}
        )
    }
    .padding()
    .preferredColorScheme(.dark)
}
