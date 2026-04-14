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

**Uninstall:**
```bash
curl -fsSL https://raw.githubusercontent.com/MELTzx/peon/main/uninstall.sh | bash
```

## Usage

```bash
# Default sound (PeonReady1)
nmap -sV 192.168.1.1 | peon

# Pick a specific sound
make build | peon -s zug_zug
cargo test | peon -s BattlecruiserOperational

# Random sound from the library
docker build . | peon --random

# Desktop notification + sound
npm install | peon --notify

# Custom message with notification
./long_job.sh | peon --notify -m "job done"

# Silent (no sound, just summary)
rsync -av src/ dest/ | peon --no-sound

# List all 159 available sounds
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

## Popular Sounds

| Sound | Origin |
|-------|--------|
| `PeonReady1` | WC3 Peon (default) |
| `zug_zug` | Peon classic |
| `goal_complete` | Mission accomplished |
| `BattlecruiserOperational` | Starcraft Terran |
| `approve` | Peon approval |
| `impressed` | Peon impressed |
| `PeonWarcry1` | Orc peon war cry |
| `KerriganReporting` | Starcraft Zerg |
| `wc2sapper-kaboom` | WC2 Sapper |

Run `peon --list` to see all 159 sounds.

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
  -s, --sound NAME     Play a specific sound (by name)
  -r, --random         Play a random sound
      --no-sound       Skip sound, only print summary
  -n, --notify         Send desktop notification
  -m, --message TEXT   Custom notification message
      --volume 0-100   Sound volume (default: 80)
  -l, --list           List all available sounds
  -v, --version        Show version
  -h, --help           Show help
```

## Credits

- Sounds sourced from [PeonPing/peon-ping](https://github.com/PeonPing/peon-ping) (MIT license)
- Game audio clips are property of their respective owners

## License

MIT
