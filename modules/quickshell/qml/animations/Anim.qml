pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property bool enabled: true

    // durations (ms)
    readonly property int fast: enabled ? 120 : 0
    readonly property int normal: enabled ? 220 : 0
    readonly property int slow: enabled ? 450 : 0

    // easing curves 
    readonly property int standard: Easing.OutCubic   // quick reactions
    readonly property int smooth: Easing.OutQuint     // long, soft slides
    readonly property int bounce: Easing.OutBack      // slight overshoot
}