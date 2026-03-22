pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: serviceroot

    property var clients: []
    property int activeWorkspace: -1

    Timer {
        id: refreshTimer
        interval: 500
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            clientsProcess.running = true
            activeProcess.running = true
        }
    }

    Process {
        id: clientsProcess
        command: ["hyprctl", "-j", "clients"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const raw = JSON.parse(text)
                    serviceroot.clients = raw.map(c => ({
                        address: c.address,
                        title: c.title,
                        class: c.class,
                        workspace: c.workspace?.id ?? -1,
                        mapped: c.mapped
                    }))
                } catch(e) {
                    serviceroot.clients = []
                }
            }
        }
    }

    Process {
        id: activeProcess
        command: ["hyprctl", "-j", "activeworkspace"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    serviceroot.activeWorkspace = JSON.parse(text).id
                } catch(e) {
                    serviceroot.activeWorkspace = -1
                }
            }
        }
    }

    function focusWindow(address) {
        dynamicProc.createObject(serviceroot, {
            command: ["hyprctl", "dispatch", "focuswindow", "address:" + address],
            running: true
        })
    }

    function closeWindow(address) {
        dynamicProc.createObject(serviceroot, {
            command: ["hyprctl", "dispatch", "closewindow", "address:" + address],
            running: true
        })
    }

    function moveToWorkspace(address) {
        dynamicProc.createObject(serviceroot, {
            command: [
                "hyprctl", "dispatch", "movetoworkspace",
                serviceroot.activeWorkspace + ",address:" + address
            ],
            running: true
        })
    }

    Component {
        id: dynamicProc
        Process {}
    }
}