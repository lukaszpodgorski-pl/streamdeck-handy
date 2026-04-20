# Handy for Stream Deck

Control [Handy](https://github.com/cjpais/Handy) dictation from your Elgato Stream Deck.

Handy is a local-first, open-source speech-to-text utility. This plugin turns any Stream Deck key into a push-button for starting, stopping, and cancelling dictation — without touching keyboard shortcuts.

---

## Features

| Action | What it does | Handy CLI flag |
|---|---|---|
| **Toggle dictation** | Start / stop a recording + transcription | `--toggle-transcription` |
| **Cancel dictation** | Abort the current recording | `--cancel` |
| **Toggle with post-processing** | Start / stop dictation with LLM post-processing | `--toggle-post-process` |

All actions spawn the Handy binary as a detached process, which signals the running Handy instance. No keyboard emulation, no background daemon from the plugin side.

---

## Requirements

- **Stream Deck app** 6.4 or later (tested on 7.0.3)
- **Handy** v0.7.6 or later — [download](https://github.com/cjpais/Handy/releases)
- **OS:** Windows 10+ or macOS 12+ (Linux is not supported by the Stream Deck app itself)

The plugin ships its own Node.js 20 runtime via the Stream Deck app — no Node install required on the end-user machine.

---

## Installation

### From Stream Deck Marketplace (recommended)

_Coming soon — submission pending review._

### Manual

1. Download `pl.lukaszpodgorski.handy.streamDeckPlugin` from the [latest release](https://github.com/lukaszpodgorski/streamdeck-handy/releases).
2. Double-click the file — the Stream Deck app will install the plugin automatically.
3. Open the Stream Deck app, find the **Handy** category in the right-hand panel, and drag any action onto a key.

---

## Usage

1. Make sure Handy is running (or at least installed).
2. Press the configured key on your Stream Deck.
3. Handy picks up the CLI command and starts / stops / cancels dictation.

### Property inspector

Each action has an optional **Handy path** field. Leave it empty for auto-detection. Fill it in only if you installed Handy in a non-standard location.

### Handy binary auto-detection

The plugin probes these paths in order, falling back to `handy` on your `PATH` (Linux only):

| Platform | Paths checked |
|---|---|
| **Windows** | `C:\Program Files\Handy\handy.exe` → `%LOCALAPPDATA%\Programs\Handy\handy.exe` → `%LOCALAPPDATA%\Handy\handy.exe` |
| **macOS** | `/Applications/Handy.app/Contents/MacOS/Handy` → `~/Applications/Handy.app/Contents/MacOS/Handy` |
| **Linux** | `/usr/bin/handy` → `/usr/local/bin/handy` → `~/.local/bin/handy` → `$PATH` |

If none match, the action shows an alert icon and logs `Handy binary not found`.

---

## Known limitations

- **No live state sync.** Handy's CLI only fires "toggle" — the Stream Deck key can't know whether Handy is currently recording. The icon reflects the *last press*, not the real state.
- **No true push-to-talk.** Same reason — holding the key and releasing it can desync with Handy's internal state if dictation was started some other way.

Both are solvable by adding a local WebSocket server to Handy (see [Roadmap](#roadmap)).

---

## Roadmap

- **v0.2** — real icons, screenshots, Marketplace submission
- **v1.0** — bidirectional sync: when [cjpais/Handy#211](https://github.com/cjpais/Handy/discussions/211) (local control API) lands upstream, the plugin will switch from CLI spawning to a WebSocket client. That unlocks:
  - live `idle` / `recording` / `transcribing` icon state
  - real push-to-talk
  - optional toast notifications on transcription complete

---

## Development

### Setup

```powershell
git clone https://github.com/lukaszpodgorski/streamdeck-handy
cd streamdeck-handy
npm install
```

### Live development

```powershell
npx streamdeck link pl.lukaszpodgorski.handy.sdPlugin
npm run watch
```

`npm run watch` runs Rollup in watch mode and restarts the plugin in Stream Deck on every change. Logs land in `pl.lukaszpodgorski.handy.sdPlugin/logs/pl.lukaszpodgorski.handy.0.log`.

### Build & pack a release

```powershell
npm run build
npx streamdeck validate pl.lukaszpodgorski.handy.sdPlugin
npx streamdeck pack pl.lukaszpodgorski.handy.sdPlugin
```

The packer outputs a `.streamDeckPlugin` installer file.

### Regenerate placeholder icons

```powershell
powershell -ExecutionPolicy Bypass -File scripts\generate-icons.ps1
```

Placeholder PNGs are used until production-grade icons ship. Replace the files in `pl.lukaszpodgorski.handy.sdPlugin/imgs/` with final artwork (transparent background, white line art per [Elgato's style guide](https://docs.elgato.com/streamdeck/sdk/guides/icons)).

### Project structure

```
src/
├── plugin.ts                    # entry point, registers actions
├── handy-binary.ts              # cross-platform binary resolver
└── actions/
    ├── toggle-dictation.ts
    ├── cancel-dictation.ts
    └── toggle-post-process.ts

pl.lukaszpodgorski.handy.sdPlugin/
├── manifest.json                # plugin metadata
├── bin/plugin.js                # built output (gitignored)
├── imgs/                        # icons + state images
├── ui/toggle-dictation.html     # property inspector
└── logs/                        # runtime logs (gitignored)

scripts/
└── generate-icons.ps1           # placeholder icon generator
```

---

## Credits

- [Handy](https://github.com/cjpais/Handy) by **cjpais** — the speech-to-text app this plugin drives.
- [Elgato Stream Deck SDK](https://docs.elgato.com/streamdeck/sdk/) and [sdpi-components](https://sdpi-components.dev/).

Author: **Łukasz Podgórski** · [lukaszpodgorski.pl](https://lukaszpodgorski.pl)

---

## License

[MIT](LICENSE) — matches Handy's license. Do whatever you want with this.
