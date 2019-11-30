{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
    ../nix-home
    ../modules/user.nix
    ../modules/desktop
    ../modules/laptop.nix
  ];

  bds.machineType = "laptop";

  # Machine-specific networking configuration.
  networking.hostName = "rival";
  # Generated via `head -c 8 /etc/machine-id`
  networking.hostId = "efa94cac";

  # +----------+
  # | Desktop  |
  # +----------+

  bds.desktop = {
    enable = true;
    xserver.displayManager = "gdm";
  };

  bds.security.enableFingerprint = true;
}
