{ config, pkgs, ... }:

{
  imports = [
    ./base
    ../modules/users
    ../modules/desktop
  ];

  vital.machineType = "laptop";

  # +----------+
  # | Desktop  |
  # +----------+

  vital.desktop = {
    enable = true;
    xserver.displayManager = "gdm";
  };

  vital.security.enableFingerprint = true;
}
