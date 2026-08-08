#!/usr/bin/env bash
# Enable RPMFusion free + nonfree, then upgrade.
set -euo pipefail

log() { printf '\033[1;34m[01-repos]\033[0m %s\n' "$*"; }

log "Enabling RPMFusion free + nonfree..."
sudo dnf install \
    "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

log "Upgrading core group..."
sudo dnf group upgrade core

log "Refreshing and upgrading..."
sudo dnf upgrade --refresh