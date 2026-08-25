# nn-app-camera-esp32p4module-sdio-ov5647

nn camera firmware for the **Waveshare ESP32-P4-Module-DEV-KIT** (pre-3.0
silicon, rev v1.3) with an **OmniVision OV5647** (5 MP, Raspberry Pi Camera
v1.3 class module).

Configuration + glue only — `sdkconfig.board` is the union of two proven
layers: the DEV-KIT's pre-3.0 silicon arrangement (hardware-validated on the
IMX708 variant, deployed as cam1) and the OV5647 sensor selection (native
1080p30 RAW10 — no crop, no PPA scale). All shared code arrives via the
`nn-app-media` submodule (recursively bringing `nn-modules`).

## Build

    git submodule update --init --recursive
    idf.py set-target esp32p4 build

## Status

**Hardware-validated 2026-08-16** as cam1: the sensor is detected
(`ov5647: Detected Camera sensor PID=0x5647`), CSI negotiates 1920x1080, and
H.264 reaches the hub with a normal picture.

Colour is still untuned — OV5647 CCM is identity and WB unity (`isp wb`,
`isp ccm`).

Encode height is 1072, not 1080: 1080 is not macroblock-aligned (1080/16 =
67.5) and this encoder codes such heights non-conformantly, emitting a green
partial row at the bottom.

The console is routed to USB-Serial-JTAG because this board does not bring
UART0 out to its USB bridge — without that the `cam info` / `cam stats`
diagnostics are unreachable, which matters most when the camera fails to
start.
