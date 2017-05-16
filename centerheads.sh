#!/bin/sh

# only to show how it works

echo "Search for png files..."
PICS=$(find pics -maxdepth 1 -iname '*_bigger.png')

for PIC in $PICS; do
    echo "try to transform: $PIC"

    ./facedetect "$PIC" | while read x y w h; do
        echo "work on: $PIC"
        # convert "$file" -crop ${w}x${h}+${x}+${y} "path/to/faces/${name%.*}_${i}.${name##*.}"
        ./transform.pl $x $y $w $h $PIC
    done
done

