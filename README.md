# Espresso ☕

For healthy adults, the safe recommended dietary intake (RDI) of caffeine is up to 400 mg per day. What if you wanted more?

Keeps your Mac awake and your status green on your favorite communication applications (Teams).

Like [KeepingYouAwake](https://github.com/newmarcel/KeepingYouAwake), but with a mouse jiggle to prevent collaboration apps from flipping you to Away.

---

## Download

Grab the latest `Espresso.dmg` from [Releases](../../releases), open it, and drag to Applications.

> First launch: macOS may flag it since it's unsigned. Right-click → Open to get past that once.

On first use of mouse jiggle you'll get a prompt for Accessibility permission — that's expected.

---

## What it does

- Runs `caffeinate` as a sub process to prevent sleep
- Moves the mouse randomly every 5–45 seconds to maintain active presence in Teams, Webex, Slack, etc.
- Sits in the menu bar, stays out of your way

---

## Building

Xcode 15+, macOS 13+.

```bash
git clone https://github.com/treybrown/espresso
open Espresso.xcodeproj
```

Tag a release to trigger the GitHub Actions build:

```bash
git tag v1.0.0 && git push origin v1.0.0
```

---

MIT License
