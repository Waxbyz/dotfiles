import QtQuick
import Quickshell
import Quickshell.Io

ShellRoot {
    id: root

    readonly property color bg: "#16161e"
    readonly property color bgAlt: "#1f2335"
    readonly property color highlightMed: "#292e42"
    readonly property color fg: "#c0caf5"
    readonly property color muted: "#565f89"
    readonly property color accent: "#7aa2f7"
    readonly property color accentAlt: "#7dcfff"
    readonly property color yellow: "#e0af68"
    readonly property color green: "#9ece6a"
    readonly property color red: "#f7768e"
    readonly property string fontFamily: "JetBrainsMono Nerd Font"

    property var workspaces: [{ id: 1, idx: 1, is_active: true, active_window_id: 1 }]
    property var kbNames: ["us", "ru"]
    property string kbLayout: "us"
    property bool idleInhibited: false
    property bool isRecording: false
    property string mprisState: ""
    property string mprisText: ""

    property string btState: "off"
    property string btCount: ""
    property string blVal: "100%"
    property string batLabel: ""
    property int batCap: 100
    property bool batCharging: true
    property string netVal: "on"
    property int volNum: 50
    property bool volMuted: false
    property int memNum: 0
    property int cpuNum: 0

    property bool powerMenuOpen: false
    property bool sessionLocked: false

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

    // Real-time Niri event stream for workspaces and keyboard layout
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

    // Periodic collector for CPU, Mem, Audio, Network, Bluetooth, Backlight, Battery, MPRIS, wf-recorder
    Process {
        id: statsProc
        command: [
            "sh", "-c",
            "cpu=$(awk '/^cpu / {u=$2+$4; t=$2+$4+$5; if(t>0) printf \"%d\", u*100/t}' /proc/stat); " +
            "mem=$(awk '/MemTotal/ {t=$2} /MemAvailable/ {a=$2} END {if(t>0) printf \"%d\", (t-a)*100/t}' /proc/meminfo); " +
            "volline=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null); " +
            "vol=$(echo \"$volline\" | awk '{printf \"%d\", $2*100}'); " +
            "muted=$(echo \"$volline\" | grep -q MUTED && echo 1 || echo 0); " +
            "net=$(nmcli -t -f TYPE,STATE dev 2>/dev/null | awk -F: '$2==\"connected\" {if($1==\"ethernet\") print \"on\"; else if($1==\"wifi\") print \"wifi\"; exit}'); " +
            "if [ \"$net\" = \"wifi\" ]; then sig=$(nmcli -t -f IN-USE,SIGNAL dev wifi 2>/dev/null | awk -F: '$1==\"*\" {print $2\"%\"; exit}'); net=${sig:-on}; fi; " +
            "bt=$(bluetoothctl show 2>/dev/null | awk '/Powered:/ {print ($2==\"yes\" ? \"on\" : \"off\")}'); " +
            "btcnt=$(bluetoothctl devices Connected 2>/dev/null | wc -l); " +
            "bl=$(brightnessctl -m 2>/dev/null | awk -F, '{print $4}'); " +
            "if [ -d /sys/class/power_supply/BAT0 ]; then " +
            "  bcap=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 100); " +
            "  bst=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo Full); " +
            "else bcap=-1; bst=None; fi; " +
            "rec=$(pgrep -x wf-recorder >/dev/null && echo 1 || echo 0); " +
            "pstat=$(playerctl status 2>/dev/null || echo Stopped); " +
            "if [ \"$pstat\" = \"Playing\" ] || [ \"$pstat\" = \"Paused\" ]; then " +
            "  pmeta=$(playerctl metadata --format '{{artist}} - {{title}}' 2>/dev/null | cut -c1-24); " +
            "else pmeta=\"\"; fi; " +
            "printf '%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s\\n' " +
            "\"${cpu:-0}\" \"${mem:-0}\" \"${vol:-0}\" \"$muted\" \"${net:-off}\" \"${bt:-off}\" \"${btcnt:-0}\" \"${bl:-100%}\" \"$bcap\" \"$bst\" \"$rec\" \"$pstat\" \"$pmeta\""
        ]
        running: true
        stdout: SplitParser {
            onRead: line => {
                let p = line.trim().split("|");
                if (p.length >= 13) {
                    root.cpuNum = parseInt(p[0]) || 0;
                    root.memNum = parseInt(p[1]) || 0;
                    root.volNum = parseInt(p[2]) || 0;
                    root.volMuted = (p[3] === "1");
                    root.netVal = p[4] || "off";
                    root.btState = p[5] || "off";
                    root.btCount = (p[5] === "on" && parseInt(p[6]) > 0) ? (" " + p[6]) : "";
                    root.blVal = p[7] || "100%";
                    let bcap = parseInt(p[8]);
                    let bst = p[9];
                    if (bcap >= 0) {
                        root.batCap = bcap;
                        root.batCharging = (bst === "Charging" || bst === "Full");
                        let prefix = (bst === "Full") ? "bat_f" : (bst === "Not charging" ? "bat_p" : "bat");
                        root.batLabel = prefix + " " + bcap + "%";
                    } else {
                        root.batLabel = "";
                    }
                    root.isRecording = (p[10] === "1");
                    root.mprisState = p[11];
                    root.mprisText = p[12];
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