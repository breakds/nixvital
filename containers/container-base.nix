# Credit to KJ Orbekk
# https://git.orbekk.com/nixos-config.git/tree/config/container.nix

{ config, lib, pkgs, ... }:

{
  boot.isContainer = true;

  # Use ssh as the main communication channel.
  services = {
    openssh.enable = lib.mkDefault true;
    openssh.passwordAuthentication = false;
  };

  security.sudo.wheelNeedsPassword = false;

  users.defaultUserShell = lib.mkForce pkgs.bash;

  system.activationScripts.installInitScript = ''
    ln -fs $systemConfig/init /init
    mkdir -p /sbin/init || true
    ln -fs $systemConfig/init /sbin/init
  '';  

  boot.specialFileSystems."/dev/pts" = {
    options = lib.mkAfter [ "ptmxmode=666" ];
  };
}
