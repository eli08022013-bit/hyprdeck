pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property int percentage: 0
    property bool isCharging: false

    // Timer to poll battery status every 5 seconds
    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            capacityRead.exec({ command: ["cat", "/sys/class/power_supply/BAT0/capacity"] })
            statusRead.exec({ command: ["cat", "/sys/class/power_supply/BAT0/status"] })
        }
    }

    Process {
        id: capacityRead
        stdout: StdioCollector {
            onStreamFinished: root.percentage = parseInt(text.trim()) || 0
        }
    }

    Process {
        id: statusRead
        stdout: StdioCollector {
            onStreamFinished: root.isCharging = (text.trim() === "Charging")
        }
    }
}