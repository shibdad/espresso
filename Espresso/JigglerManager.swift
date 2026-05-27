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

        // Random direction and distance
        let angle = Double.random(in: 0..<(2 * .pi))
        let distance = Double.random(in: 20...100)
        let target = CGPoint(
            x: origin.x + distance * cos(angle),
            y: origin.y + distance * sin(angle)
        )

        // Drift out slowly — like a hand lazily moving
        moveSmooth(from: origin, to: target, steps: 40, duration: 0.6)

        // Pause at destination like a real hand would
        Thread.sleep(forTimeInterval: Double.random(in: 0.1...0.4))

        // Return along a slightly different arc
        let wobble = Double.random(in: -0.4...0.4)
        let midPoint = CGPoint(
            x: (origin.x + target.x) / 2 + distance * 0.2 * cos(angle + .pi / 2 + wobble),
            y: (origin.y + target.y) / 2 + distance * 0.2 * sin(angle + .pi / 2 + wobble)
        )
        moveSmooth(from: target, to: midPoint, steps: 20, duration: 0.25)
        moveSmooth(from: midPoint, to: origin, steps: 20, duration: 0.25)
    }

    // Ease-in-out smooth movement between two points
    private func moveSmooth(from a: CGPoint, to b: CGPoint, steps: Int, duration: TimeInterval) {
        let stepDelay = duration / Double(steps)
        for i in 1...steps {
            let t = Double(i) / Double(steps)
            // Ease-in-out: slow at start and end, faster in the middle
            let eased = t < 0.5
                ? 2 * t * t
                : 1 - pow(-2 * t + 2, 2) / 2

            let x = a.x + (b.x - a.x) * eased
            let y = a.y + (b.y - a.y) * eased
            CGWarpMouseCursorPosition(CGPoint(x: x, y: y))
            Thread.sleep(forTimeInterval: stepDelay)
        }
    }
}
