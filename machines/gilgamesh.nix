{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
    ../modules/xserver.nix
    ../modules/desktop.nix
  ];

  # Machine-specific networking configuration.
  networking.hostName = "gilgamesh";
  # Generated via `head -c 8 /etc/machine-id`
  networking.hostId = "7a4bd408";

  # Enable nvidia driver
  services.xserver = {
    videoDrivers = [ "nvidia" ];
    displayManager.gdm.wayland = false;
  };
}
