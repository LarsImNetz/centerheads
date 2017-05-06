#!/bin/sh

# only to show how it works

PICS=$(find pics -iname '*.jpg')

for PIC in $PICS; do

    FACE_DIM=$(./facedetect $PIC)

    echo $FACE_DIM

    # jpegtran -crop 751x751+79+352 -copy none -outfile output.jpg pics/P1040804.JPG
    ./transform.pl $FACE_DIM $PIC
done
