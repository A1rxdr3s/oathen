// Sprint 3 — DisciplineScoreCard component.
// Displays the live discipline score ring, label, and context mode.
import SwiftUI

struct DisciplineScoreCard: View {
    let score: DisciplineScore
    let contextMode: ContextMode

    private var scoreColor: Color {
        switch score.totalScore {
        case 80...100: OathenColors.scoreHigh
        case 50..<80:  OathenColors.scoreMid
        default:       OathenColors.scoreLow
        }
    }

    var body: some View {
        OathenCard {
            HStack(alignment: .center, spacing: OathenSpacing.lg) {
                VStack(alignment: .leading, spacing: OathenSpacing.xs) {
                    Text("Discipline Score")
                        .font(OathenTypography.headingSmall)
                        .foregroundStyle(.secondary)
                    Text("\(score.totalScore)")
                        .font(OathenTypography.scoreDisplay)
                        .foregroundStyle(scoreColor)
                        .contentTransition(.numericText())
                        .animation(.easeInOut(duration: 0.3), value: score.totalScore)
                    HStack(spacing: OathenSpacing.xs) {
                        Text(score.label)
                            .font(OathenTypography.bodySmall)
                            .foregroundStyle(scoreColor)
                        Text("·")
                            .foregroundStyle(.tertiary)
                        Text(contextMode.displayName)
                            .font(OathenTypography.bodySmall)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                ScoreRing(
                    progress: Double(score.totalScore) / 100.0,
                    score: score.totalScore,
                    size: 80
                )
            }
        }
    }
}

#Preview {
    DisciplineScoreCard(
        score: DisciplineScore(totalScore: 74, breakdown: .perfect, contextMode: .normal),
        contextMode: .normal
    )
    .padding()
    .preferredColorScheme(.dark)
}
