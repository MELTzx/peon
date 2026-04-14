# peon 🔔

Pipe any command through **peon** and get a sound notification when it finishes. Stop babysitting your terminal.

```
nmap -sV 192.168.1.1 | peon
```

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/MELTzx/peon/main/install.sh | bash
```

Downloads the `peon` script + 1 default sound (~36KB). That's it.

**Want 159 game sounds?**
```bash
peon --download-sounds
```

Warcraft, Starcraft, TF2, Helldivers, Dota sounds (~4.7MB). Only if you want them.

**Uninstall:**
```bash
curl -fsSL https://raw.githubusercontent.com/MELTzx/peon/main/uninstall.sh | bash
```

## Usage

```bash
# Default sound
nmap -sV 192.168.1.1 | peon

# Pick a specific sound
make build | peon -s zug_zug
cargo test | peon -s BattlecruiserOperational

# Random sound
docker build . | peon --random

# Custom sound file
./long_job.sh | peon -s ~/bell.wav

# Over SSH
ssh server "make build" | peon -s zug_zug

# List all sounds
peon --list
```

## Options

```
  -s, --sound NAME       Play a specific sound
  -r, --random           Play a random sound
  -l, --list             List installed sounds
      --download-sounds  Download all 159 sounds (~4.7MB)
  -v, --version          Show version
  -h, --help             Show help
```

## Requirements

- **ffmpeg** - `sudo apt install ffmpeg`
- Python 3.6+

## Credits

Sounds from [PeonPing/peon-ping](https://github.com/PeonPing/peon-ping) (MIT). Game audio is property of respective owners.

## License

MIT
