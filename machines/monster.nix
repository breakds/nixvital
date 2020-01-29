{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
    ../nix-home/breakds
    ../modules/user.nix
    ../modules/desktop
    ../modules/weride.nix
    ../modules/web
  ];

  vital.machineType = "desktop";
  vital.machineTags = [ "weride" ];

  # Machine-specific networking configuration.
  networking.hostName = "monster";
  # Generated via `head -c 8 /etc/machine-id`
  networking.hostId = "dc9749f8";

  # +----------+
  # | Desktop  |
  # +----------+

  vital.desktop = {
    enable = true;
    # TODO(breakds): Figure out why without this line build will fail.
    xserver.displayManager = "gdm";
    nvidia.enable = true;
  };

  # +----------+
  # | Weride   |
  # +----------+

  vital.weride = {
    nasDevices."/media/nas" = {
      source = "//10.1.50.20/Public";
      credentials = "/home/breakds/.ussmbcredentials";
    };
    nasDevices."/media/us_nas_80t" = {
      source = "//10.1.50.20/80t";
      credentials = "/home/breakds/.ussmbcredentials";
    };
    nasDevices."/media/gz_nas_50t" = {
      source = "//10.18.50.20/Public";
      credentials = "/home/breakds/.gzsmbcredentials";
    };
    nasDevices."/media/gz_nas_80t" = {
      source = "//10.18.50.20/80t";
      credentials = "/home/breakds/.gzsmbcredentials";
    };
  };

  # Enable nvidia-docker
  virtualisation.docker.enableNvidia = true;

  # +------------+
  # | Web Server |
  # +------------+

  vital.web = {
    enable = true;
    cgit = {
      enable = true;
      title = "PnC's Misc Git Server.";
      servedUrl = "monster";
      repoPath = "/home/git";
      syncRepo.enable = true;
    };
  };

  # Just for public access
  networking.firewall.allowedTCPPorts = [ 7777 ];

  # +------------+
  # | WakeOnLan  |
  # +------------+

  services.wakeonlan.interfaces = [{
    interface = "enp0s25";
  }];
}
