# peon 🔔

Pipe any command through **peon** and get a sound notification when it finishes. Stop babysitting your terminal.

```
nmap -sV 192.168.1.1 | peon
```

Inspired by [PeonPing](https://github.com/PeonPing/peon-ping) - but designed as a simple CLI pipe, not a daemon. Works with any command, any OS.

## Install

**One-liner (Linux / macOS / WSL2):**
```bash
curl -fsSL https://raw.githubusercontent.com/MELTzx/peon/main/install.sh | bash
```

**Or with wget:**
```bash
wget -qO- https://raw.githubusercontent.com/MELTzx/peon/main/install.sh | bash
```

**Manual install:**
```bash
mkdir -p ~/.local/bin
curl -fsSL https://raw.githubusercontent.com/MELTzx/peon/main/peon -o ~/.local/bin/peon
chmod +x ~/.local/bin/peon
```

**Uninstall:**
```bash
curl -fsSL https://raw.githubusercontent.com/MELTzx/peon/main/uninstall.sh | bash
```

## Usage

```bash
# Basic - plays "Zug Zug" when nmap finishes
nmap -sV 192.168.1.1 | peon

# Random Orc voice
make build | peon --pack orc

# Random Terran sound (Starcraft)
docker build . | peon --pack terran

# Desktop notification + sound
cargo test | peon --notify

# Custom message
./long_job.sh | peon --notify -m "job done"

# Custom sound file
npm install | peon --sound ~/bell.wav

# Silent (no sound, just stderr summary)
rsync -av src/ dest/ | peon --no-sound

# Random sound from the big grab-bag pack
pip install . | peon --pack mixed

# List all sound packs
peon --list

# Full help
peon --help
```

## Shell Aliases

Add to your `~/.bashrc` or `~/.zshrc`:

```bash
alias pp='peon --pack orc --notify'
alias ppp='peon --pack mixed'
alias ppc='peon --pack complete'
```

## SSH + peon

```bash
# Works perfectly - peon runs locally, sound plays locally
ssh server "make build" | peon --pack orc
ssh server "apt update" | peon --notify -m "apt update done"
```

## Sound Packs

| Pack | Count | Description |
|------|-------|-------------|
| `complete` | 4 | Peon completion sounds ("Zug Zug", "Goal Complete") |
| `log` | 5 | "Approve", "Work Work", "Proud", "Not Bad", "Okie Dokie" |
| `remind` | 8 | "Type Type Type", "Code Review Hard", "Human Weak" |
| `slacking` | 4 | "Falling Behind", "Disappointed", "Half Day" |
| `session` | 3 | "New Day", "Human Back", "Know The Rules" |
| `terran` | 7 | Starcraft Terran unit voices |
| `protoss` | 1 | Starcraft Protoss unit voices |
| `zerg` | 1 | Starcraft Zerg unit voices |
| `orc` | 17 | Warcraft 3 Orc/Peon voices |
| `wc2` | 12 | Warcraft 2 Human/Sapper voices |
| `mixed` | 97 | Starcraft, TF2, Helldivers, Dota sounds |

Run `peon --list` to see every sound in each pack.

## How It Works

1. Reads stdin and passes it through to stdout (your output works normally)
2. Detects EOF (upstream command finished)
3. Plays a random sound from the selected pack
4. Optionally sends a desktop notification
5. Prints elapsed time and output size to stderr

## Platform Support

| Platform | Audio Method |
|----------|-------------|
| Linux | paplay, aplay, ffplay, mpv, or SoX |
| macOS | afplay |
| WSL2 (WSLg) | paplay (native) |
| WSL2 (older) | PowerShell SoundPlayer or Console.Beep |
| Any (fallback) | Terminal bell `\a` |

## Requirements

- **ffmpeg** (required for sound playback on most systems) - `sudo apt install ffmpeg`
- Python 3.6+ (usually pre-installed)
- No other dependencies

## Options

```
  -s, --sound PATH     Custom sound file to play
  -p, --pack PACK      Random sound from a sound pack
  -r, --random         Random sound from the 'complete' pack
      --no-sound       Skip sound, only print summary
  -n, --notify         Send desktop notification (notify-send)
  -m, --message TEXT   Custom notification message (with --notify)
      --volume 0-100   Sound volume (default: 80)
      --beep           Force generate a beep (no sound pack needed)
  -e, --exit-code      Read exit code from PEON_EXIT env var
  -l, --list           List all sound packs and their sounds
  -h, --help           Show help
```

## Credits

- Sound packs sourced from [PeonPing/peon-ping](https://github.com/PeonPing/peon-ping) (MIT license)
- Warcraft, Starcraft, TF2, Helldivers, Dota sounds are property of their respective owners

## License

MIT
