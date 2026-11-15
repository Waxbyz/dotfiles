let
  vars = import ../../vars.nix;
in
{
  flake.modules.homeManager.user = {
    programs.git = {
      enable = true;
      settings.user = {
        name = vars.fullName;
        email = vars.email;
      };
    };
  };
}