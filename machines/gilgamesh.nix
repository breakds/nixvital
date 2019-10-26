{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
    ../modules/desktop
    ../modules/web
    # TODO(breakds): Bring it up
    # ../modules/web/filerun.nix
  ];

  # Machine-specific networking configuration.
  networking.hostName = "gilgamesh";
  # Generated via `head -c 8 /etc/machine-id`
  networking.hostId = "7a4bd408";

  # +----------+
  # | Desktop  |
  # +----------+

  bds.desktop = {
    enable = true;
    xserver.displayManager = "gdm";
    nvidia = {
      # Enable this when it is no longer broken in nixos.
      enable = false;
    };
  };

  # +------------+
  # | Web Server |
  # +------------+

  bds.web.enable = true;
  bds.web.cgit = {
    enable = true;
    title = "Break's Repos.";
    servedUrl = "git.breakds.org";
    repoPath = "/home/delegator/cgits";
  };
}
