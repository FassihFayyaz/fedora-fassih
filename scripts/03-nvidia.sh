#!/usr/bin/env bash
# Install NVIDIA driver (RPMFusion akmod-nvidia) + CUDA.
set -euo pipefail

log() { printf '\033[1;34m[03-nvidia]\033[0m %s\n' "$*"; }

log "Installing NVIDIA driver + CUDA..."
sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda