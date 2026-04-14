#!/usr/bin/env bash
# peon installer - pipe any command and get notified when it finishes
# Usage: curl -fsSL https://raw.githubusercontent.com/MELTzx/peon/main/install.sh | bash
set -euo pipefail

BOLD='\033[1m'
GREEN='\033[32m'
YELLOW='\033[33m'
DIM='\033[2m'
RESET='\033[0m'

INSTALL_DIR="${HOME}/.local/bin"
SOUND_DIR="${HOME}/.local/share/peon/sounds"
REPO="MELTzx/peon"
BRANCH="main"

echo -e "${BOLD}${GREEN}peon${RESET} - command completion notifier"
echo ""

# Detect platform
OS="$(uname -s)"
ARCH="$(uname -m)"

echo -e "  Platform: ${YELLOW}${OS}${RESET} (${ARCH})"

# Ensure install dir exists
mkdir -p "${INSTALL_DIR}"
mkdir -p "${SOUND_DIR}"

# Download peon script
echo -e "  Downloading ${GREEN}peon${RESET}..."
if command -v curl &>/dev/null; then
    curl -fsSL "https://raw.githubusercontent.com/${REPO}/${BRANCH}/peon" -o "${INSTALL_DIR}/peon"
elif command -v wget &>/dev/null; then
    wget -q "https://raw.githubusercontent.com/${REPO}/${BRANCH}/peon" -O "${INSTALL_DIR}/peon"
else
    echo -e "  ${RED}Error: curl or wget required${RESET}"
    exit 1
fi
chmod +x "${INSTALL_DIR}/peon"

# Download sound packs
echo -e "  Downloading ${GREEN}sound packs${RESET}..."

PACKS=("complete" "log" "remind" "session_start" "slacking" "terran" "protoss" "zerg" "orc" "wc2-human" "mixed-games")
SUCCESS=0
FAIL=0

for pack in "${PACKS[@]}"; do
    mkdir -p "${SOUND_DIR}/${pack}"
    # Get file list from GitHub API
    files=$(curl -fsSL "https://api.github.com/repos/${REPO}/contents/sounds/${pack}" 2>/dev/null | grep '"name"' | sed 's/.*"name": "//;s/".*//' | grep -E '\.(mp3|wav|ogg|oga)$' || true)
    
    if [ -z "$files" ]; then
        continue
    fi
    
    while IFS= read -r fname; do
        if curl -fsSL "https://raw.githubusercontent.com/${REPO}/${BRANCH}/sounds/${pack}/${fname}" \
            -o "${SOUND_DIR}/${pack}/${fname}" 2>/dev/null; then
            SUCCESS=$((SUCCESS + 1))
        else
            FAIL=$((FAIL + 1))
        fi
    done <<< "$files"
done

echo -e "  Sounds: ${GREEN}${SUCCESS} downloaded${RESET}${DIM}(${FAIL} failed)${RESET}"

# Check PATH
if echo ":${PATH}:" | grep -q ":${INSTALL_DIR}:"; then
    echo -e "  PATH: ${GREEN}${INSTALL_DIR} is in PATH${RESET}"
else
    echo -e "  PATH: ${YELLOW}${INSTALL_DIR} not in PATH${RESET}"
    echo -e "  ${DIM}Add this to your ~/.bashrc or ~/.zshrc:${RESET}"
    echo -e "  ${DIM}  export PATH=\"\${HOME}/.local/bin:\$PATH\"${RESET}"
    
    # Auto-add to shell rc if possible
    SHELL_RC=""
    if [ -n "${ZSH_VERSION:-}" ]; then
        SHELL_RC="${HOME}/.zshrc"
    elif [ -n "${BASH_VERSION:-}" ]; then
        SHELL_RC="${HOME}/.bashrc"
    fi
    
    if [ -n "${SHELL_RC}" ] && [ -f "${SHELL_RC}" ]; then
        if ! grep -q '.local/bin' "${SHELL_RC}"; then
            echo "" >> "${SHELL_RC}"
            echo "# Added by peon installer" >> "${SHELL_RC}"
            echo 'export PATH="${HOME}/.local/bin:${PATH}"' >> "${SHELL_RC}"
            echo -e "  ${GREEN}Auto-added to ${SHELL_RC}${RESET}"
        fi
    fi
fi

# Check for audio player
AUDIO_OK=false
for player in paplay aplay ffplay mpv play powershell.exe afplay; do
    if command -v "$player" &>/dev/null; then
        AUDIO_OK=true
        echo -e "  Audio: ${GREEN}${player} found${RESET}"
        break
    fi
done

if [ "$AUDIO_OK" = false ]; then
    echo -e "  Audio: ${YELLOW}No audio player found${RESET}"
    echo -e "  ${DIM}Install ffmpeg, mpv, or pulseaudio for sound playback${RESET}"
fi

echo ""
echo -e "  ${BOLD}Usage: nmap -sV 10.0.0.1 | peon${RESET}"
echo -e "  ${BOLD}Help:  peon --help${RESET}"
echo -e "  ${DIM}Run 'source ~/.bashrc' (or ~/.zshrc) to update PATH${RESET}"
echo ""
echo -e "  ${GREEN}✓ Installed!${RESET} ${DIM}$(peon --version 2>/dev/null || echo '')${RESET}"
