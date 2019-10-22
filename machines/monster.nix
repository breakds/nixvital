{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
    ../modules/desktop
    ../modules/weride.nix
  ];

  # Machine-specific networking configuration.
  networking.hostName = "monster";
  # Generated via `head -c 8 /etc/machine-id`
  networking.hostId = "9d4ecfbfb";

  # +----------+
  # | Desktop  |
  # +----------+

  bds.desktop = {
    enable = true;
    xserver.displayManager = "gdm";
  };

  # Enable nvidia-docker
  virtualisation.docker.enableNvidia = true;
}
