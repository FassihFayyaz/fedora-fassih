#!/usr/bin/env bash
# Gaming: Steam, GOverlay, MangoHud, ProtonPlus (Proton manager).
set -euo pipefail

log() { printf '\033[1;34m[14-gaming]\033[0m %s\n' "$*"; }

log "Installing Steam, GOverlay, MangoHud..."
sudo dnf install steam goverlay mangohud

log "Enabling wehagy/protonplus COPR..."
sudo dnf copr enable wehagy/protonplus

log "Installing ProtonPlus (Proton version manager)..."
sudo dnf install protonplus