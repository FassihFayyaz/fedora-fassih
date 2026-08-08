#!/usr/bin/env bash
# Enable RPMFusion nonfree (for proprietary NVIDIA driver), then upgrade.
# RPMFusion free is enabled later in 05-desktop.sh (multimedia codecs).
set -euo pipefail

log() { printf '\033[1;34m[01-repos]\033[0m %s\n' "$*"; }

log "Enabling RPMFusion nonfree..."
sudo dnf install \
    "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

log "Upgrading core group..."
sudo dnf group upgrade core

log "Refreshing and upgrading..."
sudo dnf upgrade --refresh