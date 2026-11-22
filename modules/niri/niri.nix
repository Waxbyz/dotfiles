{
  flake.modules.homeManager.user = {
    xdg.configFile."niri/config.kdl".text = ''
      spawn-at-startup "quickshell"
      spawn-at-startup "mako"
      spawn-at-startup "sh" "-c" "swww-daemon & sleep 0.5 && swww img ${../../assets/wallpapers/001.png}"

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
          gaps 14
          center-focused-column "never"

          preset-column-widths {
              proportion 0.5
              proportion 0.66667
              proportion 0.33333
          }

          focus-ring {
              off
          }

          border {
              on
              width 2
              active-color "#7aa2f7"
              inactive-color "#292e42"
          }
      }

      prefer-no-csd

      window-rule {
          geometry-corner-radius 4
          clip-to-geometry true
      }

      binds {
          Mod+Shift+Return { spawn "kitty"; }
          Mod+D { spawn "fuzzel"; }
          Mod+N { spawn "makoctl" "restore"; }
          Mod+Alt+L { spawn "quickshell" "ipc" "call" "lock" "lock"; }
          Mod+Shift+Slash { show-hotkey-overlay; }
          Mod+Shift+E { quit; }
          Mod+Shift+P { power-off-monitors; }
          Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

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

          XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "-l" "1.0" "@DEFAULT_AUDIO_SINK@" "5%+"; }
          XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
          XF86AudioMute        allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
          XF86AudioMicMute     allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }

          XF86AudioPlay allow-when-locked=true { spawn "playerctl" "play-pause"; }
          XF86AudioNext allow-when-locked=true { spawn "playerctl" "next"; }
          XF86AudioPrev allow-when-locked=true { spawn "playerctl" "previous"; }

          XF86MonBrightnessUp   allow-when-locked=true { spawn "brightnessctl" "set" "5%+"; }
          XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "set" "5%-"; }

          Print  { screenshot-screen; }
          Alt+P  { screenshot-window; }
          Ctrl+P { screenshot; }
      }
    '';
  };
}