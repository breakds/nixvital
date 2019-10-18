{ config, lib, pkgs, ... }:

{
  # Add arcanist for phabricator related stuff.
  environment.systemPackages = with pkgs; [
    arcanist
  ];
}
