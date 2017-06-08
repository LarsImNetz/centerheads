# create centered heads

## Requirements
You need a "runable" facedetect from https://github.com/wavexx/facedetect.git

### Ubuntu
facedetect need opencv to work, to install opencv in ubuntu: follow this really good guide: http://www.pyimagesearch.com/2016/10/24/ubuntu-16-04-how-to-install-opencv/

### Gentoo
Build opencv with: emerge opencv

Copy facedetect into this directory.

Patch this facedetect script by change

    -DATA_DIR = '/usr/share/opencv/'
    +DATA_DIR = '/usr/share/OpenCV/'


## run centerheads
Copy your images with faces into the pics folder.

    # centerheads.sh

You will find your images with centered heads in this directory.

This is just a proof of concept.

No guarantee that it works as you expect.
