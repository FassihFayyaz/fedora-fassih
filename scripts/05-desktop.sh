#!/usr/bin/env bash
# Multimedia/codecs (RPMFusion free) + Qt/GTK theming + fastfetch.
set -euo pipefail

log() { printf '\033[1;34m[05-desktop]\033[0m %s\n' "$*"; }

log "Enabling RPMFusion free (codecs)..."
sudo dnf install \
    "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"

log "Upgrading multimedia group (codecs)..."
sudo dnf group upgrade multimedia --exclude=PackageKit-gstreamer-plugin

log "Swapping ffmpeg-free for full ffmpeg (RPMFusion)..."
sudo dnf swap ffmpeg-free ffmpeg --allowerasing

log "Installing Qt base (Qt5/Qt6 for theming under DMS)..."
sudo dnf install qt5-qtbase qt6-qtbase

log "Enabling solopasha/hyprland COPR (adw-gtk3-theme, nwg-look)..."
sudo dnf copr enable solopasha/hyprland

log "Installing GTK theming (adw-gtk3-theme, nwg-look)..."
sudo dnf install adw-gtk3-theme nwg-look

log "Installing fastfetch..."
sudo dnf install fastfetch