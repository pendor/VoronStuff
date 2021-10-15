#!/bin/bash
#
# This script walks a tree of folders looking for any STL files.  It builds an index
# with a thumbnail and the filename of each STL found.  It's intended for printing a 
# checklist for printing out parts for a Voron printer build.  It's been tested with
# the 2.4, but it should work with others provided the same naming convention is specified.
# This kit interprets filenames as described in the Voron build manual.  Specifically
# filenames prefixed with "[a]" with be previewed in an alternative highlight color.
# Filenames ending with IE "_x2" with indicate that 2 copies of that part should be 
# printed by showing the count in a box and also printing an appropriate number of
# checkboxes.
#
# This script requires OpenSCAD to produce thumbnails and wkhtmltopdf to convert 
# generated HTML to PDF.  As released, paths are configured for MacOS.
#
# You may configure which parts to print by editing the blacklist file.  Any path
# prefixes or filenames listed in that file will not appear in the index.  You can
# use the blacklist to skip skirts for other printer sizes, electronic brackets you're
# not using, etc.
#
# This script is released under the terms of the GPL, version 3 only.
# Copyright (c) 2021 Zachary Bedell.  Some rights reserved.

oscad="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
VORON_DIR=../Voron-2-2.4r1/STLs/VORON2.4
OUT_DIR=out
LOG=oscad.log

if [ ! -x $oscad ] ; then
  echo "No OpenSCAD binary found at $oscad.  Please update path."
  exit 1
fi

if [ ! -d $VORON_DIR ] ; then
  echo "STL's not found at $VORON_DIR.  Check path."
  exit 1
fi

# OpenSCAD Color schemes for normal & accent colors
accent_color=Sunset
normal_color=Tomorrow

accent_regex='^\[a\]'
count_regex='_x([0-9]+)\.stl'

function stl2png() {
  path="$1"
  stl="$2"
  color="$3"
  png=`basename -s .stl $stl`.png
  tmp=`basename -s .stl $stl`.oscad
  
  # FIXME: Extract dir path & re-make the tree
  mkdir -p $OUT_DIR/$path
  echo "import(\"$stl\");" > $tmp
  $oscad -o $OUT_DIR/$path/$png --imgsize=200,200 --colorscheme "$color" $tmp >> $LOG 2>&1
  rm -f $tmp
}

# See if blacklist file contains a match
function check_blacklist() {
  target="$1"
  if [ ! -f blacklist ] ; then
    echo "OK"
  else
    cat blacklist | while read bl ; do
      if [[ "$bl" == "#"* ]] ; then
        continue
      fi
      if [[ $target =~ ^${bl}.*$ ]] ; then
        echo "BL"
        break
      fi
    done
  fi
}

# rm -rf $OUT_DIR
rm -f $LOG
mkdir -p $OUT_DIR

cat > $OUT_DIR/index.html <<EOF
<html>
<head>
<title>Voron STL Print List</title>
<link rel="stylesheet" href="../style.css" type="text/css"/>
</head>
<body>
EOF

lastpath=""
find "${VORON_DIR}" -iname \*.stl | sort | while read f ; do
  fn=`basename "$f"`
  #stl2png b_drive_frame_upper.stl "Sunset"  
  if [[ $fn =~ $accent_regex ]] ; then
    color=$accent_color
  else
    color=$normal_color
  fi
  
  if [[ $fn =~ $count_regex ]] ; then
    count=${BASH_REMATCH[1]}
  else
    count=1
  fi
  
  # Get just the "section" part of the path - no leading path, no filename
  filename=`basename $f`
  basepath=${f#"$VORON_DIR"}
  basepath=${basepath#"/"}
  basepath=${basepath%"/"}
  path=${basepath%"$filename"}
  
  barename=`basename -s .stl $filename`
  png=`basename -s .stl $filename`.png

  
  ret=`check_blacklist $basepath`
  if [ "$ret" == "BL" ] ; then
    echo "Skipping blacklist item: $f"
    continue
  fi
  
  if [ "$lastpath" != "$path" ] ; then
    echo "NEW PATH: $path"
    lastpath=$path
    htmlpath=${path//\// ==> }
    echo "<div class=\"section\">$htmlpath</div>" >> $OUT_DIR/index.html
  fi
    
  if [ ! -f $OUT_DIR/${path}/${png} ] ; then
    echo "Generating `basename $f`"
    stl2png "$path" "$f" $color
  fi
  
  echo "<div class=\"part\"><img src=\"${path}/${png}\"/><br/>" >> $OUT_DIR/index.html
  echo "${barename}<br/>" >> $OUT_DIR/index.html
  echo "Printed: <span class=\"checklist\">" >> $OUT_DIR/index.html
  for (( c=1; c<=$count; c++ )) ; do
    echo "&#9744;" >> $OUT_DIR/index.html
  done
  echo "</span><br/>" >> $OUT_DIR/index.html
  if [ $count -gt 1 ] ; then
    echo "<span class=\"count\">${count}</span>" >> $OUT_DIR/index.html
  fi
  echo "</div>" >> $OUT_DIR/index.html
done

cat >> $OUT_DIR/index.html <<EOF
<!--Generated `date`-->
</body>
</html>
EOF

wkhtmltopdf --enable-local-file-access --page-size Letter --print-media-type out/index.html out/index.pdf
