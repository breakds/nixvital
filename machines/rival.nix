{ config, pkgs, ... }:

{
  imports = [
    ./base
    ../nix-home/breakds
    ../modules/users
    ../modules/desktop
    ../modules/vm.nix
    ../modules/dev/python-environment.nix
    ../modules/binary-caches/gilgamesh.nix
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

  vital.dev.python.batteries = {
   machineLearning = false;
  };
}
