import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

PanelWindow {
    id: logout
    width: 67
    height: 270
    color: "#2D353B"
    
    anchors {
        left: true
    }

    margins {
        left: 40
    }

    Process {
        id: commandRunner
    }

    IpcHandler {
        target: "logout"

        function showMenu() { logout.show(); }
    }

    exclusionMode: ExclusionMode.Normal
    exclusiveZone: 0 
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    // State to track selection
    property int currentIndex: 0
    readonly property var actions: [
        { icon: '󰐥', cmd: "poweroff" },
        { icon: '󰑐', cmd: "reboot" },
        { icon: '󰽥', cmd: "systemctl suspend" },
        { icon: '󰌾', cmd: "/home/eli/.local/bin/hyprlock" }, // or hyprlock
        { icon: '󰗽', cmd: "hyprctl dispatch exit" }
    ]

    function show() {
        logout.WlrLayershell.keyboardFocus = WlrKeyboardFocus.Exclusive
        logout.visible = true
    }

    function hide() {
        logout.WlrLayershell.keyboardFocus = WlrKeyboardFocus.None
        logout.visible = false
    }

    function runCommand(cmd) {
        commandRunner.command = ["sh", "-c", cmd];
        commandRunner.running = true
        logout.hide();
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        focus: true
        Component.onCompleted: forceActiveFocus()

        Keys.onPressed: (event) => {
        if (event.key === Qt.Key_J || event.key === Qt.Key_Down) {
                currentIndex = (currentIndex + 1) % actions.length;
            } else if (event.key === Qt.Key_K || event.key === Qt.Key_Up) {
                currentIndex = (currentIndex - 1 + actions.length) % actions.length;
            } else if (event.key === Qt.Key_Return) {
                logout.runCommand(actions[currentIndex].cmd)
            } else if (event.key === Qt.Key_Escape) {
                logout.hide()
            }
        }

        Repeater {
            model: logout.actions
            
            delegate: Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                // The Visual Selector (Highlight)
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 4
                    radius: 0
                    color: "#475258"
                    border.color: "#A7C080"
                    border.width: 1

                    opacity: logout.currentIndex === index ? 1.0 : 0.0
                    
                    Behavior on opacity { NumberAnimation { duration: 100; easing.type: Easing.OutQuad } }
                }

                Text {
                    anchors.centerIn: parent
                    text: modelData.icon
                    font.pixelSize: 28
                    color: logout.currentIndex === index ? "#A7C080" : "#D3C6AA"
                }

                // Mouse Interaction
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: logout.currentIndex = index
                    onClicked: runCommand(modelData.cmd);
                }
            }
        }
    }
}
