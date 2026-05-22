# Espresso ☕

Keeps your Mac awake and your Teams/Webex status green.

Like [KeepingYouAwake](https://github.com/newmarcel/KeepingYouAwake), but with a mouse jiggle to prevent collaboration apps from flipping you to Away.

---

## Download

Grab the latest `Espresso.dmg` from [Releases](../../releases), open it, and drag to Applications.

> First launch: macOS may flag it since it's unsigned. Right-click → Open to get past that once.

On first use of mouse jiggle you'll get a prompt for Accessibility permission — that's expected.

---

## What it does

- Runs `caffeinate` in the background to prevent sleep
- Moves the mouse 1px every 4 minutes so Teams/Webex doesn't go idle
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
