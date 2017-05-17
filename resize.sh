#!/bin/bash

echo "Search for all png files..."
PICS=$(find . -maxdepth 1 -iname '*_bigger_90.png')

for PIC in $PICS; do
    echo "convert resize: $PIC"
    BASENAME=$(basename $PIC)

    EXTENSION=${BASENAME#*.}
    PNGNAME="${BASENAME/_bigger_90.${EXTENSION}/.png}"
  
#     convert $PIC -background transparent -gravity center -extent 260x270 $PNGNAME
    convert $PIC -filter spline -resize 260x270 -unsharp 0x1 $PNGNAME
done
