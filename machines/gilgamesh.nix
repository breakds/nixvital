{ config, pkgs, ... }:

{
  imports = [
    ./base
    ../nix-home/breakds
    ../modules/users
    ../modules/users/zrw.nix
    ../modules/desktop
    ../modules/services/samba.nix
    ../modules/services/deluge.nix
    ../modules/services/nginx.nix
    ../modules/services/cgit.nix
    ../modules/services/homepage.nix
    ../modules/services/gitea.nix
    ../modules/services/filerun.nix
    ../modules/services/terraria.nix
    ../modules/services/jupyter-lab.nix
    ../modules/services/nix-serve.nix
    ../modules/dev/python-environment.nix
    # ../containers/declarative/hydrahead.nix
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
  # | Services   |
  # +------------+

  vital.homepage.enable = true;

  vital.bittorrent.enable = true;

  # Does not need it served right now.
  vital.cgit = {
    enable = false;
    title = "Break's Repos.";
    repoPath = "/home/delegator/cgits";
    syncRepo.enable = true;
  };

  vital.gitea.enable = true;

  vital.web = {
    enable = true;
    serveHydra = true;
  };

  vital.filerun = {
    enable = true;
    workDir = "/home/delegator/filerun";
  };

  vital.jupyter-lab = {
    enable = true;
    workspace = "/home/breakds/projects";
  };

  # For temporary serving something such as Jupyter Notebook.
  networking.firewall.allowedTCPPorts = [ 8888 ];

  # +-------------+
  # | Development |
  # +-------------+

  vital.dev.python = {
    batteries = {
      machineLearning = true;
      jupyterhub = true;
    };
  };

  # +------------+
  # | WakeOnLan  |
  # +------------+

  services.wakeonlan.interfaces = [{
    interface = "eno1";
  }];
}
