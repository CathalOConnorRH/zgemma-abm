# Zgemma ABM CustomMix

Shared AutoBouquetsMaker CustomMix for the Zgemma boxes (Saorview 1–22, then Sky UK FTA from 101).

## Update the channel list
1. Reorder in the Zgemma Channel Order editor and click **Copy XML**.
2. Paste over `sat_282_sky_uk_CustomMix.xml`, commit and push.
3. Boxes pull it at 00:50; ABM rebuilds at 01:00. For an instant update run
   `/usr/script/abm-sync.sh` on the box, then run ABM.

## Install on a box (once)
    wget -qO- https://raw.githubusercontent.com/OWNER/REPO/main/install.sh | sh -s -- OWNER/REPO

## Roll back
    cp /etc/enigma2/AutoBouquetsMaker/custom/sat_282_sky_uk_CustomMix.xml.prev /etc/enigma2/AutoBouquetsMaker/custom/sat_282_sky_uk_CustomMix.xml

## Updating the script
`abm-sync.sh` updates itself from this repo on every run: push a new version and each box
picks it up at 00:50. A new version is only installed if it downloads fully, starts with
`#!/bin/sh` and passes `sh -n`; the old one is kept as `/usr/script/abm-sync.sh.prev`.

Logs: `logread | grep abm-sync`
