import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

Scope {
    id: barScope
    required property var shell
    required property var clockObj
    required property var runner
    required property var stats

    property bool blinkOn: true
    Timer {
        interval: 500
        running: shell.isRecording || (!shell.batCharging && shell.batLabel !== "" && shell.batCap <= 10)
        repeat: true
        onTriggered: barScope.blinkOn = !barScope.blinkOn
    }

    // Helper functions matching V2.9b warning/critical states
    function loadColor(val) {
        if (val >= 80) return shell.red;
        if (val >= 50) return shell.yellow;
        return shell.fg;
    }

    function volColor(val, muted) {
        if (muted || val <= 10) return shell.red;
        if (val >= 50) return shell.yellow;
        return shell.fg;
    }

    function pad2(n) {
        return n < 10 ? ("0" + n) : String(n);
    }

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

            // Bottom 1.5px border (#waybar > box)
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 2
                color: shell.highlightMed
            }

            // niri/workspaces + [ + tray + / + idle_inhibitor + rec + ] + [ mpris ]
            RowLayout {
                anchors.left: parent.left
                anchors.leftMargin: 6
                anchors.verticalCenter: parent.verticalCenter
                spacing: 4

                // niri/workspaces
                RowLayout {
                    spacing: 2
                    Repeater {
                        model: shell.workspaces
                        Rectangle {
                            required property var modelData
                            property bool isEmpty: modelData.active_window_id === null || modelData.active_window_id === undefined
                            width: 18
                            height: 18
                            color: modelData.is_active ? shell.accentAlt : "transparent"

                            Text {
                                anchors.centerIn: parent
                                text: modelData.idx
                                font.family: shell.fontFamily
                                font.pixelSize: 12
                                font.weight: Font.Black
                                color: modelData.is_active ? shell.bg : shell.fg
                                opacity: modelData.is_active ? 1.0 : (parent.isEmpty ? 0.4 : 1.0)
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: runner.exec(["niri", "msg", "action", "focus-workspace", String(modelData.idx)])
                            }
                        }
                    }
                }

                // custom/separator "["
                Text {
                    text: "["
                    font.family: shell.fontFamily
                    font.pixelSize: 14
                    font.bold: true
                    color: shell.fg
                    opacity: 0.25
                }

                // tray (visible only when items exist)
                RowLayout {
                    visible: SystemTray.items.values.length > 0
                    spacing: 4

                    Repeater {
                        model: SystemTray.items
                        Item {
                            required property var modelData
                            width: 14
                            height: 14

                            Image {
                                anchors.fill: parent
                                source: modelData.icon
                                sourceSize: Qt.size(14, 14)
                            }

                            MouseArea {
                                anchors.fill: parent
                                acceptedButtons: Qt.LeftButton | Qt.RightButton
                                cursorShape: Qt.PointingHandCursor
                                onClicked: mouse => {
                                    if (mouse.button === Qt.LeftButton)
                                        modelData.activate();
                                    else
                                        modelData.secondaryActivate();
                                }
                            }
                        }
                    }

                    // custom/separator7 "/" after tray
                    Text {
                        text: "/"
                        font.family: shell.fontFamily
                        font.pixelSize: 14
                        font.bold: true
                        color: shell.fg
                        opacity: 0.25
                    }
                }

                // idle_inhibitor: idle on / off
                RowLayout {
                    spacing: 4
                    opacity: shell.idleInhibited ? 1.0 : 0.5

                    Text {
                        text: "idle"
                        font.family: shell.fontFamily
                        font.pixelSize: 12
                        font.bold: true
                        color: shell.fg
                    }
                    Text {
                        text: shell.idleInhibited ? "on" : "off"
                        font.family: shell.fontFamily
                        font.pixelSize: 12
                        font.weight: Font.Black
                        font.italic: true
                        color: shell.accentAlt
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: shell.idleInhibited = !shell.idleInhibited
                    }
                }

                // custom/screenrecording-indicator (blinks red when wf-recorder is running)
                Text {
                    visible: shell.isRecording
                    text: "● rec"
                    font.family: shell.fontFamily
                    font.pixelSize: 12
                    font.bold: true
                    color: barScope.blinkOn ? shell.red : shell.bg

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: runner.exec(["pkill", "-SIGINT", "wf-recorder"])
                    }
                }

                // custom/separator2 "]"
                Text {
                    text: "]"
                    font.family: shell.fontFamily
                    font.pixelSize: 14
                    font.bold: true
                    color: shell.fg
                    opacity: 0.25
                }

                // mpris in [ ... ] only while playing or paused
                RowLayout {
                    visible: shell.mprisText !== ""
                    spacing: 4

                    Text {
                        text: "["
                        font.family: shell.fontFamily
                        font.pixelSize: 14
                        font.bold: true
                        color: shell.fg
                        opacity: 0.25
                    }

                    Text {
                        text: (shell.mprisState === "Paused" ? "󰏤 " : "󰎈 ") + shell.mprisText
                        font.family: shell.fontFamily
                        font.pixelSize: 12
                        font.bold: true
                        color: shell.mprisState === "Paused" ? shell.muted : shell.fg

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: runner.exec(["playerctl", "play-pause"])
                        }
                    }

                    Text {
                        text: "]"
                        font.family: shell.fontFamily
                        font.pixelSize: 14
                        font.bold: true
                        color: shell.fg
                        opacity: 0.25
                    }
                }
            }

            // [ 15:34 pm - thursday, oct 22 ]
            RowLayout {
                anchors.centerIn: parent
                spacing: 6

                Text {
                    text: "["
                    font.family: shell.fontFamily
                    font.pixelSize: 14
                    font.bold: true
                    color: shell.fg
                    opacity: 0.25
                }

                Text {
                    text: Qt.formatDateTime(clockObj.date, "HH:mm ap - dddd, MMM dd").toLowerCase()
                    font.family: shell.fontFamily
                    font.pixelSize: 12
                    font.bold: true
                    color: shell.fg
                }

                Text {
                    text: "]"
                    font.family: shell.fontFamily
                    font.pixelSize: 14
                    font.bold: true
                    color: shell.fg
                    opacity: 0.25
                }
            }

            // [ kb / bt / bl / bat / net / vol / mem / cpu ] + power
            RowLayout {
                anchors.right: parent.right
                anchors.rightMargin: 6
                anchors.verticalCenter: parent.verticalCenter
                spacing: 5

                Text {
                    text: "["
                    font.family: shell.fontFamily
                    font.pixelSize: 14
                    font.bold: true
                    color: shell.fg
                    opacity: 0.25
                }

                // Keyboard layout (us / ru)
                RowLayout {
                    spacing: 4
                    Text {
                        text: "󰌌 kb"
                        font.family: shell.fontFamily
                        font.pixelSize: 12
                        font.bold: true
                        color: shell.fg
                    }
                    Text {
                        text: shell.kbLayout
                        font.family: shell.fontFamily
                        font.pixelSize: 12
                        font.weight: Font.Black
                        font.italic: true
                        color: shell.accentAlt
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: runner.exec(["niri", "msg", "action", "switch-layout", "next"])
                    }
                }

                Text { text: "/"; font.family: shell.fontFamily; font.pixelSize: 14; font.bold: true; color: shell.fg; opacity: 0.25 }

                // Bluetooth: bt off / on
                RowLayout {
                    spacing: 4
                    Text {
                        text: "󰂯 bt"
                        font.family: shell.fontFamily
                        font.pixelSize: 12
                        font.bold: true
                        color: shell.fg
                    }
                    Text {
                        text: shell.btState + shell.btCount
                        font.family: shell.fontFamily
                        font.pixelSize: 12
                        font.weight: Font.Black
                        font.italic: true
                        color: shell.accentAlt
                    }
                }

                Text { text: "/"; font.family: shell.fontFamily; font.pixelSize: 14; font.bold: true; color: shell.fg; opacity: 0.25 }

                // Backlight: bl 100%
                Text {
                    text: "󰃠 bl " + shell.blVal
                    font.family: shell.fontFamily
                    font.pixelSize: 12
                    font.bold: true
                    color: shell.fg
                }

                // Battery (shown if BAT0 exists)
                RowLayout {
                    visible: shell.batLabel !== ""
                    spacing: 5
                    Text { text: "/"; font.family: shell.fontFamily; font.pixelSize: 14; font.bold: true; color: shell.fg; opacity: 0.25 }
                    Text {
                        text: "󰁹 " + shell.batLabel
                        font.family: shell.fontFamily
                        font.pixelSize: 12
                        font.bold: true
                        color: (!shell.batCharging && shell.batCap <= 10)
                            ? (barScope.blinkOn ? shell.red : shell.fg)
                            : (shell.batCap <= 20 ? shell.yellow : shell.fg)
                    }
                }

                Text { text: "/"; font.family: shell.fontFamily; font.pixelSize: 14; font.bold: true; color: shell.fg; opacity: 0.25 }

                // Network: net on / 80% / off
                RowLayout {
                    spacing: 4
                    Text {
                        text: "󰖩 net"
                        font.family: shell.fontFamily
                        font.pixelSize: 12
                        font.bold: true
                        color: shell.fg
                    }
                    Text {
                        text: shell.netVal
                        font.family: shell.fontFamily
                        font.pixelSize: 12
                        font.weight: Font.Black
                        font.italic: true
                        color: shell.accentAlt
                    }
                }

                Text { text: "/"; font.family: shell.fontFamily; font.pixelSize: 14; font.bold: true; color: shell.fg; opacity: 0.25 }

                // Pulseaudio / PipeWire: vol 32% or vol muted
                RowLayout {
                    spacing: 4
                    Text {
                        text: "󰕾 vol"
                        font.family: shell.fontFamily
                        font.pixelSize: 12
                        font.bold: true
                        color: barScope.volColor(shell.volNum, shell.volMuted)
                    }
                    Text {
                        text: shell.volMuted ? "muted" : (shell.volNum + "%")
                        font.family: shell.fontFamily
                        font.pixelSize: 12
                        font.weight: shell.volMuted ? Font.Black : Font.Bold
                        font.italic: shell.volMuted
                        color: shell.volMuted ? shell.accentAlt : barScope.volColor(shell.volNum, shell.volMuted)
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

                Text { text: "/"; font.family: shell.fontFamily; font.pixelSize: 14; font.bold: true; color: shell.fg; opacity: 0.25 }

                // Memory: mem 40%
                Text {
                    text: "󰍛 mem " + barScope.pad2(shell.memNum) + "%"
                    font.family: shell.fontFamily
                    font.pixelSize: 12
                    font.bold: true
                    color: barScope.loadColor(shell.memNum)
                }

                Text { text: "/"; font.family: shell.fontFamily; font.pixelSize: 14; font.bold: true; color: shell.fg; opacity: 0.25 }

                // CPU: cpu 02%
                Text {
                    text: " cpu " + barScope.pad2(shell.cpuNum) + "%"
                    font.family: shell.fontFamily
                    font.pixelSize: 12
                    font.bold: true
                    color: barScope.loadColor(shell.cpuNum)
                }

                Text {
                    text: "]"
                    font.family: shell.fontFamily
                    font.pixelSize: 14
                    font.bold: true
                    color: shell.fg
                    opacity: 0.25
                }

                // Power menu button
                Text {
                    text: "⏻"
                    font.family: shell.fontFamily
                    font.pixelSize: 13
                    font.bold: true
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

    // Power menu popup
    PanelWindow {
        visible: shell.powerMenuOpen
        anchors {
            top: true
            right: true
        }
        margins {
            top: 30
            right: 8
        }
        implicitWidth: 160
        implicitHeight: 136
        exclusiveZone: 0
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            color: shell.bg
            border.color: shell.highlightMed
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
                            font.pixelSize: 12
                            font.bold: true
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