# Herdr Mobile themes

Selectable in **Settings → Appearance**. Default is **Claude**.

Source of truth: `lib/theme/app_theme.dart`.

## Claude (default)

Claude Code–inspired charcoal UI with a soft clay / coral accent. No Material teal or bright purple chrome.

| Token | Hex | Role |
|-------|-----|------|
| `bg` / `surfaceContainerLowest` | `#0D0D0D` | Near-black scaffold / terminal backdrop |
| `surface` | `#1A1A1A` | AppBar, cards, nav bar |
| `surfaceHigh` | `#242424` | Elevated chips / containers |
| `surfaceHighest` | `#2C2C2C` | Highest containers |
| `surfaceLow` | `#141414` | Input bar / low containers |
| `accent` / `primary` | `#D97757` | Clay orange — primary buttons, selected nav, working status |
| `onAccent` | `#1A1A1A` | Text on primary |
| `text` / `onSurface` | `#E8E4DF` | Warm off-white body text |
| `textMuted` | `#A8A29E` | Secondary labels |
| `secondary` | `#8A8580` | Muted gray accents |
| `outline` | `#3A3A3A` | Soft borders |
| `outlineVariant` | `#2A2A2A` | Hairline borders |
| `error` | `#C45C5C` | Muted red (Ctrl-C softkey, errors) |
| `tertiary` | `#C4A35A` | Soft amber (blocked) |
| `statusIdle` | `#6B9B76` | Muted green |
| `statusWorking` | `#D97757` | Same as accent |
| `statusBlocked` | `#C4A35A` | Soft amber |
| `statusError` | `#C45C5C` | Muted red |
| `terminalBg` | `#0D0D0D` | ANSI pane |
| `terminalFg` | `#E8E4DF` | Default terminal text |
| `modeLan` | `#6B8CAE` | Soft blue |
| `modeTailscale` | `#9A7B9A` | Muted mauve (not bright purple) |
| `modeFunnel` | `#D97757` | Accent |

## Teal (legacy)

Previous default: `ColorScheme.fromSeed(seedColor: Colors.teal, brightness: dark)` with brighter Material status/mode colors. Keep for users who prefer the old look.

## Wiring

- `AppSettings.themeId` → `"claude"` \| `"teal"` (SharedPreferences)
- `MaterialApp.theme` rebuilt via `ListenableBuilder` on `AppSettings`
- Status chips / transport badges / terminal pane read `HerdrColors` theme extension
