#!/bin/bash
# Have you tried turning it off and back on again?
# Assuming station mode is the default, it'll come back in station mode.

sudo nmcli r wifi off
sleep 1
sudo nmcli r wifi on
