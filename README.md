# peon 🔔

Pipe any command through **peon** and get a sound notification when it finishes. Stop babysitting your terminal.

```
nmap -sV 192.168.1.1 | peon
```

Inspired by [PeonPing](https://github.com/PeonPing/peon-ping), designed as a simple CLI pipe for any command.

## Install

**One-liner (Linux / macOS / WSL2):**
```bash
curl -fsSL https://raw.githubusercontent.com/MELTzx/peon/main/install.sh | bash
```

This downloads only the `peon` script + 1 default sound (~36KB). Fast and lightweight.

**Get more sounds (optional, ~4.7MB):**
```bash
peon --download-sounds
```

159 game sounds from Warcraft, Starcraft, TF2, Helldivers, Dota. Only download if you want variety.

**Uninstall:**
```bash
curl -fsSL https://raw.githubusercontent.com/MELTzx/peon/main/uninstall.sh | bash
```

## Usage

```bash
# Default sound (plays automatically)
nmap -sV 192.168.1.1 | peon

# Pick a specific sound (after --download-sounds)
make build | peon -s zug_zug
cargo test | peon -s BattlecruiserOperational

# Random sound from your library
docker build . | peon --random

# Desktop notification + sound
npm install | peon --notify

# Custom message with notification
./long_job.sh | peon --notify -m "job done"

# Silent (no sound, just summary)
rsync -av src/ dest/ | peon --no-sound

# List all installed sounds
peon --list

# Full help
peon --help
```

## SSH + peon

```bash
ssh server "make build" | peon -s zug_zug
ssh server "apt update" | peon --notify -m "apt update done"
```

## How It Works

1. Reads stdin and passes it through to stdout (your output works normally)
2. Detects EOF (upstream command finished)
3. Plays the selected sound via ffplay
4. Optionally sends a desktop notification
5. Prints elapsed time and output size to stderr

## Sounds

peon ships with **1 default sound** (~36KB). The install is intentionally minimal to respect your disk space.

**Want 159 game sounds?** Run:
```bash
peon --download-sounds
```

This downloads ~4.7MB of sounds from Warcraft 2/3, Starcraft, TF2, Helldivers, Dota and more. You only get them if you ask for them.

**Popular sounds (after downloading):**

| Sound | Origin |
|-------|--------|
| `PeonReady1` | WC3 Peon |
| `zug_zug` | Peon classic |
| `goal_complete` | Mission accomplished |
| `BattlecruiserOperational` | Starcraft Terran |
| `approve` | Peon approval |
| `PeonWarcry1` | Orc peon war cry |
| `KerriganReporting` | Starcraft Zerg |
| `wc2sapper-kaboom` | WC2 Sapper |

Run `peon --list` to see all installed sounds.

## Platform Support

| Platform | Audio Method |
|----------|-------------|
| Linux | ffplay (ffmpeg) |
| macOS | afplay |
| WSL2 (WSLg) | paplay |
| WSL2 (older) | PowerShell SoundPlayer |

## Requirements

- **ffmpeg** (required for sound) - `sudo apt install ffmpeg`
- Python 3.6+ (usually pre-installed)

## Options

```
  -s, --sound NAME       Play a specific sound (by name)
  -r, --random           Play a random sound
      --no-sound         Skip sound, only print summary
  -n, --notify           Send desktop notification
  -m, --message TEXT     Custom notification message
      --volume 0-100     Sound volume (default: 80)
  -l, --list             List installed sounds
      --download-sounds  Download all 159 sounds (~4.7MB)
  -v, --version          Show version
  -h, --help             Show help
```

## Credits

- Sounds sourced from [PeonPing/peon-ping](https://github.com/PeonPing/peon-ping) (MIT license)
- Game audio clips are property of their respective owners

## License

MIT
