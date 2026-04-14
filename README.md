# Peon

<div align="center">
  <img src="peon-banner.png" alt="peon" width="600">
</div>

<br>

Get a sound notification when your command finishes. Stop babysitting your terminal.

```bash
nmap -sV 192.168.1.1 && peon
```

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/MELTzx/peon/main/install.sh | bash
```

Downloads `peon` + 1 default sound (~36KB). That's it.

**Want 159 game sounds?**
```bash
peon --download-sounds
```

**Uninstall:**
```bash
curl -fsSL https://raw.githubusercontent.com/MELTzx/peon/main/uninstall.sh | bash
```

## Usage

```bash
# After a command finishes
nmap -sV 192.168.1.1 && peon

# Piped (passes output through)
nmap -sV 192.168.1.1 | peon

# Pick a specific sound
make build && peon -s zug_zug

# Random sound
docker build . | peon --random

# Over SSH (sound plays locally)
ssh server "make build" && peon

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
