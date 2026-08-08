#!/usr/bin/env bash
# Flatpak: install the runtime and add the Flathub repository.
set -euo pipefail

log() { printf '\033[1;34m[12-flatpak]\033[0m %s\n' "$*"; }

log "Installing Flatpak..."
sudo dnf install flatpak

log "Adding the Flathub repository..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

log "Flathub remotes:"
flatpak remotes