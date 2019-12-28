{ config, pkgs, ... }:

{
  imports = [
    ../base.nix
    ../../modules/user.nix
    ../../modules/desktop
    ../../modules/web
  ];

  vital.machineType = "desktop";

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

  services.wakeonlan.interfaces = [{
    interface = "eno1";
  }];
}
