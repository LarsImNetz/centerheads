#!/bin/bash

# set -x

echo "Search for all png files..."
PICS=$(find new-profiles -maxdepth 2 -iname '*.png' | sort)

mkdir -p check-face
CHECKFILE=check-face/check-face.txt

touch $CHECKFILE

count=10
for PIC in $PICS; do
    echo "check for face: $PIC"

    count=$(( $count - 1))
    if [ $count -le 0 ]; then
        exit 1
    fi

    BASENAME=$(basename $PIC)
    EXTENSION=${BASENAME#*.}
    PNGNAME="${BASENAME/.${EXTENSION}/_wo.png}"

    ./facedetect -q $PIC
    FACE=$?

    if [ $FACE -eq 0 ]; then
        read xp yp <<< $(identify -format '%w %h' $PIC)
        echo "$PIC width: ${xp} height: ${yp}"

        ./facedetect -o check-face/$PNGNAME $PIC
        read x y w h <<< $(./facedetect $PIC)
#        echo "$PIC GEOM $xp $yp FACE $x $y $w $h" >>$CHECKFILE
#    else
#        echo "# $PIC NO-FACE fail with error: $FACE" >>$CHECKFILE
    fi
done
