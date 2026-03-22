pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: serviceroot

    readonly property string screenDevice: "intel_backlight"
    readonly property string kbdDevice: "chromeos::kbd_backlight"

    property real screenBright: 0.0
    property real kbdBright: 0.0

    readonly property bool screenAvailable: screenDevice !== ""
    readonly property bool kbdAvailable: kbdDevice !== ""

    Timer {
        id: pollTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: serviceroot.sync()
    }

    function sync() {
        if (screenAvailable)
            screenInfo.exec({ command: ["brightnessctl", "-d", screenDevice, "info", "-m"] })
        if (kbdAvailable)
            kbdInfo.exec({ command: ["brightnessctl", "-d", kbdDevice, "info", "-m"] })
    }

    function setScreenBrightness(value) {
        if (!screenAvailable) return
        var perc = Math.round(Math.max(0, Math.min(1, value)) * 100)
        setScreen.exec({ command: ["brightnessctl", "-d", screenDevice, "set", perc + "%"] })
        // immediately resync state
        serviceroot.sync()
    }

    function setKbdBrightness(value) {
        if (!kbdAvailable) return
        var perc = Math.round(Math.max(0, Math.min(1, value)) * 100)
        setKbd.exec({ command: ["brightnessctl", "-d", kbdDevice, "set", perc + "%"] })
        // immediately resync too
        serviceroot.sync()
    }

    Process {
        id: screenInfo
        stdout: StdioCollector {
            onStreamFinished: {
                var line = text.trim().split("\n")[0] || ""
                var parts = line.split(",")
                if (parts.length >= 5) {
                    var current = parseInt(parts[2])
                    var max     = parseInt(parts[4])
                    serviceroot.screenBright = max > 0 ? current / max : 0
                }
            }
        }
    }

    Process {
        id: kbdInfo
        stdout: StdioCollector {
            onStreamFinished: {
                var line = text.trim().split("\n")[0] || ""
                var parts = line.split(",")
                if (parts.length >= 5) {
                    var current = parseInt(parts[2])
                    var max     = parseInt(parts[4])
                    serviceroot.kbdBright = max > 0 ? current / max : 0
                }
            }
        }
    }

    Process { id: setScreen }
    Process { id: setKbd }
}
