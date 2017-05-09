#!/bin/sh

# only to show how it works

echo "Search for jpg files..."
PICS=$(find pics -iname '*.jpg')

for PIC in $PICS; do
    echo "try to transform: $PIC"
#    oIFS="$IFS"
#    IFS=$'\n'
    FACE_DIMENSION=$(./facedetect $PIC)
    if [ -n "$FACE_DIMENSION" ]; then
        ./transform.pl $FACE_DIMENSION $PIC
    else
        echo "ERROR: can't identify face on: $PIC"
    fi
       
#     for A in $FACE_DIMENSION; do
#         echo "Face: $A"
#         o2IFS="$IFS"
#         IFS="$oIFS"
#         
#         IFS="$o2IFS"
#     done
done

echo "Resize pictures..."
for PIC in $PICS; do
    echo "resize: $PIC"
    BASENAME=$(basename $PIC)

    EXTENSION=${BASENAME#*.}
    PNGNAME="${BASENAME/.${EXTENSION}/.png}"

    convert $PIC -resize 260x270 -fuzz 2% -transparent white $PNGNAME
done
