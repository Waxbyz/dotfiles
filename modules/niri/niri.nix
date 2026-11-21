{
  flake.modules.homeManager.user = {
    xdg.configFile."niri/config.kdl".text = ''
      spawn-at-startup "noctalia"

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
          Mod+Space { spawn-sh "noctalia msg panel-toggle launcher"; }
          Mod+S { spawn-sh "noctalia msg panel-toggle control-center"; }
          Mod+Comma { spawn-sh "noctalia msg settings-toggle"; }
          Mod+L { spawn-sh "noctalia msg session lock"; }
          Alt+Tab { spawn-sh "noctalia msg window-switcher hold"; }
          Alt+Shift+Tab { spawn-sh "noctalia msg window-switcher hold reverse"; }

          XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "noctalia msg volume-up"; }
          XF86AudioLowerVolume allow-when-locked=true { spawn-sh "noctalia msg volume-down"; }
          XF86AudioMute allow-when-locked=true { spawn-sh "noctalia msg volume-mute"; }
          XF86MonBrightnessUp allow-when-locked=true { spawn-sh "noctalia msg brightness-up"; }
          XF86MonBrightnessDown allow-when-locked=true { spawn-sh "noctalia msg brightness-down"; }

          Mod+Return { spawn "kitty"; }
          Mod+Q { close-window; }
          Mod+F { maximize-column; }
          Mod+Shift+F { fullscreen-window; }
          Mod+V { toggle-window-floating; }
          Mod+O { toggle-overview; }
          Print { screenshot; }

          Mod+Left  { focus-column-left; }
          Mod+Right { focus-column-right; }
          Mod+Down  { focus-window-down; }
          Mod+Up    { focus-window-up; }

          Mod+Shift+Left  { move-column-left; }
          Mod+Shift+Right { move-column-right; }
          Mod+Shift+Down  { move-window-down; }
          Mod+Shift+Up    { move-window-up; }

          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+5 { focus-workspace 5; }
          Mod+Shift+1 { move-column-to-workspace 1; }
          Mod+Shift+2 { move-column-to-workspace 2; }
          Mod+Shift+3 { move-column-to-workspace 3; }
          Mod+Shift+4 { move-column-to-workspace 4; }
          Mod+Shift+5 { move-column-to-workspace 5; }

          Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
          Mod+WheelScrollUp   cooldown-ms=150 { focus-workspace-up; }
          Mod+Shift+WheelScrollDown { focus-column-right; }
          Mod+Shift+WheelScrollUp   { focus-column-left; }

          Mod+Shift+E { quit; }
      }
    '';
  };
}