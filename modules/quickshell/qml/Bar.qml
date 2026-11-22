import QtQuick
import QtQuick.Layouts
import Quickshell

Scope {
    id: barScope
    required property var shell
    required property var clockObj
    required property var runner
    required property var stats

    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }
            implicitHeight: 26
            color: shell.bg

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: shell.borderCol
            }

            RowLayout {
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                spacing: 6

                Repeater {
                    model: shell.workspaces
                    Rectangle {
                        required property var modelData
                        width: 18
                        height: 18
                        radius: 2
                        color: modelData.is_active ? shell.blue : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: modelData.idx
                            font.family: shell.fontFamily
                            font.pixelSize: 11
                            font.bold: modelData.is_active
                            color: modelData.is_active ? shell.bg : shell.muted
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: runner.exec(["niri", "msg", "action", "focus-workspace", String(modelData.idx)])
                        }
                    }
                }

                RowLayout {
                    spacing: 0
                    Text { text: "[ "; font.family: shell.fontFamily; font.pixelSize: 11; color: shell.muted }
                    Text { text: "󰅶 idle "; font.family: shell.fontFamily; font.pixelSize: 11; color: shell.fg }
                    Text {
                        text: shell.idleInhibited ? "on" : "off"
                        font.family: shell.fontFamily
                        font.pixelSize: 11
                        font.bold: true
                        color: shell.idleInhibited ? shell.green : shell.blue
                    }
                    Text { text: " ]"; font.family: shell.fontFamily; font.pixelSize: 11; color: shell.muted }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: shell.idleInhibited = !shell.idleInhibited
                    }
                }

                RowLayout {
                    spacing: 0
                    Text { text: "[ "; font.family: shell.fontFamily; font.pixelSize: 11; color: shell.muted }
                    Text {
                        text: shell.activeTitle.length > 40 ? shell.activeTitle.slice(0, 40) + "…" : shell.activeTitle
                        font.family: shell.fontFamily
                        font.pixelSize: 11
                        color: shell.fg
                    }
                    Text { text: " ]"; font.family: shell.fontFamily; font.pixelSize: 11; color: shell.muted }
                }
            }

            RowLayout {
                anchors.centerIn: parent
                spacing: 0
                Text { text: "[ "; font.family: shell.fontFamily; font.pixelSize: 11; color: shell.muted }
                Text {
                    text: Qt.formatDateTime(clockObj.date, "hh:mm ap - dddd, MMM d").toLowerCase()
                    font.family: shell.fontFamily
                    font.pixelSize: 11
                    color: shell.fg
                }
                Text { text: " ]"; font.family: shell.fontFamily; font.pixelSize: 11; color: shell.muted }
            }

            RowLayout {
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                spacing: 6

                Text { text: "/"; font.family: shell.fontFamily; font.pixelSize: 11; color: shell.muted }
                RowLayout {
                    spacing: 4
                    Text { text: "󰌌 kb"; font.family: shell.fontFamily; font.pixelSize: 11; color: shell.fg }
                    Text {
                        text: shell.kbLayout
                        font.family: shell.fontFamily
                        font.pixelSize: 11
                        font.bold: true
                        color: shell.green
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: runner.exec(["niri", "msg", "action", "switch-layout", "next"])
                    }
                }

                Text { text: "/"; font.family: shell.fontFamily; font.pixelSize: 11; color: shell.muted }
                Text { text: "󰂯 bt"; font.family: shell.fontFamily; font.pixelSize: 11; color: shell.fg }
                Text { text: shell.btState; font.family: shell.fontFamily; font.pixelSize: 11; font.bold: true; color: shell.blue }

                Text { text: "/"; font.family: shell.fontFamily; font.pixelSize: 11; color: shell.muted }
                Text { text: "󰃠 bl"; font.family: shell.fontFamily; font.pixelSize: 11; color: shell.fg }
                Text { text: shell.blVal; font.family: shell.fontFamily; font.pixelSize: 11; color: shell.fg }

                Text { text: "/"; font.family: shell.fontFamily; font.pixelSize: 11; color: shell.muted }
                Text { text: "󰖩 net"; font.family: shell.fontFamily; font.pixelSize: 11; color: shell.fg }
                Text { text: shell.netVal; font.family: shell.fontFamily; font.pixelSize: 11; font.bold: true; color: shell.cyan }

                Text { text: "/"; font.family: shell.fontFamily; font.pixelSize: 11; color: shell.muted }
                RowLayout {
                    spacing: 4
                    Text { text: "󰕾 vol"; font.family: shell.fontFamily; font.pixelSize: 11; color: shell.orange }
                    Text {
                        text: shell.volVal
                        font.family: shell.fontFamily
                        font.pixelSize: 11
                        font.bold: true
                        color: shell.volVal === "mute" ? shell.red : shell.orange
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            runner.exec(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]);
                            stats.running = true;
                        }
                        onWheel: wheel => {
                            if (wheel.angleDelta.y > 0)
                                runner.exec(["wpctl", "set-volume", "-l", "1.0", "@DEFAULT_AUDIO_SINK@", "5%+"]);
                            else
                                runner.exec(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-"]);
                            stats.running = true;
                        }
                    }
                }

                Text { text: "/"; font.family: shell.fontFamily; font.pixelSize: 11; color: shell.muted }
                Text { text: "󰍛 mem"; font.family: shell.fontFamily; font.pixelSize: 11; color: shell.fg }
                Text { text: shell.memVal; font.family: shell.fontFamily; font.pixelSize: 11; color: shell.fg }

                Text { text: "/"; font.family: shell.fontFamily; font.pixelSize: 11; color: shell.muted }
                Text { text: " cpu"; font.family: shell.fontFamily; font.pixelSize: 11; color: shell.fg }
                Text { text: shell.cpuVal; font.family: shell.fontFamily; font.pixelSize: 11; color: shell.fg }

                Text { text: "/"; font.family: shell.fontFamily; font.pixelSize: 11; color: shell.muted }
                Text {
                    text: "⏻"
                    font.family: shell.fontFamily
                    font.pixelSize: 12
                    color: shell.red
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: shell.powerMenuOpen = !shell.powerMenuOpen
                    }
                }
            }
        }
    }

    PanelWindow {
        visible: shell.powerMenuOpen
        anchors {
            top: true
            right: true
        }
        margins {
            top: 32
            right: 10
        }
        implicitWidth: 160
        implicitHeight: 136
        exclusiveZone: 0
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            color: shell.bg
            border.color: shell.borderCol
            border.width: 1
            radius: 4

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 4

                Repeater {
                    model: [
                        { label: "󰌾  lock", act: "lock" },
                        { label: "󰍃  logout", act: "logout" },
                        { label: "󰜉  reboot", act: "reboot" },
                        { label: "⏻  poweroff", act: "poweroff" }
                    ]

                    Rectangle {
                        required property var modelData
                        Layout.fillWidth: true
                        height: 26
                        radius: 2
                        color: itemArea.containsMouse ? shell.bgAlt : "transparent"

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 8
                            text: modelData.label
                            font.family: shell.fontFamily
                            font.pixelSize: 11
                            color: shell.fg
                        }

                        MouseArea {
                            id: itemArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                shell.powerMenuOpen = false;
                                if (modelData.act === "lock") shell.sessionLocked = true;
                                else if (modelData.act === "logout") runner.exec(["niri", "msg", "action", "quit"]);
                                else if (modelData.act === "reboot") runner.exec(["systemctl", "reboot"]);
                                else if (modelData.act === "poweroff") runner.exec(["systemctl", "poweroff"]);
                            }
                        }
                    }
                }
            }
        }
    }
}