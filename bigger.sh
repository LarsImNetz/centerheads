#!/bin/bash

echo "Search for all png files..."
PICS=$(find new-profiles -maxdepth 2 -iname '*.png')

mkdir -p bigger

for PIC in $PICS; do
    echo "convert to bigger: $PIC"
    BASENAME=$(basename $PIC)

    EXTENSION=${BASENAME#*.}
    PNGNAME="${BASENAME/.${EXTENSION}/_bigger.png}"
    read x y <<< $(identify -format '%w %h' $PIC)
    echo "width: ${x} height: ${y}"
    newx=$(( $x * 3 / 2))
    newy=$(( $y * 3 / 2))
    newgeometry="${newx}x${newy}"
    echo "new geometry: $newgeometry"
    convert $PIC -background transparent -gravity center -extent $newgeometry bigger/$PNGNAME
done
