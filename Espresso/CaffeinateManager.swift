import Foundation

class CaffeinateManager {
    private var process: Process?

    func start(duration: Int?) {
        stop()
        let proc = Process()
        proc.executableURL = URL(fileURLWithPath: "/usr/bin/caffeinate")
        var args = ["-disu"]
        if let d = duration {
            args += ["-t", String(d)]
        }
        proc.arguments = args
        try? proc.run()
        process = proc
    }

    func stop() {
        process?.terminate()
        process = nil
    }
}
