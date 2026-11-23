import QtQuick
import Quickshell

import "../../config"
import "../../animations"

Rectangle {
    id: root

    // behavior
    property string icon: "\uf011"
    property var command: ["systemctl", "poweroff"]

    // style 
    property int iconSize: 14
    property int hPadding: 8
    property color idleBg: Qt.alpha(Theme.danger, 0)   // same hue, fully transparent
    property color hoverBg: Theme.danger
    property color idleFg: Theme.fg
    property color hoverFg: Theme.bg

    implicitWidth: glyph.implicitWidth + hPadding * 2
    implicitHeight: Config.barHeight - Config.barBorderWidth
    radius: Theme.radius
    color: area.containsMouse ? hoverBg : idleBg

    // animations
    Behavior on color { ColorAnim {} }

    Text {
        id: glyph
        anchors.centerIn: parent
        text: root.icon
        color: area.containsMouse ? root.hoverFg : root.idleFg
        font { family: Theme.fontFamily; pixelSize: root.iconSize }

        Behavior on color { ColorAnim {} }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached(root.command)
    }
}