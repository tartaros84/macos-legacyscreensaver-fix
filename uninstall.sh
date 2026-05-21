#!/bin/zsh

set -e

LABEL="io.github.legacyscreensaverfix.agent"
SCRIPT_NAME="fix-legacyscreensaver.sh"
PLIST_NAME="$LABEL.plist"

CURRENT_UID="$(id -u)"

if [ "$CURRENT_UID" -eq 0 ]; then
    echo "Error: Do not run this uninstaller with sudo."
    echo "This LaunchAgent belongs to the current user."
    exit 1
fi

SCRIPT_TARGET="$HOME/Scripts/$SCRIPT_NAME"
PLIST_TARGET="$HOME/Library/LaunchAgents/$PLIST_NAME"

echo "Uninstalling macOS legacyScreenSaver Fix"

launchctl bootout "gui/$CURRENT_UID" "$PLIST_TARGET" 2>/dev/null || true

rm -f "$PLIST_TARGET"
rm -f "$SCRIPT_TARGET"
rm -f "$HOME/Library/Logs/fix-legacyscreensaver.log"
rm -f "$HOME/Library/Logs/fix-legacyscreensaver.out.log"
rm -f "$HOME/Library/Logs/fix-legacyscreensaver.err.log"

rmdir "$HOME/Scripts" 2>/dev/null || true

echo "Uninstall complete."
