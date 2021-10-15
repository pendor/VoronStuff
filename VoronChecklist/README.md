This tool will parse through a list of STL files (perhaps for the Voron printer) and generate an HTML checklist
of all of the files for printing.  It assumes the Voron naming convention where two different colors are represented
by the presence or absense of "[a]" on the front of the filename and where quantity are represented by IE "_x2" on
the end of the filename.

Included in this git repo is everything.pdf which is ALL of the STL's for the Voron 2.4r1 build.  You can customize
the list by adding directories or individual STL's you don't want to print into the blacklist file and re-running.  
You'll probably want to put in the skirts directories that aren't for your printer size, the extruders & electronics
you're not using, etc.

The final displays the STL previews in two colors - blue is "normal" parts (there wasn't a good black color scheme in 
OpenSCAD), and red is for the accent parts.  There's a checkbox for each print, as well as a space to write-in which GCODE
file that batch of parts was included in.

You'll need OpenSCAD installed to use this tool.  The script is currently configured for MacOS.  YMMV on other OS's.
