// Sprint 1 — Watch home screen placeholder.
// WatchConnectivity, HealthKit, WorkoutKit: Sprint 6.
// No real data. No real interactions.
import SwiftUI

struct WatchHomeView: View {
    private let score = 74
    private let hydration = "1.8L"
    private let nextAction = "Placeholder: next critical task"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                scoreRow
                divider
                actionRow
                divider
                hydrationRow
                placeholderBadge
            }
            .padding()
        }
        .navigationTitle("Oathen")
    }

    // MARK: - Sub-views

    private var scoreRow: some View {
        HStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(Color.indigo.opacity(0.25), lineWidth: 4)
                    .frame(width: 36, height: 36)
                Circle()
                    .trim(from: 0, to: 0.74)
                    .stroke(Color.indigo, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 36, height: 36)
                Text("\(score)")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(.indigo)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("Discipline")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.secondary)
                Text("Score")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
            }
        }
    }

    private var actionRow: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("NEXT")
                .font(.system(size: 9, weight: .bold))
                .foregroundStyle(.secondary)
            Text(nextAction)
                .font(.system(size: 12, weight: .medium))
                .lineLimit(2)
        }
    }

    private var hydrationRow: some View {
        HStack(spacing: 8) {
            Button {
                // Quick-log hydration — Sprint 6
            } label: {
                Label("Log Water", systemImage: "drop.fill")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.cyan)
            }
            .buttonStyle(.plain)
            Spacer()
            Text(hydration)
                .font(.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundStyle(.cyan)
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(Color.secondary.opacity(0.2))
            .frame(height: 1)
    }

    private var placeholderBadge: some View {
        Text("SPRINT 1 PLACEHOLDER")
            .font(.system(size: 8, weight: .bold))
            .foregroundStyle(.indigo.opacity(0.6))
            .padding(.top, 4)
    }
}

#Preview {
    WatchHomeView()
}
