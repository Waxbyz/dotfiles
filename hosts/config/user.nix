{ config, ... }:
let
  vars = import ../../vars.nix;
in
{
  users.users.${vars.username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
    hashedPasswordFile = config.sops.secrets.user-password.path;
  };
}