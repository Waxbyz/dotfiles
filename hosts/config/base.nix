{ pkgs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Moscow";

  environment.systemPackages = with pkgs; [ vim git wget ];

  system.stateVersion = "26.05";
}