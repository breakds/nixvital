{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
    ../modules/desktop
    ../modules/weride.nix
  ];

  # Machine-specific networking configuration.
  networking.hostName = "hunter";
  # Generated via `head -c 8 /etc/machine-id`
  networking.hostId = "9e710e9b";

  # +----------+
  # | Desktop  |
  # +----------+

  bds.desktop = {
    enable = true;
    xserver.displayManager = "sddm";
    nvidia = {
      enable = true;
      prime = {
        enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:2:0:0";
      };
    };
  };

  services.xserver.dpi = 142;

  # +----------+
  # | Weride   |
  # +----------+

  bds.weride = {
    nasDevices."/media/nas" = {
      source = "//10.1.50.20/Public";
    };
    nasDevices."/media/us_nas_80t" = {
      source = "//10.1.50.20/80t";
    };
  };
  

  # Enable nvidia-docker
  virtualisation.docker.enableNvidia = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
