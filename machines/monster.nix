{ config, pkgs, ... }:

{
  imports = [
    ./base
    ../nix-home/breakds
    ../modules/users
    ../modules/desktop
    ../modules/weride.nix
    ../modules/services/gitea.nix
    ../modules/services/nginx.nix
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

  vital.gitea = {
    enable = true;
    domain = "monster.corp.weride.ai";
    useSSL = false;    
    appName = "Username: pnc, Password: pncpnc";
    landingPage = "home";
  };

  vital.web = {
    enable = true;
  };

  # Note that 8888 is allowed for IDE
  # And 7777 is allowed for arbitrary uses
  networking.firewall.allowedTCPPorts = [ 8888 7777 ];

  # +------------+
  # | WakeOnLan  |
  # +------------+

  services.wakeonlan.interfaces = [{
    interface = "enp0s25";
  }];
}
