{
  flake.modules.homeManager.user = {
    xdg.configFile."niri/config.kdl".text = ''
      spawn-at-startup "noctalia"

      output "HDMI-A-1" {
          mode "1920x1080@144.013"
      }

      input {
          keyboard {
              xkb {
                  layout "us,ru"
                  options "grp:alt_shift_toggle"
              }
          }
          mouse {
              accel-profile "flat"
          }
      }

      layout {
          gaps 12
          background-color "transparent"
          center-focused-column "never"

          preset-column-widths {
              proportion 0.5
              proportion 0.66667
              proportion 0.33333
          }

          focus-ring {
              width 2
              active-color "#7aa2f7"
              inactive-color "#414868"
          }
      }

      prefer-no-csd

      window-rule {
          geometry-corner-radius 16
          clip-to-geometry true
      }

      window-rule {
          match app-id="dev.noctalia.Noctalia"
          open-floating true
          default-column-width { fixed 1080; }
          default-window-height { fixed 920; }
      }

      layer-rule {
          match namespace="^noctalia-wallpaper"
          place-within-backdrop true
      }

      layer-rule {
          match namespace="^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$"
          background-effect {
              xray false
          }
      }

      layer-rule {
          match namespace="noctalia-window-switcher"
          background-effect {
              blur true
              xray false
          }
      }

      debug {
          honor-xdg-activation-with-invalid-serial
      }

      binds {
          Mod+Shift+Return { spawn "kitty"; }
          Mod+D { spawn-sh "noctalia msg panel-toggle launcher"; }
          Mod+N { spawn-sh "noctalia msg panel-toggle notifications"; }
          Mod+S { spawn-sh "noctalia msg panel-toggle control-center"; }
          Mod+Shift+Comma { spawn-sh "noctalia msg settings-toggle"; }
          Super+Alt+L { spawn-sh "noctalia msg session lock"; }
          Mod+Shift+Slash { show-hotkey-overlay; }
          Mod+Shift+E { quit; }
          Mod+Shift+P { power-off-monitors; }
          Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

          Alt+Tab { spawn-sh "noctalia msg window-switcher hold"; }
          Alt+Shift+Tab { spawn-sh "noctalia msg window-switcher hold reverse"; }

          Mod+Shift+C { close-window; }
          Mod+Shift+F { fullscreen-window; }
          Mod+F { maximize-column; }
          Mod+M { maximize-window-to-edges; }
          Mod+V { toggle-window-floating; }
          Mod+Shift+V { switch-focus-between-floating-and-tiling; }
          Mod+W { toggle-column-tabbed-display; }

          Mod+Left  { focus-column-left; }
          Mod+Right { focus-column-right; }
          Mod+Down  { focus-window-down; }
          Mod+Up    { focus-window-up; }
          Mod+Home  { focus-column-first; }
          Mod+End   { focus-column-last; }

          Mod+Ctrl+Left  { focus-monitor-left; }
          Mod+Ctrl+Right { focus-monitor-right; }
          Mod+Ctrl+Down  { focus-monitor-down; }
          Mod+Ctrl+Up    { focus-monitor-up; }

          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+5 { focus-workspace 5; }
          Mod+6 { focus-workspace 6; }
          Mod+7 { focus-workspace 7; }
          Mod+8 { focus-workspace 8; }
          Mod+9 { focus-workspace 9; }

          Mod+Shift+Left  { move-column-left; }
          Mod+Shift+Right { move-column-right; }
          Mod+Shift+Down  { move-window-down; }
          Mod+Shift+Up    { move-window-up; }

          Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
          Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
          Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
          Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }

          Mod+Shift+1 { move-column-to-workspace 1; }
          Mod+Shift+2 { move-column-to-workspace 2; }
          Mod+Shift+3 { move-column-to-workspace 3; }
          Mod+Shift+4 { move-column-to-workspace 4; }
          Mod+Shift+5 { move-column-to-workspace 5; }
          Mod+Shift+6 { move-column-to-workspace 6; }
          Mod+Shift+7 { move-column-to-workspace 7; }
          Mod+Shift+8 { move-column-to-workspace 8; }
          Mod+Shift+9 { move-column-to-workspace 9; }

          Mod+Ctrl+Home { move-column-to-first; }
          Mod+Ctrl+End  { move-column-to-last; }

          Mod+BracketLeft  { consume-or-expel-window-left; }
          Mod+BracketRight { consume-or-expel-window-right; }
          Mod+Comma        { consume-window-into-column; }
          Mod+Period       { expel-window-from-column; }

          Mod+O { toggle-overview; }
          Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
          Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
          Mod+Shift+WheelScrollDown { focus-column-right; }
          Mod+Shift+WheelScrollUp   { focus-column-left; }

          Mod+Shift+Page_Down { move-workspace-down; }
          Mod+Shift+Page_Up   { move-workspace-up; }
          Mod+Shift+U         { move-workspace-down; }
          Mod+Shift+I         { move-workspace-up; }

          Mod+R       { switch-preset-column-width; }
          Mod+Shift+R { switch-preset-window-height; }
          Mod+Ctrl+R  { reset-window-height; }
          Mod+Minus       { set-column-width "-5%"; }
          Mod+Equal       { set-column-width "+5%"; }
          Mod+Shift+Minus { set-window-height "-5%"; }
          Mod+Shift+Equal { set-window-height "+5%"; }
          Mod+C           { center-column; }
          Mod+Ctrl+F      { expand-column-to-available-width; }

          XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "noctalia msg volume-up"; }
          XF86AudioLowerVolume allow-when-locked=true { spawn-sh "noctalia msg volume-down"; }
          XF86AudioMute        allow-when-locked=true { spawn-sh "noctalia msg volume-mute"; }
          XF86AudioMicMute     allow-when-locked=true { spawn-sh "noctalia msg mic-mute"; }

          XF86AudioPlay allow-when-locked=true { spawn "playerctl" "play-pause"; }
          XF86AudioNext allow-when-locked=true { spawn "playerctl" "next"; }
          XF86AudioPrev allow-when-locked=true { spawn "playerctl" "previous"; }

          XF86MonBrightnessUp   allow-when-locked=true { spawn-sh "noctalia msg brightness-up"; }
          XF86MonBrightnessDown allow-when-locked=true { spawn-sh "noctalia msg brightness-down"; }

          Print  { screenshot-screen; }
          Alt+P  { screenshot-window; }
          Ctrl+P { screenshot; }
      }
    '';
  };
}