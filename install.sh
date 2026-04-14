#!/usr/bin/env bash
# peon installer - pipe any command and get notified when it finishes
# Usage: curl -fsSL https://raw.githubusercontent.com/MELTzx/peon/main/install.sh | bash
set -euo pipefail

BOLD='\033[1m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
DIM='\033[2m'
RESET='\033[0m'

INSTALL_DIR="${HOME}/.local/bin"
SOUND_DIR="${HOME}/.local/share/peon/sounds"
REPO="MELTzx/peon"
BRANCH="main"

echo -e "${BOLD}${GREEN}peon${RESET} - command completion notifier"
echo ""

echo -e "  Platform: ${YELLOW}$(uname -s)${RESET} ($(uname -m))"

# Ensure dirs exist
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

# Download sounds (all flat in sounds/ dir)
echo -e "  Downloading ${GREEN}sounds${RESET}..."

SUCCESS=0
FAIL=0

# Get file list from GitHub API
files=$(curl -fsSL "https://api.github.com/repos/${REPO}/contents/sounds" 2>/dev/null \
    | grep '"name"' | sed 's/.*"name": "//;s/".*//' \
    | grep -E '\.(mp3|wav|ogg|oga)$' || true)

if [ -n "$files" ]; then
    while IFS= read -r fname; do
        if curl -fsSL "https://raw.githubusercontent.com/${REPO}/${BRANCH}/sounds/${fname}" \
            -o "${SOUND_DIR}/${fname}" 2>/dev/null; then
            SUCCESS=$((SUCCESS + 1))
        else
            FAIL=$((FAIL + 1))
        fi
    done <<< "$files"
fi

echo -e "  Sounds: ${GREEN}${SUCCESS} downloaded${RESET}${DIM}(${FAIL} failed)${RESET}"

# Check PATH
if echo ":${PATH}:" | grep -q ":${INSTALL_DIR}:"; then
    echo -e "  PATH: ${GREEN}${INSTALL_DIR} is in PATH${RESET}"
else
    echo -e "  PATH: ${YELLOW}${INSTALL_DIR} not in PATH${RESET}"
    echo -e "  ${DIM}Add this to your ~/.bashrc or ~/.zshrc:${RESET}"
    echo -e "  ${DIM}  export PATH=\"\${HOME}/.local/bin:\$PATH\"${RESET}"

    # Auto-add to shell rc
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

# Check for ffmpeg
if command -v ffplay &>/dev/null; then
    echo -e "  Audio: ${GREEN}ffplay found${RESET}"
elif command -v mpv &>/dev/null; then
    echo -e "  Audio: ${GREEN}mpv found${RESET}"
else
    echo -e "  Audio: ${YELLOW}ffplay not found${RESET}"
    echo -e "  ${YELLOW}Install ffmpeg for sound: sudo apt install ffmpeg${RESET}"
fi

echo ""
echo -e "  ${BOLD}Usage: nmap -sV 10.0.0.1 | peon${RESET}"
echo -e "  ${BOLD}Help:  peon --help${RESET}"
echo -e "  ${BOLD}Sounds: peon --list${RESET}"
echo -e "  ${DIM}Run 'source ~/.bashrc' (or ~/.zshrc) to update PATH${RESET}"
echo ""
echo -e "  ${GREEN}✓ Installed!${RESET}"
