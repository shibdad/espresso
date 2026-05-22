import Foundation
import Combine

enum SleepDuration: String, CaseIterable, Identifiable {
    case thirtyMin  = "30m"
    case oneHour    = "1h"
    case twoHours   = "2h"
    case indefinite = "∞"

    var id: String { rawValue }

    var seconds: Int? {
        switch self {
        case .thirtyMin:  return 1800
        case .oneHour:    return 3600
        case .twoHours:   return 7200
        case .indefinite: return nil
        }
    }
}

class AppState: ObservableObject {
    @Published var isActive = false {
        didSet { onActiveChanged?(isActive) }
    }
    @Published var jiggleEnabled = true
    @Published var selectedDuration: SleepDuration = .oneHour
    @Published var jiggleCount = 0
    @Published var elapsedSeconds = 0

    // Callback so AppDelegate can update the menu bar icon
    var onActiveChanged: ((Bool) -> Void)?

    private let caffeinate = CaffeinateManager()
    private let jiggler = JigglerManager()
    private var tickTimer: AnyCancellable?

    var remainingSeconds: Int? {
        guard let total = selectedDuration.seconds else { return nil }
        return max(0, total - elapsedSeconds)
    }

    var statusLine: String {
        guard isActive else { return "Inactive" }
        if let rem = remainingSeconds {
            let m = rem / 60
            let s = rem % 60
            return String(format: "Active — %d:%02d remaining", m, s)
        }
        let m = elapsedSeconds / 60
        return "Active — \(m)m elapsed"
    }

    var jigglesLine: String {
        jiggleCount == 0 ? "No jiggle yet" : "Jiggled \(jiggleCount)×"
    }

    func toggle() {
        isActive ? deactivate() : activate()
    }

    func activate() {
        isActive = true
        elapsedSeconds = 0
        caffeinate.start(duration: selectedDuration.seconds)
        if jiggleEnabled {
            jiggler.start { [weak self] in
                DispatchQueue.main.async { self?.jiggleCount += 1 }
            }
        }
        tickTimer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                self.elapsedSeconds += 1
                if let total = self.selectedDuration.seconds, self.elapsedSeconds >= total {
                    self.deactivate()
                }
            }
    }

    func deactivate() {
        isActive = false
        tickTimer?.cancel()
        tickTimer = nil
        caffeinate.stop()
        jiggler.stop()
    }

    func syncJiggler() {
        guard isActive else { return }
        if jiggleEnabled {
            jiggler.start { [weak self] in
                DispatchQueue.main.async { self?.jiggleCount += 1 }
            }
        } else {
            jiggler.stop()
        }
    }
}
