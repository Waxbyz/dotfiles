import QtQuick
import Quickshell

import "../config"

PanelWindow {
    id: root

    property alias leftItems: left.data
    property alias centerItems: center.data
    property alias rightItems: right.data

    anchors {
        top: Config.barPosition === "top"
        bottom: Config.barPosition === "bottom"
        left: true
        right: true
    }
    implicitHeight: Config.barHeight
    color: Config.barBackground

    Rectangle {
        height: Config.barBorderWidth
        color: Config.barBorder
        anchors {
            left: parent.left
            right: parent.right
            bottom: Config.barPosition === "top" ? parent.bottom : undefined
            top: Config.barPosition === "bottom" ? parent.top : undefined
        }
    }

    Row {
        id: left
        spacing: Config.barSpacing
        anchors {
            left: parent.left
            leftMargin: Config.barPadding
            verticalCenter: parent.verticalCenter
        }
    }

    Row {
        id: center
        spacing: Config.barSpacing
        anchors.centerIn: parent
    }

    Row {
        id: right
        spacing: Config.barSpacing
        anchors {
            right: parent.right
            rightMargin: Config.barPadding
            verticalCenter: parent.verticalCenter
        }
    }
}