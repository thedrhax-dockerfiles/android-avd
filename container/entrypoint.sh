#!/bin/sh -x

echo n | $ANDROID_HOME/tools/bin/avdmanager create avd \
    -k "system-images;${TARGET};${TAG};${ABI}" \
    -n ${NAME} -b ${ABI} -g ${TAG}

exec $*
