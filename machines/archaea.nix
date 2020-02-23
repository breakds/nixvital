{ config, pkgs, ... }:

{
  imports = [
    ./base
    ../nix-home/breakds
    ../modules/users
    ../modules/desktop
    ../modules/IoT/monitor-camera.nix
  ];

  vital.machineType = "laptop";

  # Machine-specific networking configuration.
  networking.hostName = "archaea";
  # Generated via `head -c 8 /etc/machine-id`
  networking.hostId = "867ce369";

  # +----------+
  # | Desktop  |
  # +----------+

  vital.desktop = {
    enable = true;
    xserver.displayManager = "gdm";
    xserver.i3_show_battery = true;
  };

  # +----------------+
  # | Camera/Monitor |
  # +----------------+

  vital.monitor-camera = {
    enable = true;
    device = "/dev/video0";
    fps = 15;
    clipDir = "/home/breakds/.motionclips";
    remoteDir = "/home/breakds/filerun/user-files/Monitor";
    remoteHost = "breakds@gilgamesh";
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?
}
