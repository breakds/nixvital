{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
    ../modules/desktop.nix
    ../modules/web/nginx.nix
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
      enable = true;
    };
  };

  # Enable Nginx
  services.nginx.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?
}
