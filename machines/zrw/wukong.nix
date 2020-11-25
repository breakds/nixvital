{ config, pkgs, ... }:

{
  imports = [
    ./base
    ../modules/users
    ../modules/desktop
    ../modules/IoT/apple-devices.nix
    ../modules/vm.nix
    ../modules/dev/python-environment.nix
  ];

  vital.machineType = "desktop";

  # +----------+
  # | Desktop  |
  # +----------+

  vital.desktop = {
    enable = true;
    xserver.displayManager = "gdm";
    xserver.dpi = 100;
  };

  # +-------------+
  # | Development |
  # +-------------+

  vital.dev.python = {
    batteries = {
      machineLearning = false;
    };
  };
}
