{
  boot.loader = {
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
    timeout = 5;

    grub.enable = false;

    visor = {
      enable = true;
      configurationLimit = 5;
      entryName = "NixOS #{gen}";
      windowsChainload = false;

      wallpaper = ../../assets/wallpapers/001.png;

      extraEntries = [
        {
          priority = -10;
          name = "Windows 11";
          icon = "\\EFI\\visor\\icons\\windows.png";
          kernel = "\\EFI\\Microsoft\\Boot\\bootmgfw.efi";
          uuid = "57dbb402-1302-4ef2-b613-e03b6eee1fa4";
        }
      ];

      icons = {
        nixos = ../../assets/icons/systems/nixos_1.png
      };

      settings = {
        resolution = "max";
        quiet = true;

        logo_mode = "none";
        title = "none";

        clock = false;

        mouse = true;
        mouse_speed = 11;

        power_icons = true;
        power_icon_size = 44;
        power_position = "bottomright";
        shutdown_icon = "\\EFI\\visor\\icons\\power_shutdown.png";
        reboot_icon = "\\EFI\\visor\\icons\\power_reboot.png";
        firmware_icon = "\\EFI\\visor\\icons\\power_bios.png";

        blur = 1;
        blur_title = true;
        accent = true;
        accent_variant = "vibrant";
        accent_icons = true;
      };
    };
  };
}
