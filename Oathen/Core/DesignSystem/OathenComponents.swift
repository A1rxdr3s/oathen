// Sprint 1 — Shared placeholder UI components.
// No business logic. No real data.
import SwiftUI

// MARK: - OathenCard

struct OathenCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(.horizontal, OathenSpacing.cardH)
            .padding(.vertical, OathenSpacing.cardV)
            .background(OathenColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: OathenRadius.md))
    }
}

// MARK: - Priority badge

struct PriorityBadge: View {
    enum Priority: String {
        case critical = "Critical"
        case high     = "High"
        case normal   = "Normal"
        case low      = "Low"
        case blocked  = "Blocked"
    }

    let priority: Priority

    private var color: Color {
        switch priority {
        case .critical: OathenColors.critical
        case .high:     OathenColors.high
        case .normal:   OathenColors.normal
        case .low:      OathenColors.low
        case .blocked:  OathenColors.warning
        }
    }

    var body: some View {
        Text(priority.rawValue.uppercased())
            .font(OathenTypography.priorityLabel)
            .foregroundStyle(.white)
            .padding(.horizontal, OathenSpacing.sm)
            .padding(.vertical, OathenSpacing.xs)
            .background(color)
            .clipShape(Capsule())
    }
}

// MARK: - Progress bar

struct OathenProgressBar: View {
    let value: Double   // 0.0 – 1.0
    let color: Color
    let label: String

    var body: some View {
        VStack(alignment: .leading, spacing: OathenSpacing.xs) {
            HStack {
                Text(label)
                    .font(OathenTypography.bodySmall)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(Int(value * 100))%")
                    .font(OathenTypography.monoData)
                    .foregroundStyle(.secondary)
            }
            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: OathenRadius.sm)
                        .fill(color.opacity(0.2))
                        .frame(height: 6)
                    RoundedRectangle(cornerRadius: OathenRadius.sm)
                        .fill(color)
                        .frame(width: max(0, proxy.size.width * value), height: 6)
                }
            }
            .frame(height: 6)
        }
    }
}

// MARK: - Section header

struct OathenSectionHeader: View {
    let title: String

    var body: some View {
        Text(title.uppercased())
            .font(OathenTypography.tagLabel)
            .foregroundStyle(.secondary)
            .tracking(0.6)
    }
}

// MARK: - Score ring (placeholder)

struct ScoreRing: View {
    let progress: Double  // 0.0 – 1.0
    let score: Int?
    let size: CGFloat

    private var strokeWidth: CGFloat { size * 0.1 }

    var body: some View {
        ZStack {
            Circle()
                .stroke(OathenColors.accent.opacity(0.15), lineWidth: strokeWidth)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    OathenColors.accent,
                    style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            if let score {
                Text("\(score)")
                    .font(Font.system(size: size * 0.35, weight: .bold, design: .rounded))
                    .foregroundStyle(OathenColors.accent)
            } else {
                Text("—")
                    .font(Font.system(size: size * 0.35, weight: .bold, design: .rounded))
                    .foregroundStyle(OathenColors.accent.opacity(0.4))
            }
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Platform utility

extension View {
    /// Applies inline navigation bar title on iOS.
    /// iOS 26's liquid-glass nav bar makes the large-title variant consume excessive
    /// vertical space and compresses the usable scroll area between the nav bar
    /// and the floating tab bar. Inline keeps the title native without the height penalty.
    @ViewBuilder
    func largeNavigationTitle() -> some View {
        #if os(iOS)
        self.navigationBarTitleDisplayMode(.inline)
        #else
        self
        #endif
    }
}
