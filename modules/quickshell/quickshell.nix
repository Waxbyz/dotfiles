{
  flake.modules.homeManager.user = {
    xdg.configFile."quickshell".source = ./qml;

    xdg.configFile."fuzzel/fuzzel.ini".text = ''
      [main]
      font=JetBrainsMono Nerd Font:size=11
      prompt="> "
      terminal=kitty
      width=40
      lines=10
      horizontal-pad=16
      vertical-pad=12
      inner-pad=8

      [colors]
      background=16161eff
      text=c0caf5ff
      match=7aa2f7ff
      selection=1f2335ff
      selection-text=c0caf5ff
      selection-match=7dcfffff
      border=7aa2f7ff

      [border]
      width=2
      radius=4
    '';

    xdg.configFile."mako/config".text = ''
      font=JetBrainsMono Nerd Font 10
      background-color=#16161e
      text-color=#c0caf5
      border-color=#7aa2f7
      border-size=2
      border-radius=4
      default-timeout=5000
      margin=10
      padding=12
    '';
  };
}