{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
    ../nix-home
    ../modules/desktop
  ];

  # Machine-specific networking configuration.
  networking.hostName = "archaea";
  # Generated via `head -c 8 /etc/machine-id`
  networking.hostId = "867ce369";

  # +----------+
  # | Desktop  |
  # +----------+

  bds.desktop = {
    enable = true;
    xserver.displayManager = "gdm";
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?
}
