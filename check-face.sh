#!/bin/bash

# set -x

echo "Search for all png files..."
PICS=$(find new-profiles -maxdepth 2 -iname '*.png' | sort)

mkdir -p check-face
CHECKFILE=check-face/check-face.txt

touch $CHECKFILE

# count=10
for PIC in $PICS; do
    echo "check for face: $PIC"

#    count=$(( $count - 1))
#    if [ $count -le 0 ]; then
#        exit 1
#    fi

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
