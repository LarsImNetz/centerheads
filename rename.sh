#!/bin/sh

PICS=$(find . -iname '*.png')
for PIC in $PICS; do
    BASENAME=$(basename $PIC)
    echo $BASENAME
    # mv $PIC _$BASENAME
done
