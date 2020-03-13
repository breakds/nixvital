{ config, pkgs, ... }:

{
  imports = [
    ./templates/t470p.nix
    ../nix-home/breakds
    ../modules/users
  ];

  vital.machineTags = [ "weride" ];  

  # Machine-specific networking configuration.
  networking.hostName = "hunter";
  # Generated via `head -c 8 /etc/machine-id`
  networking.hostId = "9e710e9b";

  # +----------+
  # | Desktop  |
  # +----------+

  vital.desktop = {
    xserver = {
      i3_show_battery = true;
      dpi = 108;
      useCapsAsCtrl = true;
    };
  };
}
