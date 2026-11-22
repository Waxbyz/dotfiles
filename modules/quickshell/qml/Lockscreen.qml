import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pam

Scope {
    id: lockScope
    required property var shell
    required property var clockObj

    property string errorText: ""
    property bool authenticating: false

    PamContext {
        id: pam
        config: "login"

        onCompleted: result => {
            lockScope.authenticating = false;
            if (result === PamResult.Success) {
                lockScope.errorText = "";
                shell.sessionLocked = false;
            } else {
                lockScope.errorText = "invalid password";
            }
        }
    }

    function tryUnlock(password) {
        if (!password || lockScope.authenticating) return;
        lockScope.errorText = "";
        lockScope.authenticating = true;
        if (pam.start()) {
            pam.respond(password);
        } else {
            lockScope.authenticating = false;
            lockScope.errorText = "pam error";
        }
    }

    WlSessionLock {
        id: sessionLock
        locked: shell.sessionLocked

        WlSessionLockSurface {
            Rectangle {
                anchors.fill: parent
                color: shell.bg

                ColumnLayout {
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -60
                    spacing: 8

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: Qt.formatDateTime(clockObj.date, "HH:mm")
                        font.family: shell.fontFamily
                        font.pixelSize: 84
                        font.bold: true
                        color: shell.fg
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "[ " + Qt.formatDateTime(clockObj.date, "dddd, MMMM dd").toLowerCase() + " ]"
                        font.family: shell.fontFamily
                        font.pixelSize: 16
                        font.bold: true
                        color: shell.muted
                    }
                }

                ColumnLayout {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 80
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 10

                    RowLayout {
                        spacing: 8

                        Rectangle {
                            width: 44
                            height: 40
                            radius: 4
                            color: shell.bgAlt
                            border.color: shell.highlightMed
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: shell.kbLayout
                                font.family: shell.fontFamily
                                font.pixelSize: 12
                                font.weight: Font.Black
                                font.italic: true
                                color: shell.accentAlt
                            }
                        }

                        Rectangle {
                            width: 240
                            height: 40
                            radius: 4
                            color: shell.bgAlt
                            border.color: passInput.activeFocus ? shell.accent : shell.highlightMed
                            border.width: 1

                            TextInput {
                                id: passInput
                                anchors.fill: parent
                                anchors.leftMargin: 14
                                anchors.rightMargin: 14
                                verticalAlignment: TextInput.AlignVCenter
                                font.family: shell.fontFamily
                                font.pixelSize: 14
                                color: shell.fg
                                echoMode: TextInput.Password
                                passwordCharacter: "•"
                                focus: true
                                clip: true

                                onAccepted: {
                                    let pw = text;
                                    text = "";
                                    lockScope.tryUnlock(pw);
                                }
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 14
                                visible: passInput.text.length === 0
                                text: "password..."
                                font.family: shell.fontFamily
                                font.pixelSize: 12
                                color: shell.muted
                            }
                        }

                        Rectangle {
                            width: 80
                            height: 40
                            radius: 4
                            color: unlockArea.containsMouse ? shell.accentAlt : shell.accent

                            Text {
                                anchors.centerIn: parent
                                text: lockScope.authenticating ? "..." : "unlock"
                                font.family: shell.fontFamily
                                font.pixelSize: 12
                                font.bold: true
                                color: shell.bg
                            }

                            MouseArea {
                                id: unlockArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    let pw = passInput.text;
                                    passInput.text = "";
                                    lockScope.tryUnlock(pw);
                                    passInput.forceActiveFocus();
                                }
                            }
                        }
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        visible: lockScope.errorText !== ""
                        text: "[ " + lockScope.errorText + " ]"
                        font.family: shell.fontFamily
                        font.pixelSize: 11
                        font.bold: true
                        color: shell.red
                    }
                }
            }
        }
    }
}