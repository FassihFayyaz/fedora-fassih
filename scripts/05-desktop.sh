#!/usr/bin/env bash
# Multimedia group upgrade + fastfetch.
set -euo pipefail

log() { printf '\033[1;34m[05-desktop]\033[0m %s\n' "$*"; }

log "Upgrading multimedia group (codecs)..."
sudo dnf group upgrade multimedia --exclude=PackageKit-gstreamer-plugin

log "Installing fastfetch..."
sudo dnf install fastfetch