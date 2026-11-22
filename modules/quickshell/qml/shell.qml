import QtQuick
import Quickshell
import Quickshell.Io

ShellRoot {
    id: root

    readonly property color bg: "#16161e"
    readonly property color bgAlt: "#1f2335"
    readonly property color borderCol: "#292e42"
    readonly property color fg: "#c0caf5"
    readonly property color muted: "#565f89"
    readonly property color blue: "#7aa2f7"
    readonly property color cyan: "#7dcfff"
    readonly property color orange: "#e0af68"
    readonly property color green: "#9ece6a"
    readonly property color red: "#f7768e"
    readonly property string fontFamily: "JetBrainsMono Nerd Font"

    property var workspaces: [{ id: 1, idx: 1, is_active: true }]
    property string activeTitle: ""
    property var kbNames: ["us", "ru"]
    property string kbLayout: "us"
    property bool idleInhibited: false
    property bool powerMenuOpen: false
    property bool sessionLocked: true

    property string btState: "off"
    property string blVal: "100%"
    property string netVal: "up"
    property string volVal: "50%"
    property string memVal: "00%"
    property string cpuVal: "00%"

    function shortLang(name) {
        let lower = (name || "").toLowerCase();
        if (lower.indexOf("rus") !== -1 || lower === "ru") return "ru";
        if (lower.indexOf("eng") !== -1 || lower === "us" || lower === "en") return "us";
        return lower.slice(0, 2) || "us";
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    IpcHandler {
        target: "lock"
        function lock(): void {
            root.sessionLocked = true;
        }
    }

    Process {
        id: niriStream
        command: ["niri", "msg", "--json", "event-stream"]
        running: true
        stdout: SplitParser {
            onRead: line => {
                try {
                    let ev = JSON.parse(line);
                    if (ev.KeyboardLayoutsChanged) {
                        let kl = ev.KeyboardLayoutsChanged.keyboard_layouts;
                        root.kbNames = kl.names;
                        root.kbLayout = root.shortLang(kl.names[kl.current_idx]);
                    } else if (ev.KeyboardLayoutSwitched) {
                        let idx = ev.KeyboardLayoutSwitched.idx;
                        if (idx < root.kbNames.length)
                            root.kbLayout = root.shortLang(root.kbNames[idx]);
                    }
                } catch (e) {}
                wsProc.running = true;
                winProc.running = true;
            }
        }
    }

    Process {
        id: wsProc
        command: ["niri", "msg", "--json", "workspaces"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    let list = JSON.parse(this.text.trim());
                    list.sort((a, b) => a.idx - b.idx);
                    root.workspaces = list;
                } catch (e) {}
            }
        }
    }

    Process {
        id: winProc
        command: ["niri", "msg", "--json", "focused-window"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    let w = JSON.parse(this.text.trim());
                    root.activeTitle = (w && w.title) ? w.title : "";
                } catch (e) {
                    root.activeTitle = "";
                }
            }
        }
    }

    Process {
        id: statsProc
        command: [
            "sh", "-c",
            "cpu=$(awk '/^cpu / {u=$2+$4; t=$2+$4+$5; if(t>0) printf \"%02d%%\", u*100/t}' /proc/stat); " +
            "mem=$(awk '/MemTotal/ {t=$2} /MemAvailable/ {a=$2} END {if(t>0) printf \"%02d%%\", (t-a)*100/t}' /proc/meminfo); " +
            "vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{if ($3==\"[MUTED]\") print \"mute\"; else printf \"%d%%\", $2*100}'); " +
            "net=$(nmcli -t -f TYPE,STATE dev 2>/dev/null | awk -F: '$2==\"connected\" {if($1==\"ethernet\") print \"eth\"; else if($1==\"wifi\") print \"wifi\"; exit}'); " +
            "bt=$(bluetoothctl show 2>/dev/null | awk '/Powered:/ {print ($2==\"yes\" ? \"on\" : \"off\")}'); " +
            "bl=$(brightnessctl -m 2>/dev/null | awk -F, '{print $4}'); " +
            "printf '%s|%s|%s|%s|%s|%s\\n' \"${cpu:-00%}\" \"${mem:-00%}\" \"${vol:-0%}\" \"${net:-off}\" \"${bt:-off}\" \"${bl:-100%}\""
        ]
        running: true
        stdout: SplitParser {
            onRead: line => {
                let p = line.trim().split("|");
                if (p.length >= 6) {
                    root.cpuVal = p[0];
                    root.memVal = p[1];
                    root.volVal = p[2];
                    root.netVal = p[3];
                    root.btState = p[4];
                    root.blVal = p[5];
                }
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            statsProc.running = true;
            wsProc.running = true;
            winProc.running = true;
        }
    }

    Process {
        id: cmdRunner
        function exec(args) {
            command = args;
            running = true;
        }
    }

    Bar {
        shell: root
        clockObj: clock
        runner: cmdRunner
        stats: statsProc
    }

    Lockscreen {
        shell: root
        clockObj: clock
    }
}