#!/bin/sh

# only to show how it works

PICS=$(find pics -iname '*.jpg')

for PIC in $PICS; do
    FACE_DIMENSION=$(./facedetect $PIC)
    ./transform.pl $FACE_DIMENSION $PIC
done
