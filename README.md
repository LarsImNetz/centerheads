!create centered heads

You need a "runable" facedetect from https://github.com/wavexx/facedetect.git

Simple copy the facedetect into this directory

Within Gentoo, patch facedetect by change

 -DATA_DIR = '/usr/share/opencv/'
 +DATA_DIR = '/usr/share/OpenCV/'

copy your files into pics directory.

run centerheads.sh

You will find centered heads in this directory.

