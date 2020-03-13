{ config, lib, pkgs, ... }:

{
  imports = [
    ../base
    ../../modules/desktop
  ];

  # +----------+
  # | Desktop  |
  # +----------+

  vital.machineType = "laptop";

  vital.desktop = {
    enable = true;
    xserver.displayManager = "sddm";
    xserver.dpi = lib.mkOptionDefault 120;
    xserver.useCapsAsCtrl = lib.mkOptionDefault false;
    nvidia = {
      enable = true;
      prime = {
        enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:2:0:0";
      };
    };
  };

  # Enable nvidia-docker
  virtualisation.docker.enableNvidia = true;    
}
