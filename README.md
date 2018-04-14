# Android Virtual Device for Docker [![](https://images.microbadger.com/badges/image/thedrhax/android-avd.svg)](https://hub.docker.com/r/thedrhax/android-avd)

This image contains the latest version of Android SDK with configured AVD.

## Examples

* Basic usage

```bash
docker run -it --rm --name avd --device /dev/kvm thedrhax/android-avd

# Use ADB to interact with virtual device
docker exec -it avd adb shell
```

* Remote ADB connection

```bash
docker run -it --rm --device /dev/kvm -p 5554:5554 -p 5555:5555 thedrhax/android-avd

# Connect local ADB process to AVD (not required if both are on localhost)
adb connect IP_OF_AVD_CONTAINER_OR_HOST

# Use ADB to interact with virtual device
adb shell
```

* Automated instrumentation testing via Gradle, Android Studio, etc.

```bash
# Install socat
sudo apt-get install socat

# Bind container's port 5555 to localhost
socat tcp-listen:5555,bind=127.0.0.1,fork tcp:IP_OF_AVD_CONTAINER:5555 & PID=$!

# Run Gradle tests
gradle connectedAndroidTest
# or use ADB without connecting to remote AVD
adb shell
# or just use AVD in Android Studio

# Kill socat
kill $PID
```

* Interact with AVD via VNC

```bash
docker run -it --device /dev/kvm -p 5900:5900 thedrhax/android-avd

# Use any VNC client to connect to localhost:5900, for example:
ssvncviewer localhost:5900
```

* Interact with AVD via noVNC (HTML5 VNC client)

```bash
docker run -it --device /dev/kvm --env noVNC=true -p 6080:6080 thedrhax/android-avd

# Open http://localhost:6080/vnc.html in your browser
xdg-open http://localhost:6080/vnc.html
```

----

Note: `--device /dev/kvm` flag is required to enable CPU hardware acceleration.
You may also need to activate `kvm` kernel module on your host machine: `modprobe kvm`, or even install it first.
