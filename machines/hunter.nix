{ config, pkgs, ... }:

{
  imports = [
    ./base
    ../nix-home/breakds
    ../modules/users
    ../modules/desktop
  ];

  vital.machineType = "laptop";
  vital.machineTags = [ "weride" ];  

  # Machine-specific networking configuration.
  networking.hostName = "hunter";
  # Generated via `head -c 8 /etc/machine-id`
  networking.hostId = "9e710e9b";

  # +----------+
  # | Desktop  |
  # +----------+

  vital.desktop = {
    enable = true;
    xserver = {
      displayManager = "sddm";
      i3_show_battery = true;
      dpi = 108;
      useCapsAsCtrl = true;
    };
    nvidia = {
      enable = true;
      prime = {
        enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:2:0:0";
      };
    };
    remote-desktop.enable = true;
  };

  # Enable nvidia-docker
  virtualisation.docker.enableNvidia = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
