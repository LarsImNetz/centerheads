#!/bin/bash

echo "Search for all png files..."
PICS=$(find . -maxdepth 1 -iname '*_bigger_90.png')

for PIC in $PICS; do
    echo "convert to bigger: $PIC"
    BASENAME=$(basename $PIC)

    EXTENSION=${BASENAME#*.}
    PNGNAME="${BASENAME/_bigger_90.${EXTENSION}/.png}"
  
    convert $PIC -background transparent -gravity center -extent 260x270 $PNGNAME
done
