#!/bin/bash

export HOSTNAME=$(hostname)

source ./config.sh

# Main Stream (High Resolution)
gst-launch-1.0 libcamerasrc ! \
video/x-raw,width=$width_main,height=$height_main,framerate=$framerate_main ! \
videoconvert ! \
textoverlay text="Main $HOSTNAME" valignment=top halignment=left font-desc="Sans, 10" xpos=10 ypos=10 ! \
clockoverlay time-format="%d-%m-%Y %H:%M.%S" valignment=bottom halignment=left font-desc="Sans, 10" xpos=10 ypos=-10 ! \
videoconvert ! jpegenc quality=$jpegenc_quality_main ! multipartmux ! queue ! \
tcpserversink host=$host port=$port_main \
2>/var/log/gstreamer-error-main.log &

# Preview Stream (Low Resolution)
gst-launch-1.0 libcamerasrc ! \
video/x-raw,width=$width_preview,height=$height_preview,framerate=$framerate_preview ! \
videoconvert ! \
textoverlay text="PREVIEW $HOSTNAME" valignment=top halignment=left font-desc="Sans, 10" xpos=10 ypos=10 ! \
clockoverlay time-format="%d-%m-%Y %H:%M.%S" valignment=bottom halignment=left font-desc="Sans, 10" xpos=10 ypos=-10 ! \
videoconvert ! jpegenc quality=jpegenc_quality_preview ! multipartmux ! queue ! \
tcpserversink host=$host port=$port_preview \
2>/var/log/gstreamer-error-preview.log &
