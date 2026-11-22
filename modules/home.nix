let
  vars = import ../vars.nix;
in
{
  flake.modules.homeManager.user = { pkgs, ... }: {
    home.username = vars.username;
    home.homeDirectory = "/home/${vars.username}";
    home.stateVersion = "26.05";

    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      niri
      quickshell
      kitty
      fuzzel
      swww
      mako
      wl-clipboard
      brightnessctl
      playerctl
      wireplumber
      libnotify
      xwayland-satellite
      discord
      jetbrains-mono
      nerd-fonts.jetbrains-mono
    ];
  };
}