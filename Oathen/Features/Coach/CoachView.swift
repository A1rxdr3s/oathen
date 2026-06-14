// Sprint 1 — Coach tab: AI Coach conversation placeholder.
// No AI logic. No API calls. No provider connections.
// AI Coach implementation: Sprint 7.
import SwiftUI

struct CoachView: View {
    @State private var inputText = ""

    var body: some View {
        conversationArea
            .safeAreaInset(edge: .bottom, spacing: 0) {
                composerBar
            }
            .background(OathenColors.screenBackground.ignoresSafeArea())
    }

    private var conversationArea: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: OathenSpacing.lg) {
                sprintBanner

                CoachBubble(
                    role: .coach,
                    text: "This is where strict, context-aware accountability lives — based on your goals, tasks, score, and daily patterns."
                )
                CoachBubble(
                    role: .coach,
                    text: "The Coach confronts repeated excuses, detects weak patterns, and generates recovery plans. It will never be a cheerleader."
                )
                CoachBubble(
                    role: .user,
                    text: "Example user message — not active yet."
                )
                CoachBubble(
                    role: .coach,
                    text: "AI connection arrives after the daily routine is stable. Today already uses local rule-based nudges."
                )
            }
            .padding(.horizontal, OathenSpacing.screenHorizontal)
            .padding(.vertical, OathenSpacing.lg)
        }
    }

    private var sprintBanner: some View {
        OathenCard {
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundStyle(OathenColors.accent)
                VStack(alignment: .leading, spacing: OathenSpacing.xs) {
                    Text("Accountability Coach")
                        .font(OathenTypography.headingSmall)
                        .foregroundStyle(OathenColors.accent)
                    Text("Strict · Context-aware · Not a chatbot")
                        .font(OathenTypography.bodySmall)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
        }
    }

    private var composerBar: some View {
        HStack(spacing: OathenSpacing.sm) {
            TextField("Message the Coach…", text: $inputText)
                .font(OathenTypography.bodyMedium)
                .padding(.horizontal, OathenSpacing.md)
                .padding(.vertical, OathenSpacing.sm)
                .background(OathenColors.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: OathenRadius.pill))
                .disabled(true)

            Button {
                // No-op — Sprint 7
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundStyle(OathenColors.accent.opacity(0.4))
            }
            .disabled(true)
        }
        .padding(.horizontal, OathenSpacing.screenHorizontal)
        .padding(.vertical, OathenSpacing.sm)
        .background(OathenColors.cardBackground.opacity(0.8))
    }
}

// MARK: - Chat bubble

private struct CoachBubble: View {
    enum Role { case coach, user }

    let role: Role
    let text: String

    var isCoach: Bool { role == .coach }

    var body: some View {
        HStack {
            if !isCoach { Spacer(minLength: OathenSpacing.xxxl) }
            Text(text)
                .font(OathenTypography.bodyMedium)
                .foregroundStyle(isCoach ? AnyShapeStyle(.primary) : AnyShapeStyle(Color.white))
                .padding(.horizontal, OathenSpacing.md)
                .padding(.vertical, OathenSpacing.sm)
                .background(isCoach ? OathenColors.cardBackground : OathenColors.accent)
                .clipShape(RoundedRectangle(cornerRadius: OathenRadius.lg))
            if isCoach { Spacer(minLength: OathenSpacing.xxxl) }
        }
    }
}

#Preview {
    CoachView()
        .preferredColorScheme(.dark)
}
