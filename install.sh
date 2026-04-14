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

# Detect OS
OS="$(uname -s)"
ARCH="$(uname -m)"
echo -e "  Platform: ${YELLOW}${OS}${RESET} (${ARCH})"

# Ensure dirs exist
mkdir -p "${INSTALL_DIR}"
mkdir -p "${SOUND_DIR}"

# ── Install dependencies ──────────────────────────────────────────

install_ffmpeg() {
    if command -v ffplay &>/dev/null; then
        echo -e "  Dependencies: ${GREEN}ffmpeg already installed${RESET}"
        return 0
    fi

    echo -e "  Dependencies: ${YELLOW}ffmpeg not found, installing...${RESET}"

    # macOS
    if [ "${OS}" = "Darwin" ]; then
        if command -v brew &>/dev/null; then
            brew install ffmpeg
        else
            echo -e "  ${YELLOW}Homebrew not found. Install it from https://brew.sh${RESET}"
            echo -e "  ${YELLOW}Then run: brew install ffmpeg${RESET}"
            return 1
        fi

    # Linux
    elif [ "${OS}" = "Linux" ]; then
        # Detect distro
        if [ -f /etc/debian_version ] || command -v apt-get &>/dev/null; then
            # Debian/Ubuntu/Mint/Kali
            if command -v sudo &>/dev/null; then
                sudo apt-get update -qq && sudo apt-get install -y -qq ffmpeg
            else
                apt-get update -qq && apt-get install -y -qq ffmpeg
            fi

        elif [ -f /etc/fedora-release ] || command -v dnf &>/dev/null; then
            # Fedora/RHEL 8+
            if command -v sudo &>/dev/null; then
                sudo dnf install -y ffmpeg
            else
                dnf install -y ffmpeg
            fi

        elif [ -f /etc/arch-release ] || command -v pacman &>/dev/null; then
            # Arch/Manjaro
            if command -v sudo &>/dev/null; then
                sudo pacman -S --noconfirm ffmpeg
            else
                pacman -S --noconfirm ffmpeg
            fi

        elif command -v apk &>/dev/null; then
            # Alpine
            if command -v sudo &>/dev/null; then
                sudo apk add ffmpeg
            else
                apk add ffmpeg
            fi

        elif command -v zypper &>/dev/null; then
            # openSUSE
            if command -v sudo &>/dev/null; then
                sudo zypper install -y ffmpeg
            else
                zypper install -y ffmpeg
            fi

        elif command -v nix-env &>/dev/null; then
            # NixOS
            nix-env -iA nixos.ffmpeg

        else
            echo -e "  ${YELLOW}Unknown Linux distro. Install ffmpeg manually:${RESET}"
            echo -e "  ${DIM}  Ubuntu/Debian: sudo apt install ffmpeg${RESET}"
            echo -e "  ${DIM}  Fedora: sudo dnf install ffmpeg${RESET}"
            echo -e "  ${DIM}  Arch: sudo pacman -S ffmpeg${RESET}"
            return 1
        fi

    # WSL
    elif grep -qi microsoft /proc/version 2>/dev/null; then
        if command -v sudo &>/dev/null; then
            sudo apt-get update -qq && sudo apt-get install -y -qq ffmpeg
        else
            apt-get update -qq && apt-get install -y -qq ffmpeg
        fi

    else
        echo -e "  ${YELLOW}Unknown OS. Install ffmpeg manually.${RESET}"
        return 1
    fi

    if command -v ffplay &>/dev/null; then
        echo -e "  Dependencies: ${GREEN}ffmpeg installed${RESET}"
    else
        echo -e "  ${YELLOW}ffmpeg install may have failed. Try manually.${RESET}"
        return 1
    fi
}

install_ffmpeg || true

# ── Download peon ──────────────────────────────────────────────────

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

# ── Download default sound ─────────────────────────────────────────

echo -e "  Downloading ${GREEN}default sound${RESET} (~36KB)..."
if command -v curl &>/dev/null; then
    curl -fsSL "https://raw.githubusercontent.com/${REPO}/${BRANCH}/sounds/peon-default.mp3" \
        -o "${SOUND_DIR}/peon-default.mp3"
elif command -v wget &>/dev/null; then
    wget -q "https://raw.githubusercontent.com/${REPO}/${BRANCH}/sounds/peon-default.mp3" \
        -O "${SOUND_DIR}/peon-default.mp3"
fi

echo -e "  ${DIM}Want 159 game sounds? Run: peon --download-sounds${RESET}"

# ── PATH setup ─────────────────────────────────────────────────────

if echo ":${PATH}:" | grep -q ":${INSTALL_DIR}:"; then
    echo -e "  PATH: ${GREEN}${INSTALL_DIR} is in PATH${RESET}"
else
    echo -e "  PATH: ${YELLOW}${INSTALL_DIR} not in PATH${RESET}"

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
    else
        echo -e "  ${DIM}Add to your shell config: export PATH=\"\${HOME}/.local/bin:\$PATH\"${RESET}"
    fi
fi

# ── Done ───────────────────────────────────────────────────────────

echo ""
echo -e "  ${BOLD}Usage: nmap -sV 10.0.0.1 && peon${RESET}"
echo -e "  ${BOLD}Help:  peon --help${RESET}"
echo -e "  ${BOLD}More sounds: peon --download-sounds${RESET}"
echo -e "  ${DIM}Run 'source ~/.bashrc' (or ~/.zshrc) to update PATH${RESET}"
echo ""
echo -e "  ${GREEN}✓ Installed!${RESET}"
