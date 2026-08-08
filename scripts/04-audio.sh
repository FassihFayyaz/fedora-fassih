#!/usr/bin/env bash
# Install PipeWire audio stack + mpv (video player).
set -euo pipefail

log() { printf '\033[1;34m[04-audio]\033[0m %s\n' "$*"; }

# mpv depends on ffmpeg, so install it HERE (before the ffmpeg-free -> ffmpeg
# swap in 05-desktop.sh) so the swap cleanly replaces ffmpeg-free afterward.
log "Installing mpv (video player)..."
sudo dnf in mpv

log "Installing PipeWire audio stack..."
sudo dnf install pipewire pipewire-pulseaudio pipewire-alsa wireplumber alsa-sof-firmware

log "Enabling PipeWire user services..."
systemctl --user enable --now pipewire pipewire-pulse wireplumber