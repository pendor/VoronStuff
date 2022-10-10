#!/bin/bash
# FIXME: Set your WiFi device:
DEV=[SETME: WIFI DEV]

sudo nmcli con up Hotspot ifname $DEV