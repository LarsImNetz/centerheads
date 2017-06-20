#!/bin/sh

./check-face.sh

mkdir -p new-image

./transform2.pl check-face/check-face.txt

./resize.sh
