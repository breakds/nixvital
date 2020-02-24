{ config, pkgs, ... }:

{
  imports = [
    ./base
    ../nix-home/breakds
    ../modules/users
    ../modules/desktop
    ../modules/services/gitea.nix
    ../modules/services/nginx.nix
    ../modules/services/filerun.nix
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

  vital.filerun = {
    enable = true;
    domain = "files-monster.corp.weride.ai";
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
