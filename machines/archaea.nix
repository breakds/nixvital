{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
    ../modules/xserver.nix
    ../modules/dev/ros.nix
  ];

  # Machine-specific networking configuration.
  networking.hostName = "archaea";
  # Generated via `head -c 8 /etc/machine-id`
  networking.hostId = "867ce369";
}
