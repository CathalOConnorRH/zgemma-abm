#!/bin/sh
# Nightly sync for the Zgemma boxes (cron 00:50, before ABM's 01:00 scan):
#   1. Update this script from GitHub (re-runs itself once if it changed)
#   2. Pull the shared ABM CustomMix file
# Repo (owner/repo) is read from /etc/enigma2/abm-sync.repo, written by install.sh.
SELF=/usr/script/abm-sync.sh
REPO=$(cat /etc/enigma2/abm-sync.repo 2>/dev/null)
BRANCH=${BRANCH:-main}
[ -n "$REPO" ] || { logger "abm-sync: no repo set in /etc/enigma2/abm-sync.repo"; exit 1; }
RAW="https://raw.githubusercontent.com/$REPO/$BRANCH"

# --- 1. Self-update -------------------------------------------------------
if [ -z "$ABM_SYNC_UPDATED" ]; then
  NEW=/tmp/abm-sync.sh.new
  if wget -q -O "$NEW" "$RAW/abm-sync.sh" && [ -s "$NEW" ] && head -1 "$NEW" | grep -q '^#!/bin/sh' && sh -n "$NEW"; then
    if ! cmp -s "$NEW" "$SELF"; then
      cp "$SELF" "$SELF.prev" 2>/dev/null
      mv "$NEW" "$SELF" && chmod +x "$SELF"
      logger "abm-sync: script updated, re-running"
      ABM_SYNC_UPDATED=1 exec "$SELF"
    fi
  else
    logger "abm-sync: script update skipped (download failed or invalid)"
  fi
  rm -f "$NEW"
fi

# --- 2. CustomMix ---------------------------------------------------------
DEST=/etc/enigma2/AutoBouquetsMaker/custom/sat_282_sky_uk_CustomMix.xml
TMP=/tmp/custommix.xml
wget -q -O "$TMP" "$RAW/sat_282_sky_uk_CustomMix.xml" || { logger "abm-sync: CustomMix download failed"; rm -f "$TMP"; exit 1; }
python3 -c "import sys,xml.dom.minidom as m; d=m.parse(sys.argv[1]); assert d.documentElement.tagName=='custommix'" "$TMP" \
  || { logger "abm-sync: invalid CustomMix XML, keeping current file"; rm -f "$TMP"; exit 1; }
if cmp -s "$TMP" "$DEST"; then rm -f "$TMP"; logger "abm-sync: CustomMix no change"; exit 0; fi
mkdir -p "$(dirname "$DEST")"
cp "$DEST" "$DEST.prev" 2>/dev/null
mv "$TMP" "$DEST"
logger "abm-sync: CustomMix updated"
