# Android Virtual Device for Docker [![](https://images.microbadger.com/badges/image/thedrhax/android-avd.svg)](https://hub.docker.com/r/thedrhax/android-avd)

This image contains the latest version of Android SDK with configured AVD.

# Example

```bash
docker run -it --device /dev/kvm -p 5554:5554 -p 5555:5555 thedrhax/android-avd
```

The `--device /dev/kvm` flag is required to enable CPU hardware acceleration.
You may also need to activate `kvm` kernel module on your host machine: `modprobe kvm`, or even install it first.

## Connecting to AVD from other containers/computers

* `adb connect 127.0.0.1` or `adb connect IP_OF_AVD_CONTAINER`
* `adb devices` or `adb shell`

## AVD detection in Gradle, Android Studio, etc.

To make automatic detection of this AVD possible, you will need to install `socat` first: `apt-get install socat`. Then just run this command to connect your local 5555 port to the container:

```
socat tcp-listen:5555,bind=127.0.0.1,fork tcp:IP_OF_AVD_CONTAINER:5555
```

This is a reversed version of script used to publish AVD's ports. While socat is running, your ADB server will be able to detect AVD automatically (just like any Android device connected via USB).

### Automatic instrumentation testing example:

```bash
# Start socat in the background and remember PID of this process
socat tcp-listen:5555,bind=127.0.0.1,fork tcp:IP_OF_AVD_CONTAINER:5555 &
PID=$!

# Run automated instrumentation tests with Gradle
gradle connectedAndroidTest

# Kill socat process
kill $PID
```
