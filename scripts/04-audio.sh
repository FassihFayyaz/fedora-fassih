#!/usr/bin/env bash
# Install PipeWire audio stack.
set -euo pipefail

log() { printf '\033[1;34m[04-audio]\033[0m %s\n' "$*"; }

log "Upgrading the multimedia group (excludes PackageKit-gstreamer-plugin)..."
sudo dnf group upgrade multimedia --exclude=PackageKit-gstreamer-plugin

log "Installing PipeWire audio stack..."
sudo dnf install pipewire pipewire-pulseaudio pipewire-alsa wireplumber alsa-sof-firmware

log "Enabling PipeWire user services..."
systemctl --user enable --now pipewire pipewire-pulse wireplumber