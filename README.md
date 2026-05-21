# macOS legacyScreenSaver Fix

A small LaunchAgent based workaround for macOS systems where `legacyScreenSaver` keeps running in the background after a third party screensaver has stopped.

## What it does

The LaunchAgent runs every 30 seconds.

The script checks the user's idle time first.

If the Mac has been idle for more than 30 seconds, it does nothing. This avoids interrupting an active screensaver.

If the user is active again and `legacyScreenSaver` or `legacyScreenSaver-x86_64` is still running, the script terminates only those processes.

It does not close normal applications.

## Installation

```bash
git clone https://github.com/YOURUSERNAME/macos-legacyscreensaver-fix.git
cd macos-legacyscreensaver-fix
chmod +x install.sh uninstall.sh fix-legacyscreensaver.sh
./install.sh

## Check status
launchctl list | grep legacyscreensaverfix

## Check logs
tail -n 20 ~/Library/Logs/fix-legacyscreensaver.log

## Uninstall
./uninstall.sh

## Security
This tool does not require root privileges.

It installs a user LaunchAgent in:
~/Library/LaunchAgents/

The script only checks the user’s idle time and terminates these processes if necessary:
legacyScreenSaver
legacyScreenSaver-x86_64

It does not modify system files.
