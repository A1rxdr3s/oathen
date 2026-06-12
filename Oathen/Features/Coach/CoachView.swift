// Sprint 1 — Coach tab: AI Coach conversation placeholder.
// No AI logic. No API calls. No provider connections.
// AI Coach implementation: Sprint 7.
import SwiftUI

struct CoachView: View {
    @State private var inputText = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                conversationArea
                composerBar
            }
            .background(OathenColors.screenBackground)
            .navigationTitle("Coach")
            .largeNavigationTitle()
        }
    }

    private var conversationArea: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: OathenSpacing.lg) {
                sprintBanner

                CoachBubble(
                    role: .coach,
                    text: "AI Coach connects in Sprint 7. This is where strict, contextual coaching will appear — based on your goals, tasks, score, and patterns."
                )
                CoachBubble(
                    role: .coach,
                    text: "The Coach will confront repeated excuses, detect weak patterns, and generate recovery plans. It will never be a cheerleader."
                )
                CoachBubble(
                    role: .user,
                    text: "Example user message — placeholder only."
                )
                CoachBubble(
                    role: .coach,
                    text: "Provider-agnostic AI abstraction layer (OpenAI, Claude, Gemini) is designed. Implementation begins Sprint 7."
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
                    Text("AI Coach — Sprint 7")
                        .font(OathenTypography.headingSmall)
                        .foregroundStyle(OathenColors.accent)
                    Text("Strict · Context-aware · Not a chatbot")
                        .font(OathenTypography.bodySmall)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                PlaceholderTag()
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
