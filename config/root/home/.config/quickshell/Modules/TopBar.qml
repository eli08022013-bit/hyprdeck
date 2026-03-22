import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: bar
    height: 40
    color: '#2D353B'

    anchors {
        top: true
        right: true
        left: true
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 0

        RowLayout {
            Layout.alignment: Qt.AlignLeft
            spacing: 8
            
            Text {
                id: settingsIcon
                text: "󰐥" 
                font.family: "JetBrainsMono Nerd Font" 
                font.pixelSize: 18
                color: "#D3C6AA" 

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        logout.show();
                    }
                }
            }

            RowLayout {
                spacing: 4

                Text {
                    id: volumeIcon
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 18
                    color: "#D3C6AA"

                    text: {
                        if (audio.muted || audio.volume === 0) return '󰝟' 
                        if (audio.volume < 0.33) return '󰕿' 
                        if (audio.volume < 0.66) return '󰖀' 
                        return '󰕾' // High
                    }
                }

                Text {
                    id: volumePerc
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 13
                    color: "#D3C6AA"

                    text: {
                        if (audio.muted || audio.volume === 0) return '' 
                        if (audio.volume < 0.33) return audio.percentage+'%'
                        if (audio.volume < 1.66) return audio.percentage+'%'
                        return audio.percentage+'%'
                    }
                }
            }

            RowLayout {
                spacing: 4

                Text {
                    id: brightIcon
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 18
                    color: "#D3C6AA"
                    text: {
                        if (bright.screenBright < 0.33) return '󰽥'
                        if (bright.screenBright < 0.66) return '󰃞'
                        return '󰃠'
                    }
                }
            }

            RowLayout {
                spacing: 5

                Repeater {
                    model: Hyprland.workspaces.values.filter(ws => !ws.name.startsWith("special:"))

                    delegate: Rectangle {
                        required property var modelData

                        implicitWidth: 16
                        implicitHeight: 16
                        radius: 8

                        color: modelData.focused ? "#7FBBB3" : "#3A515D"

                        Text {
                            color: modelData.focused ? "#232A2E" : "#D3C6AA"
                            text: modelData.id
                            anchors.centerIn: parent
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 13
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: modelData.activate() 
                        }
                    }
                }  
            }      
        }

    	Item { Layout.fillWidth: true }

        RowLayout {
            Layout.alignment: Qt.AlignRight
            spacing: 12

            RowLayout {
                spacing: 4
                Text {
                    id: batteryIcon
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 18
                    color: "#D3C6AA"
                    
                    text: {
                        if (battery.isCharging) return '󰂄'
                        if (battery.percentage <= 5)  return '󰂃'
                        if (battery.percentage <= 10) return '󰁺'
                        if (battery.percentage <= 20) return '󰁻'
                        if (battery.percentage <= 30) return '󰁼'
                        if (battery.percentage <= 40) return '󰁽'
                        if (battery.percentage <= 50) return '󰁾'
                        if (battery.percentage <= 60) return '󰁿'
                        if (battery.percentage <= 70) return '󰂀'
                        if (battery.percentage <= 80) return '󰂁'
                        if (battery.percentage <= 90) return '󰂂'
                        return '󰁹'
                    }
                }

                Text {
                    text: battery.isCharging ? 'AC󱐋' : battery.percentage + "%"
                    font.pixelSize: 14
                    color: "#D3C6AA"
                }
            }

            RowLayout {
                spacing: 6

                Text {
                    id: ncIcon
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 18
                    color: "#D3C6AA"
                    text: nc.dnd ? "󰂛" : "󰂚"
                }

                Text {
                    visible: nc.count > 0
                    text: nc.count > 0 ? nc.count : ""
                    font.pixelSize: 14 
                    font.bold: true
                    color: "#D3C6AA"
                }
            }

            Text {
                id: clock
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 14
                color: "#D3C6AA"
                
                text: Qt.formatDateTime(new Date(), "hh:mm ap")
                
                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: clock.text = Qt.formatDateTime(new Date(), "hh:mm ap")
                }
            }
        }
    }
}
