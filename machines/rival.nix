{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
    ../nix-home/breakds
    ../modules/users
    ../modules/desktop
  ];

  vital.machineType = "laptop";

  # Machine-specific networking configuration.
  networking.hostName = "rival";
  # Generated via `head -c 8 /etc/machine-id`
  networking.hostId = "efa94cac";

  # +----------+
  # | Desktop  |
  # +----------+

  vital.desktop = {
    enable = true;
    xserver.displayManager = "gdm";
  };

  vital.security.enableFingerprint = true;
}
