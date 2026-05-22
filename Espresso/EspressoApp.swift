import SwiftUI
import AppKit

@main
struct EspressoApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings { EmptyView() }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?
    let appState = AppState()

    func applicationDidFinishLaunching(_ notification: Notification) {
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 260, height: 300)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(
            rootView: MenuBarView().environmentObject(appState)
        )
        self.popover = popover

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            // Use SF Symbol as template image so it adapts to light/dark menu bar
            let image = NSImage(systemSymbolName: "cup.and.saucer.fill", accessibilityDescription: "Espresso")
            image?.isTemplate = true
            button.image = image

            // Listen for both left and right click
            button.action = #selector(handleClick)
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            button.target = self
        }

        // Keep icon in sync with active state
        appState.onActiveChanged = { [weak self] isActive in
            self?.updateIcon(isActive: isActive)
        }
    }

    @objc func handleClick(_ sender: NSStatusBarButton) {
        let event = NSApp.currentEvent!
        if event.type == .rightMouseUp {
            // Right click — show popover menu
            togglePopover(sender)
        } else {
            // Left click — toggle on/off (indefinite mode)
            if appState.isActive {
                appState.deactivate()
            } else {
                appState.selectedDuration = .indefinite
                appState.toggle()
            }
        }
    }

    func togglePopover(_ sender: NSStatusBarButton) {
        if popover?.isShown == true {
            popover?.performClose(nil)
        } else {
            popover?.show(relativeTo: sender.bounds, of: sender, preferredEdge: .minY)
            popover?.contentViewController?.view.window?.makeKey()
        }
    }

    func updateIcon(isActive: Bool) {
        let symbolName = isActive ? "cup.and.saucer.fill" : "cup.and.saucer"
        let image = NSImage(systemSymbolName: symbolName, accessibilityDescription: "Espresso")
        image?.isTemplate = true
        statusItem?.button?.image = image
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ app: NSApplication) -> Bool {
        return false
    }
}
