#!/usr/bin/env bash
#
# fedora-fassih — master installer
#
# Runs the provisioning scripts in scripts/ in order, with checkpoint/resume:
# a hidden .progress file records each completed script. After a reboot (e.g.
# the NVIDIA step), re-run with --resume to continue where you left off.
#
# Usage:
#   ./install.sh            # run everything (prompts to resume if progress exists)
#   ./install.sh --resume   # continue from the next un-completed script
#   ./install.sh 04-audio   # run only scripts/04-audio.sh
#   ./install.sh 01 03      # run only scripts/01-repos.sh and scripts/03-nvidia.sh
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)"
SCRIPTS_DIR="$SCRIPT_DIR/scripts"
PROGRESS_FILE="$SCRIPT_DIR/.progress"

log() { printf '\033[1;34m[%s]\033[0m %s\n' "$(basename "$0")" "$*"; }
die() { printf '\033[1;31mERROR:\033[0m %s\n' "$*" >&2; exit 1; }

# Load already-completed scripts into an associative array.
declare -A done_names
if [[ -f "$PROGRESS_FILE" ]]; then
    while IFS= read -r line; do
        [[ -n "$line" ]] && done_names["$line"]=1
    done < "$PROGRESS_FILE"
fi

# Full ordered list of scripts.
all_scripts=()
while IFS= read -r f; do all_scripts+=("$f"); done \
    < <(find "$SCRIPTS_DIR" -maxdepth 1 -name '*.sh' -type f | sort)

resume_mode=0
if [[ $# -gt 0 && "$1" == "--resume" ]]; then
    resume_mode=1
    shift
fi

targets=()
if [[ $# -gt 0 ]]; then
    # Explicit script args: run exactly those, regardless of progress.
    for arg in "$@"; do
        file="$(find "$SCRIPTS_DIR" -maxdepth 1 -name "${arg}*.sh" -type f | head -n1)"
        [[ -n "$file" ]] || die "no script matches '$arg'"
        targets+=("$file")
    done
else
    # No args: run everything, honoring progress/resume.
    if [[ -f "$PROGRESS_FILE" && -s "$PROGRESS_FILE" ]]; then
        pending=()
        for f in "${all_scripts[@]}"; do
            name="$(basename "$f")"
            [[ -n "${done_names[$name]:-}" ]] || pending+=("$f")
        done

        if [[ ${#pending[@]} -eq 0 ]]; then
            log "All scripts already completed. Nothing to do."
            log "To run everything again, remove $PROGRESS_FILE and re-run."
            exit 0
        fi

        if [[ $resume_mode -eq 1 ]]; then
            log "Resuming: ${#pending[@]} script(s) remaining."
            targets=("${pending[@]}")
        else
            done_count=$(( ${#all_scripts[@]} - ${#pending[@]} ))
            printf 'Progress found: %d/%d scripts already completed.\n' \
                "$done_count" "${#all_scripts[@]}"
            printf '  [r] resume from the next pending script\n'
            printf '  [a] start over (clear progress)\n'
            printf '  [q] quit\n'
            read -rp 'Choose: ' choice
            case "${choice,,}" in
                r) targets=("${pending[@]}") ;;
                a)
                    rm -f "$PROGRESS_FILE"
                    done_names=()
                    targets=("${all_scripts[@]}")
                    ;;
                q) die "aborted" ;;
                *) die "invalid choice" ;;
            esac
        fi
    else
        targets=("${all_scripts[@]}")
    fi
fi

[[ ${#targets[@]} -gt 0 ]] || die "no scripts found"

for script in "${targets[@]}"; do
    log "▶ running $script"
    bash "$script"
    # Record completion (deduplicated).
    printf '%s\n' "$(basename "$script")" >> "$PROGRESS_FILE"
    sort -u -o "$PROGRESS_FILE" "$PROGRESS_FILE"
done

log "✅ done"