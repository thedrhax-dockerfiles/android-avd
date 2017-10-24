FROM thedrhax/android-sdk:26.0.1

# x86 emulation requires hardware acceleration
# that requires access to /dev/kvm (--device /dev/kvm)
# that requires running as root
USER root

RUN apt-get update \
 && apt-get install -y libqt5widgets5 socat supervisor \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists /var/cache/apt

ENV ABI="x86_64" \
    TARGET="android-25" \
    TAG="google_apis" \
    NAME="Docker" \

    ANDROID_LOG_TAGS="e"

RUN mkdir -p ~/.android \
 && touch ~/.android/repositories.cfg \
 && $ANDROID_HOME/tools/bin/sdkmanager \
        "tools" \
        "platforms;${TARGET}" \
        "system-images;${TARGET};${TAG};${ABI}"

ADD container /
EXPOSE 5554 5555
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord"]
