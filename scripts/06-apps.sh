#!/usr/bin/env bash
# Apps: zen-browser, vesktop, media mount points, ntfs-3g, thunar, disk utility, Zed, opencode.
set -euo pipefail

log() { printf '\033[1;34m[06-apps]\033[0m %s\n' "$*"; }

log "Enabling zen-browser COPR repo..."
sudo dnf copr enable sneexy/zen-browser

log "Installing zen-browser..."
sudo dnf install zen-browser

log "Installing vesktop..."
sudo dnf install vesktop

log "Creating /media mount points..."
sudo mkdir -p /media/Games /media/Data /media/MoreData

log "Setting ownership of /media mount points..."
sudo chown fassih:fassih /media/Games
sudo chown fassih:fassih /media/Data
sudo chown fassih:fassih /media/MoreData

log "Installing ntfs-3g (NTFS read/write)..."
sudo dnf install ntfs-3g

log "Installing thunar (file manager)..."
sudo dnf in thunar

log "Installing gnome-disk-utility..."
sudo dnf install gnome-disk-utility

log "Installing Zed (code editor)..."
curl -f https://zed.dev/install.sh | sh

log "Installing opencode (AI coding tool)..."
curl -fsSL https://opencode.ai/install | bash