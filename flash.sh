#!/usr/bin/env bash
# Full-set flash for this camera image — published as a release asset
# beside image.signed.bin + manifest.json, and executed BY THE HUB from
# Factory → Flash a device (contract: NN_FLASH_PORT / NN_FLASH_IMAGE /
# NN_FLASH_ESPTOOL; cwd = the release directory, aux binaries are
# siblings).  Writes bootloader + partition table + ota_data + app, so a
# FACTORY-BLANK board comes up too; NVS is untouched, so a provisioned
# camera keeps its keys and Wi-Fi.
set -euo pipefail
: "${NN_FLASH_PORT:?}"
D="$(cd "$(dirname "$0")" && pwd)"
${NN_FLASH_ESPTOOL:-python3 -m esptool} --chip esp32p4 -p "$NN_FLASH_PORT" -b 460800 \
  --before default-reset --after hard-reset write-flash \
  --flash-mode dio --flash-size 16MB --flash-freq 80m \
  0x2000 "$D/bootloader.bin" 0x8000 "$D/partition-table.bin" \
  0xf000 "$D/ota_data_initial.bin" 0x20000 "${NN_FLASH_IMAGE:-$D/image.signed.bin}"
