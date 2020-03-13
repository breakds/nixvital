{ config, lib, pkgs, ... }:

{
  imports = [
    ./pnc_base.nix
  ];

  vital.machineType = "desktop";

  # +----------+
  # | Desktop  |
  # +----------+

  vital.desktop = {
    enable = true;
    xserver.displayManager = "lightdm";
    nvidia = {
      enable = true;
    };
    remote-desktop.enable = true;
  };

  # Enable nvidia-docker
  virtualisation.docker.enableNvidia = true;    
}


