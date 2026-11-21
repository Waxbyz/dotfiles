let
  vars = import ../vars.nix;
in
{
  flake.modules.homeManager.user = { pkgs, ... }: {
    home.username = vars.username;
    home.homeDirectory = "/home/${vars.username}";
    home.stateVersion = "26.05";

    home.packages = with pkgs; [
      kitty
      wl-clipboard
      brightnessctl
      playerctl
      xwayland-satellite
      discord
    ];
  };
}