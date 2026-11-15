let
  vars = import ../vars.nix;
in
{
  flake.modules.homeManager.user = {
    home.username = vars.username;
    home.homeDirectory = "/home/${vars.username}";
    home.stateVersion = "26.05";
  };
}