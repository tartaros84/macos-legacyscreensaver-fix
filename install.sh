#!/bin/zsh

set -e

LABEL="io.github.legacyscreensaverfix.agent"
SCRIPT_NAME="fix-legacyscreensaver.sh"
PLIST_NAME="$LABEL.plist"

CURRENT_USER="$(id -un)"
CURRENT_UID="$(id -u)"

if [ "$CURRENT_UID" -eq 0 ]; then
    echo "Error: Do not run this installer with sudo."
    echo "LaunchAgents must be installed in the current user's context."
    exit 1
fi

if [ -z "$HOME" ] || [ ! -d "$HOME" ]; then
    echo "Error: Could not determine a valid HOME directory."
    exit 1
fi

SCRIPT_DIR="$HOME/Scripts"
LAUNCH_AGENT_DIR="$HOME/Library/LaunchAgents"
LOG_DIR="$HOME/Library/Logs"

SCRIPT_SOURCE="./$SCRIPT_NAME"
PLIST_SOURCE="./$PLIST_NAME"

SCRIPT_TARGET="$SCRIPT_DIR/$SCRIPT_NAME"
PLIST_TARGET="$LAUNCH_AGENT_DIR/$PLIST_NAME"

echo "Installing macOS legacyScreenSaver Fix"
echo "User: $CURRENT_USER"
echo "UID: $CURRENT_UID"
echo "Home: $HOME"

if [ ! -f "$SCRIPT_SOURCE" ]; then
    echo "Error: Missing $SCRIPT_SOURCE"
    exit 1
fi

if [ ! -f "$PLIST_SOURCE" ]; then
    echo "Error: Missing $PLIST_SOURCE"
    exit 1
fi

mkdir -p "$SCRIPT_DIR" "$LAUNCH_AGENT_DIR" "$LOG_DIR"

cp "$SCRIPT_SOURCE" "$SCRIPT_TARGET"
chmod +x "$SCRIPT_TARGET"

sed "s|__HOME__|$HOME|g" "$PLIST_SOURCE" > "$PLIST_TARGET"

plutil -lint "$PLIST_TARGET"

launchctl bootout "gui/$CURRENT_UID" "$PLIST_TARGET" 2>/dev/null || true
launchctl bootstrap "gui/$CURRENT_UID" "$PLIST_TARGET"
launchctl kickstart -k "gui/$CURRENT_UID/$LABEL"

echo "Installation complete."
echo ""
echo "Check status with:"
echo "launchctl list | grep legacyscreensaverfix"
echo ""
echo "Check log with:"
echo "tail -n 20 ~/Library/Logs/fix-legacyscreensaver.log"
