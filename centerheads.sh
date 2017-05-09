#!/bin/sh

# only to show how it works

echo "Search for jpg files..."
PICS=$(find pics -iname '*.jpg')

for PIC in $PICS; do
    echo "try to transform: $PIC"

    i=$#PIC
    facedetect "$PIC" | while read x y w h; do
        echo "work on: $i really on $PIC"
        # convert "$file" -crop ${w}x${h}+${x}+${y} "path/to/faces/${name%.*}_${i}.${name##*.}"
        ./transform.pl $x $y $w $h $PIC
        i=$(($i-1))
    done  
done

# echo "Resize pictures..."
# for PIC in $PICS; do
#     echo "resize: $PIC"
#     BASENAME=$(basename $PIC)
# 
#     EXTENSION=${BASENAME#*.}
#     PNGNAME="${BASENAME/.${EXTENSION}/.png}"
# 
#     convert $PIC -resize 260x270 -fuzz 2% -transparent white $PNGNAME
# done
