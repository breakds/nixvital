{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
    ../nix-home/breakds
    ../modules/user.nix
    ../modules/desktop
    ../modules/web
    ../modules/deluge.nix
    ../modules/web/samba.nix
    ../modules/web/gitea.nix
    # TODO(breakds): Bring it up
    # ../modules/web/filerun.nix
    ../containers/declarative/hydrahead.nix
  ];

  vital.machineType = "server";

  # Machine-specific networking configuration.
  networking.hostName = "gilgamesh";
  # Generated via `head -c 8 /etc/machine-id`
  networking.hostId = "7a4bd408";

  # +----------+
  # | Desktop  |
  # +----------+

  vital.desktop = {
    enable = true;
    xserver.displayManager = "gdm";
    # Since it will be connected with remote desktop often.
    xserver.useCapsAsCtrl = true;
    xserver.dpi = 100;
    nvidia = {
      # Enable this when it is no longer broken in nixos.
      enable = true;
    };
  };

  # +------------+
  # | Web Server |
  # +------------+

  vital.web = {
    enable = true;
    serveHomePage = true;
    serveFilerun = true;
    serveHydra = true;
    cgit = {
      enable = true;
      title = "Break's Repos.";
      servedUrl = "git.breakds.org";
      repoPath = "/home/delegator/cgits";
      syncRepo.enable = true;
    };
  };

  vital.gitea.enable = true;

  # +------------+
  # | WakeOnLan  |
  # +------------+

  services.wakeonlan.interfaces = [{
    interface = "eno1";
  }];

  vital.bittorrent.enable = true;
}
