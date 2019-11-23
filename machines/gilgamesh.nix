{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
    ../nix-home
    ../modules/user.nix    
    ../modules/desktop
    ../modules/web
    ../modules/deluge.nix
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
    xserver.dpi = 100;
    nvidia = {
      # Enable this when it is no longer broken in nixos.
      enable = true;
    };
    remote-desktop.enable = true;
  };
  
  # +------------+
  # | Web Server |
  # +------------+

  bds.web = {
    enable = true;
    serveHomePage = true;
    serveFilerun = true;
    cgit = {
      enable = true;
      title = "Break's Repos.";
      servedUrl = "git.breakds.org";
      repoPath = "/home/delegator/cgits";
      syncRepo.enable = true;
    };
  };

  bds.bittorrent.enable = true;
}
