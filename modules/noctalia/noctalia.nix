{ inputs, ... }:
{
  flake.modules.homeManager.user = {
    imports = [ inputs.noctalia.homeModules.default ];

    programs.noctalia = {
      enable = true;
      settings = {
        theme = {
          mode = "dark";
          source = "wallpaper";
        };
        wallpaper = {
          enabled = true;
          directory = "${../../assets/wallpapers}";
          default.path = "${../../assets/wallpapers/001.png}";
        };
        shell = {
          niri_overview_type_to_launch_enabled = true;
          niri_overview_close_on_launch_enabled = true;
        };
      };
    };
  };
}