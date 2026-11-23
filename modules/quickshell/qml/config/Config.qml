pragma Singleton

import QtQuick
import Quickshell

Singleton {
    // bar
    readonly property string barPosition: "top"   // "top" | "bottom"
    readonly property int barHeight: 24
    readonly property int barPadding: 8
    readonly property int barSpacing: 8
    readonly property int barBorderWidth: 1

    readonly property color barBackground: Theme.bg
    readonly property color barBorder: Theme.dim
}