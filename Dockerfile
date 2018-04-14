FROM thedrhax/android-sdk:latest

# x86 emulation requires hardware acceleration
# that requires access to /dev/kvm (--device /dev/kvm)
# that requires running as root
USER root

RUN apt-get update \
 && apt-get install -y libqt5widgets5 socat supervisor net-tools \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists /var/cache/apt

ENV ABI="x86_64" \
    TARGET="android-26" \
    TAG="google_apis" \
    NAME="Docker" \

    ANDROID_LOG_TAGS="e" \

    # Argument `-qemu -vnc :0` is required for VNC and noVNC to work
    # You can still override this variable: just add this argument to the end
    ANDROID_EMULATOR_EXTRA_ARGS="-skin 480x800 -qemu -vnc :0" \

    noVNC="false"

RUN mkdir -p ~/.android \
 && touch ~/.android/repositories.cfg \
 && $ANDROID_HOME/tools/bin/sdkmanager --verbose \
        "tools" \
        "platforms;${TARGET}" \
        "system-images;${TARGET};${TAG};${ABI}"

RUN git clone https://github.com/novnc/noVNC.git \
 && cd noVNC \
 && git checkout v0.6.2 \
 && git clone https://github.com/novnc/websockify.git utils/websockify

ADD container /
EXPOSE 5554 5555
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord"]
