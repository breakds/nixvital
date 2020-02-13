# Tools for performance analyzing
#
# Largely inspired by Brendan Gregg

{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    sysstat
  ];
}
