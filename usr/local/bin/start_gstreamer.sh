#!/bin/bash

export HOSTNAME=$(hostname)

source ./config.sh

gst-launch-1.0 libcamerasrc ! \
video/x-raw,width=$width,height=$height,framerate=$framerate ! \
videoconvert ! \
textoverlay text="$HOSTNAME" valignment=top halignment=left font-desc="Sans, 10" xpos=10 ypos=10 ! \
clockoverlay time-format="%d-%m-%Y %H:%M.%S" valignment=bottom halignment=left font-desc="Sans, 10" xpos=10 ypos=-10 ! \
videoconvert ! jpegenc quality=$jpegenc_quality ! multipartmux ! queue ! \
tcpserversink host=$host port=$port \
2>/var/log/gstreamer-error.log
