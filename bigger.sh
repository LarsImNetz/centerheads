#!/bin/bash

echo "Search for all png files..."
PICS=$(find pics -maxdepth 1 -iname '*.png')

for PIC in $PICS; do
    echo "convert to bigger: $PIC"
    BASENAME=$(basename $PIC)

    EXTENSION=${BASENAME#*.}
    PNGNAME="${BASENAME/.${EXTENSION}/_bigger.png}"
  
    convert $PIC -background transparent -gravity center -extent 600x600 pics/$PNGNAME
done
