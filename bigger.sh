#!/bin/bash

echo "Search for all png files..."
PICS=$(find pics -iname '*.png')

for PIC in $PICS; do
    echo "convert to bigger: $PIC"
    BASENAME=$(basename $PIC)

    EXTENSION=${BASENAME#*.}
    JPGNAME="${BASENAME/.${EXTENSION}/.jpg}"
  
    convert $PIC -background white -gravity center -extent 600x600 pics/$JPGNAME
done
