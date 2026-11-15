{
  boot.loader = {
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      extraEntries = ''
        menuentry "Windows" {
          insmod part_gpt
          insmod fat
          insmod chain
          search --fs-uuid --set=root F4E2-812C
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
    };
  };
}