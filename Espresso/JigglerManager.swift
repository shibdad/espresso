import CoreGraphics
import AppKit
import Foundation

class JigglerManager {
    private var timer: DispatchSourceTimer?

    private var nextInterval: TimeInterval {
        TimeInterval.random(in: 5...45)
    }

    func start(onJiggle: @escaping () -> Void) {
        stop()
        scheduleNext(onJiggle: onJiggle)
    }

    func stop() {
        timer?.cancel()
        timer = nil
    }

    private func scheduleNext(onJiggle: @escaping () -> Void) {
        let t = DispatchSource.makeTimerSource(queue: .global(qos: .background))
        t.schedule(deadline: .now() + nextInterval)
        t.setEventHandler { [weak self] in
            guard let self else { return }
            self.jiggle()
            DispatchQueue.main.async { onJiggle() }
            self.scheduleNext(onJiggle: onJiggle)
        }
        t.resume()
        timer = t
    }

    private func jiggle() {
        let currentPos = NSEvent.mouseLocation
        guard let screen = NSScreen.main else { return }

        let screenHeight = screen.frame.height
        let origin = CGPoint(x: currentPos.x, y: screenHeight - currentPos.y)

        // Random direction and distance between 20-100px
        let angle = Double.random(in: 0..<(2 * .pi))
        let distance = Double.random(in: 20...100)
        let target = CGPoint(
            x: origin.x + distance * cos(angle),
            y: origin.y + distance * sin(angle)
        )

        CGWarpMouseCursorPosition(target)
        Thread.sleep(forTimeInterval: 0.1)
        CGWarpMouseCursorPosition(origin)
    }
}
