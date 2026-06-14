// Sprint 3 — MorningCheckInView.
// Placeholder morning check-in flow. Collects energy, focus, mood, context mode.
// No persistence, no HealthKit, no AI.
import SwiftUI

struct MorningCheckInView: View {
    @Environment(\.dismiss) private var dismiss

    var onComplete: (Double, EnergyLevel, FocusLevel, MoodLevel, String, ContextMode) -> Void

    @State private var sleepHours: Double = 7.5
    @State private var energyLevel: EnergyLevel = .moderate
    @State private var focusLevel: FocusLevel = .moderate
    @State private var mood: MoodLevel = .good
    @State private var mainObstacle: String = ""
    @State private var contextMode: ContextMode = .normal

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    headerView
                } header: {
                    Text("Today's Intentions")
                }

                Section("Sleep") {
                    HStack {
                        Text("Hours slept")
                        Spacer()
                        Text(String(format: "%.1f h", sleepHours))
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    }
                    Slider(value: $sleepHours, in: 3...12, step: 0.5)
                        .tint(OathenColors.sleep)
                }

                Section("Energy & Focus") {
                    Picker("Energy level", selection: $energyLevel) {
                        ForEach(EnergyLevel.allCases, id: \.self) { level in
                            Text(level.displayName).tag(level)
                        }
                    }
                    Picker("Focus level", selection: $focusLevel) {
                        ForEach(FocusLevel.allCases, id: \.self) { level in
                            Text(level.displayName).tag(level)
                        }
                    }
                    Picker("Mood", selection: $mood) {
                        ForEach(MoodLevel.allCases, id: \.self) { level in
                            Text(level.displayName).tag(level)
                        }
                    }
                }

                Section("Context Mode") {
                    Picker("Today's mode", selection: $contextMode) {
                        ForEach(ContextMode.allCases, id: \.self) { mode in
                            Text(mode.displayName).tag(mode)
                        }
                    }
                    Text(contextMode.shortDescription)
                        .font(OathenTypography.bodySmall)
                        .foregroundStyle(.secondary)
                }

                Section("Main Obstacle (optional)") {
                    TextField("What could block you today?", text: $mainObstacle)
                }

                Section {
                    Button(action: complete) {
                        HStack {
                            Spacer()
                            Text("Lock In Commitments")
                                .font(OathenTypography.headingSmall)
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        .padding(.vertical, OathenSpacing.xs)
                    }
                    .listRowBackground(OathenColors.accent)
                }
            }
            .navigationTitle("Morning Check-in")
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

    private var headerView: some View {
        VStack(alignment: .leading, spacing: OathenSpacing.xs) {
            HStack(spacing: OathenSpacing.sm) {
                Image(systemName: "sun.horizon.fill")
                    .foregroundStyle(OathenColors.accent)
                    .font(.title2)
                Text("Set your day in motion.")
                    .font(OathenTypography.headingSmall)
            }
            Text("Your commitments are locked in here. Excuses get logged tonight.")
                .font(OathenTypography.bodySmall)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .listRowBackground(Color.clear)
    }

    private func complete() {
        onComplete(sleepHours, energyLevel, focusLevel, mood, mainObstacle, contextMode)
        dismiss()
    }
}

#Preview {
    MorningCheckInView { _, _, _, _, _, _ in }
        .preferredColorScheme(.dark)
}
