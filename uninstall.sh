#!/usr/bin/env bash
# peon uninstaller
set -euo pipefail

BOLD='\033[1m'
GREEN='\033[32m'
DIM='\033[2m'
RESET='\033[0m'

echo -e "${BOLD}Uninstalling peon...${RESET}"

rm -f "${HOME}/.local/bin/peon"
rm -rf "${HOME}/.local/share/peon"

echo -e "  ${GREEN}✓ Removed${RESET} ~/.local/bin/peon"
echo -e "  ${GREEN}✓ Removed${RESET} ~/.local/share/peon/"
echo -e "  ${DIM}Note: PATH entry in ~/.bashrc or ~/.zshrc was left intact${RESET}"
