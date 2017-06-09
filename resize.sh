#!/bin/bash

echo "Search for all png files..."
PICS=$(find new-image -maxdepth 1 -iname '*_bigger.png')

for PIC in $PICS; do
    echo "convert resize: $PIC"
    BASENAME=$(basename $PIC)

    EXTENSION=${BASENAME#*.}
    PNGNAME="${BASENAME/_bigger.${EXTENSION}/.png}"
  
#     convert $PIC -background transparent -gravity center -extent 260x270 $PNGNAME
    convert $PIC -filter spline -resize 480x480 -unsharp 0x1 $PNGNAME
done
