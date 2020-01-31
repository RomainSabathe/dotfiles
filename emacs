#!/bin/bash

xhost +local:
sudo docker run -it --rm \
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       -v /home/romain/:/home/app/ \
       -e DISPLAY=$DISPLAY \
       wenv_emacs

xhost -local:
