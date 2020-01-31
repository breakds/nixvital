{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
    ../nix-home/breakds
    ../modules/user.nix
    ../modules/desktop
    ../modules/weride.nix
    ../modules/web/gitea.nix
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

  # Note that 8888 is allowed for IDE
  # And 7777 is allowed for arbitrary uses
  networking.firewall.allowedTCPPorts = [ 80 443 8888 7777 ];
  services.nginx = {
    enable = true;
    package = pkgs.nginxMainline;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    # TODO(breakds): Make this per virtual host.
    clientMaxBodySize = "100m";

    virtualHosts = {
      "monster.corp.weride.ai" = {
        enableACME = false;
        forceSSL = false;
        locations."/".proxyPass = "http://localhost:${toString (import ../data/resources.nix).ports.gitea}";
      };
    };
  };

  vital.gitea.enable = true;
  services.gitea.appName = "PNC Team Git Repo";

  # +------------+
  # | WakeOnLan  |
  # +------------+

  services.wakeonlan.interfaces = [{
    interface = "enp0s25";
  }];
}
