#!/bin/sh
# Usage on the box:  wget -qO- https://raw.githubusercontent.com/OWNER/REPO/main/install.sh | sh -s -- OWNER/REPO
set -e
REPO="$1"
[ -n "$REPO" ] || { echo "Usage: sh install.sh OWNER/REPO"; exit 1; }
mkdir -p /usr/script
wget -q -O /usr/script/abm-sync.sh "https://raw.githubusercontent.com/$REPO/main/abm-sync.sh"
chmod +x /usr/script/abm-sync.sh
echo "$REPO" > /etc/enigma2/abm-sync.repo
( crontab -l 2>/dev/null | grep -v abm-sync.sh; echo "50 0 * * * /usr/script/abm-sync.sh" ) | crontab -
echo "Installed. Cron:"; crontab -l | grep abm-sync.sh
/usr/script/abm-sync.sh && logread 2>/dev/null | grep abm-sync | tail -1
