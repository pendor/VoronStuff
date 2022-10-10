WiFi AP Mode
============

This directory contains shell scripts, Linux configuration, and Klipper configuration to toggle a printer's WiFi between normal station mode and access point mode.  Access Point mode allows accessing a printer by directly connecting to it from a phone or laptop in an environment where the printer isn't already associated with a known WiFi SSID.  This can be helpful if you bring your printer into an environment other than your home network or want to use it with Mainsail or other network-based interfaces in an area that doesn't already have a WiFi network you can use.

Once in AP mode, you can access Mainsail (or whathaveyou) directly over the printer's WiFi AP or SSH in to connect the printer to a local WiFi SSID then revert to station mode.  Uploading GCode from most slicers' direct upload functionality works as well, provided you modify your slicer's printer configuration to have the right IP address.

Note that while in AP mode, neither the printer nor (typically) any device connected to its access point will have access to anything on the internet.  Some phones can be configured to use their cellular connection for internet while connecting to a private disconnected network over WiFi.  YMMV, airtime charges may apply, etc.

Prerequesites
=============

* Shell Command Extension: https://github.com/th33xitus/kiauh/blob/master/docs/gcode_shell_command.md
* Network Status Extension: https://github.com/JeremyRuhland/klipper_network_status
* Linux using NetworkManager for WiFi (I use Armbian 22.05.3)

Installation
============

Linux
-----

On the Linux side, you'll need to create some NetworkManager configuration and shell scripts.  The scripts in the "scripts" directory should go in /usr/local/bin (or elsewhere if you like, but update the paths in the Klipper config file).  You must modify wifi-station.sh to include the Linux device for your WiFi adapter.  Make sure they're both set executable.

NetworkManager requires at least two configurations: One for AP Mode, one for normal station mode.  Assuming you already have the system connected to your local WiFi, there should already be at least one nmconnection file in /etc/NetworkManager/system-connections/.  If not, you can use the client.nmconnection file as a template to create one.  I'd recommend getting station mode WiFi working before proceeding because the rest of this won't work if there are problems with the system's WiFi drivers, etc.

The Hotspot.nmconnection contains the configuration to enable AP mode.  The name of this config must match what's in wifi-ap.sh, so update both if you want to change it.  You'll need to fill-in several blanks in the connection file.  Search for SETME.  You need the WiFi device, its MAC (both can be had by running `ip addr`), a name & password for your created SSID and a UUID connection (use `uuidgen`).

Once the scripts and nmconnection files are in place, you should be able to toggle from AP to station mode by running the two scripts.  You'll probably want to connect with wired eithernet or serial console before trying...

Klipper
-------

Once the Linux side of stuff is done, adding some macros and menus to Klipper allows toggling WiFi mode from the printer's display. You'll need to install the Shell Command and Network Status extensions following their instructions.  Note that the Network Status extension is technically optional, but it helps a lot to see network settings in the Klipper menus.  If you'd rather not install it, modify wifi_menu.cfg to remove the items that reference `{printer.network_status.XXX}`.

The menu and shell command items are in separate cfg files which you can include in printer.cfg.  It's just a matter of style if you keep them in two files, combine them into one, or paste them directly into printer.cfg.

Restart Klipper, and you should see a new Network menu at the bottom of the main menu.

FIXME
=====

I'm writing this a couple of months after figuring it all out.  I can't find anything else I had to do to an Armbian 22 machine to make this work.  Specifically hostapd wasn't necessary.  Other Linuxes may need more changes, especially if they're not setup to use NetworkManager for WiFi.  Ubuntu 20 & later seem to use the same configuration.

I can't figure out where the IP address settings for the created AP are set, so I might be missing something.  If you run into issues, feel free to ask, and I'll help as best I can.  Pull requests welcome...
