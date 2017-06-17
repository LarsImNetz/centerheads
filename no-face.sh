#!/bin/bash

# set -x

echo "Search for all png files..."
PICS=$(cat check-face/noface.txt)

mkdir -p check-face
CHECKFILE=check-face/no-faces.txt

touch $CHECKFILE

for PIC in $PICS; do
    echo "check for face: $PIC"

    BASENAME=$(basename $PIC)
    EXTENSION=${BASENAME#*.}
    PNGNAME="${BASENAME/.${EXTENSION}/.png}"

    ./facedetect -q $PIC
    FACE=$?

    read xp yp <<< $(identify -format '%w %h' $PIC)
    echo "$PIC width: ${xp} height: ${yp}"

    if [ $FACE -eq 0 ]; then
        ./facedetect -o check-face/$PNGNAME $PIC
        read x y w h <<< $(./facedetect $PIC)
        echo "$PIC GEOM $xp $yp FACE $x $y $w $h" >>$CHECKFILE
    else
        echo "# $PIC GEOM $xp $yp HANDMADE" >>$CHECKFILE
    fi
done
