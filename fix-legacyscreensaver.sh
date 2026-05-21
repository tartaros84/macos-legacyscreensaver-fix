#!/bin/zsh

LOGFILE="$HOME/Library/Logs/fix-legacyscreensaver.log"

IDLE_SECONDS=$(ioreg -c IOHIDSystem | awk '/HIDIdleTime/ {print int($NF / 1000000000); exit}')

LEGACY_PID=$(pgrep -x "legacyScreenSaver" | head -n 1)
LEGACY_X86_PID=$(pgrep -x "legacyScreenSaver-x86_64" | head -n 1)

# If the Mac has been idle for a while, the screensaver may be active.
# Do nothing to avoid interrupting the active screensaver.
if [ "$IDLE_SECONDS" -gt 30 ]; then
    exit 0
fi

# If the user is active again and legacyScreenSaver is still running,
# it is probably stuck in the background.
if [ -n "$LEGACY_PID" ]; then
    echo "$(date): User active, legacyScreenSaver still running. Killing legacyScreenSaver." >> "$LOGFILE"
    kill "$LEGACY_PID" 2>/dev/null
fi

if [ -n "$LEGACY_X86_PID" ]; then
    echo "$(date): User active, legacyScreenSaver-x86_64 still running.
    Killing legacyScreenSaver-x86_64." >> "$LOGFILE"
    kill "$LEGACY_X86_PID" 2>/dev/null
fi

exit 0
