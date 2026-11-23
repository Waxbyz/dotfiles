import Quickshell

import "windows"
import "components/power"

Scope {
    Variants {
        model: Quickshell.screens

        Bar {
            required property var modelData
            screen: modelData

            rightItems: [ Power {} ]
        }
    }
}