import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls

PanelWindow {
    id: osd

    width: 220
    color: "#2D353B"

    anchors {
        bottom: true
    }

    margins {
        bottom: 40
    }

    Timer {
        id: hideTimer
        interval: osd.timeout
        repeat: false
        onTriggered: osd.visible = false
    }

    function show() {
        osd.visible = true;
        hideTimer.running = false;
        hideTimer.running = true;
    }

    IpcHandler {
        target: "osd"

        function osdShow() { osd.show(); }
        function setLabel(newlabel: string) { osd.label = newlabel; }
        function setValue(newvalue: int) { osd.value = newvalue; }
        function setMaxValue(newmaxvalue: int) { osd.maxValue = newmaxvalue; }
        function setMode(newmode: string) { osd.mode = newmode; }
        function setTimeout(newtimeout: int) { osd.timeout = newtimeout; }
        function osd(newlabel: string, newvalue: int, newmaxvalue: int, newmode: string, newtimeout: int) {
            osd.label = newlabel;
            osd.value = newvalue;
            osd.maxValue = newmaxvalue;
            osd.mode = newmode;
            osd.timeout = newtimeout;
            osd.show();
        }
    }

    exclusionMode: ExclusionMode.Ignore

    property string label: "Volume" // label
    property int value: 50 // % of bar
    property int maxValue: 100 // max value of bar
    property string mode: "bar" // "text" | "bar" | "both"
    property int timeout: 3000 // timeout in ms

    height: content.implicitHeight + 24

    Column {
        id: content
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        // TEXT
        Text {
            visible: osd.mode === "text" || osd.mode === "both"

            text: label
            color: "#D3C6AA"
            font.pixelSize: 14

            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // BAR BACKGROUND
        Rectangle {
            visible: osd.mode === "bar" || osd.mode === "both"

            width: parent.width
            height: 10
            radius: 0
            color: "#3A4248"

            // FILL BAR
            Rectangle {
                anchors.left: parent.left
                height: parent.height
                radius: 0

                width: parent.width * (osd.value / osd.maxValue)
                color: "#A7C080"

                Behavior on width {
                    NumberAnimation { duration: 120 }
                }
            }
        }
    }
}