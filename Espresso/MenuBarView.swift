import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            statusHeader
            Divider()
            durationPicker
            Divider()
            jiggleToggle
            Divider()
            actionButtons
        }
        .frame(width: 260)
    }

    // MARK: - Sections

    private var statusHeader: some View {
        HStack(alignment: .center, spacing: 10) {
            Circle()
                .fill(state.isActive ? Color.green : Color.secondary.opacity(0.4))
                .frame(width: 8, height: 8)
            VStack(alignment: .leading, spacing: 3) {
                Text(state.statusLine)
                    .font(.system(size: 13, weight: .medium))
                if state.isActive {
                    Text(state.jigglesLine)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }

    private var durationPicker: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("DURATION")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.secondary)
                .padding(.horizontal, 14)
                .padding(.top, 10)

            HStack(spacing: 6) {
                ForEach(SleepDuration.allCases) { duration in
                    Button(duration.rawValue) {
                        state.selectedDuration = duration
                    }
                    .buttonStyle(DurationButtonStyle(selected: state.selectedDuration == duration))
                }
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 10)
        }
    }

    private var jiggleToggle: some View {
        VStack(alignment: .leading, spacing: 2) {
            Toggle(isOn: $state.jiggleEnabled) {
                Label("Stay connected", systemImage: "antenna.radiowaves.left.and.right")
                    .font(.system(size: 13))
            }
            .toggleStyle(.switch)
            .controlSize(.small)
            .onChange(of: state.jiggleEnabled) { state.syncJiggler() }
            .padding(.horizontal, 14)
            .padding(.top, 10)

            Text("Maintains active presence in communication apps")
                .font(.system(size: 11))
                .foregroundColor(.secondary)
                .padding(.horizontal, 14)
                .padding(.bottom, 10)
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 0) {
            Button(state.isActive ? "Deactivate" : "Activate") {
                state.toggle()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .buttonStyle(.plain)
            .font(.system(size: 13))

            Button("Quit Espresso") {
                NSApplication.shared.terminate(nil)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 14)
            .padding(.bottom, 12)
            .buttonStyle(.plain)
            .font(.system(size: 13))
            .foregroundColor(.secondary)
        }
    }
}

// MARK: - Duration button style

struct DurationButtonStyle: ButtonStyle {
    let selected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 12))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 5)
            .background(selected ? Color.accentColor.opacity(0.15) : Color.clear)
            .foregroundColor(selected ? .accentColor : .secondary)
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(selected ? Color.accentColor : Color.secondary.opacity(0.35), lineWidth: 0.5)
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
    }
}
