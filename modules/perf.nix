# Tools for performance analyzing
#
# Largely inspired by Brendan Gregg

{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    sysstat
    linuxPackages.perf
    perf-tools # By Brendan Gregg
  ];
}
