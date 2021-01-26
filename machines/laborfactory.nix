{ config, pkgs, ... }:

{
  imports = [
    ./base
    ../nix-home/breakds
    ../modules/users
    ../modules/desktop
    ../modules/dev/python-environment.nix
    ../modules/IoT/apple-devices.nix
    ../modules/binary-caches/gilgamesh.nix
  ];

  vital.machineType = "laptop";

  vital.dev.python = {
    batteries.machineLearning = false;
  };

  # +----------+
  # | Desktop  |
  # +----------+

  vital.desktop = {
    enable = true;
    xserver.displayManager = "lightdm";
    xserver.dpi = 108;
    nvidia = {
      enable = true;
      prime = {
        enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  # +----------+
  # | Extras   |
  # +----------+

  environment.systemPackages = with pkgs; [
    filezilla
  ];
}
