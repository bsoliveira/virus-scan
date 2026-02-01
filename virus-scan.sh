#!/usr/bin/env bash
# virus-scan — Antivirus scanning using clamscan
# Moves infected files to quarantine and logs detections only
#
# Usage:
#   virus-scan <file|directory>
#   (if no argument is provided, the current directory is scanned)
#
# Example (Thunar custom action):
#   alacritty -e virus-scan %f

# Base directories and files
BASE_DIR="$HOME/.local/share/virus-scan"
INFECTED_DIR="$BASE_DIR/infected"
LOG_FILE="$BASE_DIR/infecteds-$(date +'%Y-%m-%d').log"

# Temporary file to capture clamscan output
TMPFILE="$(mktemp)"
trap 'rm -f "$TMPFILE"' EXIT

# Check dependency
if ! command -v clamscan >/dev/null 2>&1; then
    echo "ERROR: 'clamscan' dependency not found. Install ClamAV." >&2
    exit 2
fi

# Target path (file or directory)
TARGET="${1:-.}"
[ -e "$TARGET" ] || exit 2

# Ensure quarantine directory exists
mkdir -p "$INFECTED_DIR"

# Run antivirus scan
# Exit codes:
#   0 = no virus found
#   1 = virus(es) found
#  >1 = error
clamscan --recursive \
  --alert-encrypted \
  --exclude-dir="$INFECTED_DIR" \
  --move="$INFECTED_DIR" \
  --log="$TMPFILE" \
  "$TARGET"

SCAN_EXIT_CODE=$?

# Log infected files only
if [ "$SCAN_EXIT_CODE" -eq 1 ]; then
  {
    printf '%s\n' "$(date +'%Y-%m-%d %H:%M:%S') ---------------------"
    grep -- "FOUND" "$TMPFILE" || true
    printf '\n'
  } >> "$LOG_FILE"
fi

if [ -t 1 ]; then
    echo "Press any key to exit..."
    read -rsn1
fi

exit "$SCAN_EXIT_CODE"
