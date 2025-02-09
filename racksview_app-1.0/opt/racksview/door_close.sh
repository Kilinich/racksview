#!/bin/bash

# Parameters
FLAGS_DIR="/opt/racksview/flags"

#set stop flag
mkdir -p "${FLAGS_DIR}" 2>/dev/null
touch "${FLAGS_DIR}"/stop.flg

#beep
python3 /opt/racksview/beep.py --config /etc/racksview/beep.ini --signal "door_close"
