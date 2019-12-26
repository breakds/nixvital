{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
    ../nix-home
    ../modules/user.nix    
    ../modules/desktop
    ../modules/web
  ];

  vital.machineType = "desktop";

  # Machine-specific networking configuration.
  networking.hostName = "samaritan";
  # Generated via `head -c 8 /etc/machine-id`
  networking.hostId = "9c4a63a8";

  # +----------+
  # | Desktop  |
  # +----------+

  vital.desktop = {
    enable = true;
    xserver.displayManager = "gdm";
    xserver.dpi = 100;
    nvidia = {
      enable = true;
    };
  };
  
  # +------------+
  # | WakeOnLan  |
  # +------------+

  # services.wakeonlan.interfaces = [{
  #   interface = "eno1";
  # }];
}
