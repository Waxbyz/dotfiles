{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./config/base.nix
    ./config/users.nix
    ./config/boot.nix
    ./config/nvidia.nix
    ./config/sops.nix
    ./config/cleanup.nix
  ];
}