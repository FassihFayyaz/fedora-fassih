#!/usr/bin/env bash
# Fonts: FontAwesome + JetBrains Mono Nerd Font + Droid fonts.
# JetBrains Mono Nerd Font comes from the cubewhy/copr repo,
# so enable that COPR before installing it.
set -euo pipefail

log() { printf '\033[1;34m[13-fonts]\033[0m %s\n' "$*"; }

log "Installing FontAwesome (font icons)..."
sudo dnf install fontawesome-fonts

log "Enabling cubewhy/copr (JetBrains Mono Nerd Font)..."
sudo dnf copr enable cubewhy/copr

log "Installing JetBrains Mono Nerd Font..."
sudo dnf install jetbrains-mono-nerd-fonts

log "Installing Google Droid fonts..."
sudo dnf install google-droid-fonts-all

log "Done. Fonts installed. Log out/in to refresh the font cache."