{
  boot.loader = {
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
    timeout = 5;

    visor = {
      enable = true;
      configurationLimit = 5;
      entryName = "NixOS ({date})";
      windowsChainload = false;

      wallpaper = ./assets/wallpapers/001.png;

      extraEntries = [
        {
          priority = -10;
          name = "Windows 11";
          icon = "\\EFI\\visor\\icons\\windows.png";
          kernel = "\\EFI\\Microsoft\\Boot\\bootmgfw.efi";
          uuid = "57dbb402-1302-4ef2-b613-e03b6eee1fa4";
        }
      ];

      settings = {
        resolution = "native";
        quiet = true;

        clock = false;

        mouse = true;
        mouse_speed = 4;

        power_icons = true;
        power_icon_size = 44;
        power_position = "bottomright";

        blur = 1;
        blur_title = true;
        accent = true;
        accent_variant = "vibrant";
        accent_icons = true;
      };
    };
  };
}